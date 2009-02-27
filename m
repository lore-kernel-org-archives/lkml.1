Return-Path: <linux-kernel-owner+w=401wt.eu-S1761184AbZB0Vvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761184AbZB0Vvu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 16:51:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758835AbZB0Vvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 16:51:39 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:54498 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757871AbZB0Vvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 16:51:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ce7bu4d3iAkot741Cx7isSFQFWuy16/Hx5A7oreQmbKQf3Fd/qLJD5dleS0mVQd9EC
         0HIDKUaydXY9+LT7FMfLRMmjkXsEYurNUn9b87xwZy+aEB/ctUEOpMeC69baE537TPPL
         E/1x6PkNOE7wlggPniuKJgfyAoNgQSwosgfxc=
Date: Fri, 27 Feb 2009 19:55:14 +0100
From: Richard Zidlicky <rz@linux-m68k.org>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, Geert.Uytterhoeven@sonycom.com,
       David Woodhouse <dwmw2@infradead.org>, linux-parisc@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       David@ozlabs.org, Kyle McMartin <kyle@mcmartin.ca>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [rtc-linux] Re: [PATCH/RFC 0/5] Generic RTC class driver
Message-ID: <20090227185514.GA1071@linux-m68k.org>
References: <1235144809-32468-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <20090220170454.04382e9e@i1501.lan.towertech.it> <alpine.LRH.2.00.0902231319170.22762@vixen.sonytel.be> <1235511327.18632.73.camel@macbook.infradead.org> <20090224231154.60ba18d6@i1501.lan.towertech.it> <1235514727.18632.93.camel@macbook.infradead.org> <alpine.LRH.2.00.0902251059110.4063@vixen.sonytel.be> <20090225111836.621412c1@i1501.lan.towertech.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090225111836.621412c1@i1501.lan.towertech.it>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 11:18:36AM +0100, Alessandro Zummo wrote:
> On Wed, 25 Feb 2009 11:00:13 +0100 (CET)
> Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:
> 
> > I didn't know NTP was broken with RTC class drivers?
> > 
> > So we should actually keep on using genrtc instead of rtc-ppc/rtc-generic for
> > now? ;-)
> 
>  broken here means that the kernel won't save the time to the hardware
>  rtc every 11 minutes as it used to do. normal NTP operations are unaffected.

seems like so far ppc is the only architecture attempting to implement it
correctly, all others either have it unimplemented or use the broken
by design set_rtc_mmss method. 
Also note that in most cases hwclock has much better possibilities
to do a good job.

Regarding genrtc vs rtc-ppc/rtc-generic it is worth noting that genrtc
provides RTC_UIE emulation which is of some use for exotic programs like 
"chrony".
Afaics this is also the only situation without a good userspace workaround 
and chrony never worked well for me so I have nothing against junking the 
code.

Regarding a possible reorganisation from the generic to all separate drivers
I agree that the habit of putting rtc-chip specific code in asm-generic is 
confusing at best. 
In many cases such code might be better placed in drivers/rtc or 
include/linux/rtc/chipname.

Imho this does not preclude the possibility to use a generic framework. While
there certainly are valid reasons to have separate drivers in some cases 
I do not see much value in rewriting everything as separate drivers where 
the generic framework works well.

Richard
