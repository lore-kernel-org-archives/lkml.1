Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbZCBWJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbZCBWJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 17:09:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754581AbZCBWJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 17:09:26 -0500
Received: from n25.bullet.mail.mud.yahoo.com ([68.142.206.220]:27173 "HELO
	n25.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754556AbZCBWJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 17:09:25 -0500
X-Yahoo-Newman-Id: 407889.65961.bm@omp410.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:Reply-To:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=HtlOs99PT2W28Cz1rDC8x8RFgbHTgnUk4jXnAEsaZoVdZ70YJvw6MFJILF6kh+zNDXxYaDJFaFDWHiy1YV6UnUPL/x3F+ksx45vwVrVpuxexAjzaawGSvf0vpBwuWnkAoeYFxMK+MeiBVdzDqOupiDePHl7DSbS8CLpTRBoShR4=  ;
X-YMail-OSG: zbykLecVM1nRVH.TcUbFYDebnM6P.9xbudNHeygowztQpv9EuEbGYhapNrHukDLVROUUZ7p6LTQjjOQuc_AKzLoaaHauKIdwv334g6dKD2LFFOhZ_qjTUdFHakOK6YBHK1520g_t.0ZQ3ZUBkyX1NgSh__ajm_4QUnB861UnsZdsF0xONlKKZJXxijmG
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
Reply-To: dbrownell@users.sourceforge.net
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: lockdep and threaded IRQs (was: ...)
Date: Mon, 2 Mar 2009 14:09:20 -0800
User-Agent: KMail/1.9.10
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200903021337.20887.david-b@pacbell.net> <1236030106.5330.1553.camel@laptop>
In-Reply-To: <1236030106.5330.1553.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903021409.21344.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 March 2009, Peter Zijlstra wrote:
> > > How so?, its the natural extension of that work.
> > 
> > Not the work to shrink the amount of time IRQ latencies
> > by shrinking the amount of time IRQs are disabled by
> > IRQ handlers.
> 
> Ugh, that's done by pushing work out of the hardirq context,

That's one of many techniques currently used.

Tradeoffs don't always favor larger driver updates
and re-validation though.  Sometimes it's simpler
to just leverage the reality that "hardirq context"
does not require using IRQF_DISABLED.


> not by doing silly things like enabling irqs from hardirq context.

Somehow I'm certain you have NOT analysed every one of the
thousands of IRQ handlers in various Linux drivers to know
with certainty that's not the reason IRQ_DISABLED is cleared.

There are also *other* reasons to leave IRQ_DISABLED clear.

- Dave

