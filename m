Return-Path: <linux-kernel-owner+w=401wt.eu-S1759634AbXKNDZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759634AbXKNDZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 22:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754697AbXKNDZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 22:25:16 -0500
Received: from smtp113.sbc.mail.mud.yahoo.com ([68.142.198.212]:44778 "HELO
	smtp113.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754675AbXKNDZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 22:25:15 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=PPxa4ln9mRKMETe/Hm/8LRHODA1eh7ukImhMS1mF/CnXH2poyZoZEZ9pkgWPC9ZHTvnTIsedjRx193NcAX9Jp5vwnxOybnVN4C/BImP1dfzpU3ktCK8VMQlKq0y47fbw4+COBzrH5E+xwEaIByxWbPoHo+D8b7MDQeY2LKefoV8=  ;
X-YMail-OSG: 1UiBph8VM1nW9UGhvGCn4MN.RKK9fUPUGqWebte29X10B1xAO5tmPxv97nSsLbkt2OT8Cbv4LdKJcGEB5Er4mibwQ_H0zV3Qld_.BqraOm.GB7Vw.Bs-
From: David Brownell <david-b@pacbell.net>
To: "eric miao" <eric.y.miao@gmail.com>
Subject: Re: [patch/rfc 1/4] GPIO implementation framework
Date: Tue, 13 Nov 2007 19:25:10 -0800
User-Agent: KMail/1.9.6
Cc: "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Felipe Balbi" <felipebalbi@users.sourceforge.net>,
       "Bill Gatliff" <bgat@billgatliff.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Andrew Victor" <andrew@sanpeople.com>,
       "Tony Lindgren" <tony@atomide.com>, "Jean Delvare" <khali@linux-fr.org>,
       "Kevin Hilman" <khilman@mvista.com>, "Paul Mundt" <lethal@linux-sh.org>,
       "Ben Dooks" <ben@trinity.fluff.org>
References: <200710291809.29936.david-b@pacbell.net> <f17812d70711131657wbdcc089kadb6024a47ad4a3@mail.gmail.com> <f17812d70711131700n74236a8naa6dbfc5cb62e42d@mail.gmail.com>
In-Reply-To: <f17812d70711131700n74236a8naa6dbfc5cb62e42d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711131925.11734.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2007, eric miao wrote:
> 
> Here comes a bunch of patches to illustrate my idea, some are not related to
> the point I mentioned, and they are not mature for now :-)
> 
> Subject: [PATCH 1/5] add gpio_is_onchip() for commonly used gpio range checking

I'll send substantive comments later, but meanwhile note
that the *CURRENT* version was posted last Friday:

  http://marc.info/?l=linux-kernel&m=119463810905330&w=2
  http://marc.info/?l=linux-kernel&m=119463811005344&w=2
  http://marc.info/?l=linux-kernel&m=119463811105352&w=2

Plus the appended tweak.  It's more useful to send patches
against current code, so applying them doesn't provide a
small avalanche of rejects.  :)


With respect to this patch adding gpio_is_onchip(), I
don't see a point.  The "gpio >= chip->base" check
is basically "are the data structures corrupted?" and
so it should only be done if "extra_checks" is defined.
(And IMO, not then ...)  And combining the other two tests
that way doesn't make anything more clear to me.  That's
somewhat of a style issue, I guess, unless you're like
me and don't much trust GCC to avoid extra instructions.

- Dave

