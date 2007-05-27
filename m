Return-Path: <linux-kernel-owner+w=401wt.eu-S1758154AbXE0Q2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154AbXE0Q2a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 12:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756355AbXE0Q2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 12:28:22 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756074AbXE0Q2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 12:28:22 -0400
Date: Sun, 27 May 2007 09:26:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Pavel Machek <pavel@ucw.cz>, Romano Giannetti <romanol@upcomillas.es>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
In-Reply-To: <20070527155738.GA20006@srcf.ucam.org>
Message-ID: <alpine.LFD.0.98.0705270924310.26602@woody.linux-foundation.org>
References: <1179870110.16656.2.camel@localhost>
 <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org>
 <1180008394.15600.26.camel@localhost> <alpine.LFD.0.98.0705240854250.26602@woody.linux-foundation.org>
 <20070524200435.GA9604@elf.ucw.cz> <alpine.LFD.0.98.0705241323361.26602@woody.linux-foundation.org>
 <20070524220017.GC9604@elf.ucw.cz> <alpine.LFD.0.98.0705241507050.26602@woody.linux-foundation.org>
 <20070524221743.GD9604@elf.ucw.cz> <alpine.LFD.0.98.0705241550030.26602@woody.linux-foundation.org>
 <20070527155738.GA20006@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 27 May 2007, Matthew Garrett wrote:
> 
> As far as I can tell the PPC code simply shuts down the devices without 
> worrying about userspace at all. If this was reliable, what prevents us 
> from simply disabling the freezer for STR?

Personally, I think that's the right thing to do. 

And by "disabling the freezer", I think we should just not call it at all. 
However, sadly, right now it's called from common code. I'll happily take 
a tested patch to split that code sequence up, and try to do it in 2.6.23, 
if somebody has the energy (I'm getting to the point where I may just do 
it myself, but my lazy nature still hopes for a STR person to step 
forward).

		Linus
