Return-Path: <linux-kernel-owner+w=401wt.eu-S1761459AbYDSCt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761459AbYDSCt6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 22:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbYDSCtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 22:49:51 -0400
Received: from web36708.mail.mud.yahoo.com ([209.191.85.42]:22753 "HELO
	web36708.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751368AbYDSCtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 22:49:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=zy/Qt111pOKOKG3gf+HbuWix5uBn7SUqWc11k0MNKRUEpcZfuHLNAzL7CII5hQVOCAZ/8cfQz9DujBpvqnt3rd9PUxFHEzp3MwaXH7cCsyqiWFUys5VNkdOI3R4+ZEUxVcz7Ivvs7nPMkSMd3vLka3csYfhDVWcUxEEeD9TMsKw=;
X-YMail-OSG: kiG_5FoVM1kZP9QwLOacbtjmCfszrcF0EnkDMPR23nB4gkCy2G1NzwkVFIH6vHYkV9xpvOUSMPHWQyDjeb50U8vElr4_Rzd9NkjsqQUyAlEhdIrhA1rfmBQEqQ--
Date: Fri, 18 Apr 2008 19:49:45 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: Smartmedia/xd card support - request for comments
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, joern@logfs.org, ben@fluff.org
In-Reply-To: <alpine.LFD.1.10.0804181126350.3261@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <51700.66276.qm@web36708.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Third, there's no attempt made by mtd to support advanced
> > functionality present in many smartmedia and all memorystick
> > readers: adapter side copy and multi page programming (this mostly
> > relates to memorystick, of course). I also failed to see any support
> > for device writing policy, needed to discern, for example,
> > sequential page programmable devices vs. block programmable
> > devices. I also failed to see an unified approach to page-accessible
> > devices, meaning duplication of "bouncing" code in the backends.
> 
> And instead of addressing the missing features and shortcomings you
> add a new duplicated code layer which is only useful for a restricted
> set of hardware.
> 
> > Considering all this, amount of effort needed for satisfactory
> > support of smartmedia through mtd was found by me to be far greater
> > than coming with stand-alone implementation.
> 
> Yeah and you made this decision on your own w/o even discussing the
> issues at hand with the mtd developers before implementing a separate
> code stack. And now we should be impressed and merge it. That's not
> the way it works.
> 

I do not expect you, or anybody, to be "impressed" with anything. As I said before, from my
analysis of mtd it will require a great deal of patching to acquire certain functionality. This
will invariably require a large time span, as many people depend on the mtd in it present state.

If your position on the proposed interim solution is definite "no", I'll make an effort to rewrite
the driver in the mtd-friendly way.

This brings me to the first technical question:

mtd_blkdevs breaks the block layer request into separate pages, effectively disabling lower layer
from making decision based on a real data block size, and using dma to any useful extent. What is
the proposed way to deal with this?

(By the way, first question already puts us into a "quirk" area of the statement "smartmedia are
flash chips with quirks". Both memorystick and smartmedia are always operated in tandem with their
controllers, as you could notice.)



      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
