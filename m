Return-Path: <linux-kernel-owner+w=401wt.eu-S1754451AbYFRQ2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbYFRQ2z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 12:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYFRQ2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 12:28:45 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:41869 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751349AbYFRQ2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 12:28:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=4BYh6jUoRkdO99WfAofUYj/6oFD3gNpNGihYb2aXj5x4i7PI/ycVZcUN2PxBlF0TpuaaAet/TfzvYY3yLSaPaAQAzy4YVuG+2IhX7KTKFikvauYYIxTa4PCSZfmwVkhIxqoQt5NyoVfrRiW9rW1y6gfGJ5ZWSEUwFNATUPARTp4=  ;
X-YMail-OSG: ZG5F0bAVM1lhxqScPmXowpr4fyOOC1NWVluiipNt9qrhbFfRcIluZBne6dGS6FJuJDH0xjiIBWqWDXlemwpLXspjV_Y9pbMiqX8U43jdT5120nvRvc.Plra.6fUHg6_Esqw-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Woodruff, Richard" <r-woodruff2@ti.com>
Subject: Re: [PATCH] suppress needless timer reprogramming {tick-sched.c}
Date: Wed, 18 Jun 2008 09:28:41 -0700
User-Agent: KMail/1.9.9
Cc: Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "TK, Pratheesh Gangadhar" <pratheesh@ti.com>
References: <3B6D69C3A9EBCA4BA5DA60D91302742904554EE1@dlee13.ent.ti.com> <200806150130.32901.david-b@pacbell.net> <13B9B4C6EF24D648824FF11BE8967162035B963D16@dlee02.ent.ti.com>
In-Reply-To: <13B9B4C6EF24D648824FF11BE8967162035B963D16@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200806180928.42084.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 June 2008, Woodruff, Richard wrote:
> >
> > As measured using ETM trace this drops my reprogramming penalty from
> > almost 60% CPU load down to 15% during high interrupt rate.  If you like
> > I can send traces to show this.

More than doubling the available-for-real-use CPU time!  Impressive.

I'd imagine that many systems using reprogrammable 32K timers for
scheduling could win from such a patch, although not necessarily
quite so visibly as on this ARM unless their CPU clocks were also
in the 500+ MHz range.

Seems like a "law of unintended consequences" here.  Use a 32K
timer since it takes less power than a multi-MHz one, and so the
faster clocks can be gated off more comprehensively (in hardware)
to give more power savings.  Then throw NO_HZ on top to get one
more increment of power savings ... whoops, it was assuming that
it was dirt cheap to reprogram timers, major badness!

- Dave


