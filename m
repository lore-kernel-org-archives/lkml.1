Return-Path: <linux-kernel-owner+w=401wt.eu-S1761468AbXEWHJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761468AbXEWHJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 03:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756624AbXEWHJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 03:09:11 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:45947 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005AbXEWHJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 03:09:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Ei44qf7GP4JZJ/w40sa8gO7C1++qouQGnuAm64qvlrpHpIRT3enqO5ZGNDfI1K4UNRmZlv4q2Sl2yfkJScbkEN7l7iVt7MPBDKidNdbfjzQJ5qZB+UhBdCLjcV13AzUBtX6ePhwDAkKceclxMhqbs+6uEsTYWpYraWPHM5eQ3GE=
Subject: Re: [patch 00/69] -stable review
From: Romano Giannetti <romano.giannetti@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
In-Reply-To: <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org>
References: <20070521191612.800400000@sous-sol.org>
	 <4652070D.3090509@redhat.com>
	 <alpine.LFD.0.98.0705211406000.3890@woody.linux-foundation.org>
	 <20070521212522.GL3429@sequoia.sous-sol.org>
	 <1179870110.16656.2.camel@localhost>
	 <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 23 May 2007 09:09:00 +0200
Message-Id: <1179904140.7043.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(changing email. My employer server adds a stupid and malformed
disclaimer, so that vger refuses the post. Oh well. I will no trim the
quot to my original message so that it's here for anyone).

On Tue, 2007-05-22 at 15:07 -0700, Linus Torvalds wrote:
> 
> On Tue, 22 May 2007, Romano Giannetti wrote:
> > 
> > It's an useful patch for me. Without it, my sony vaio pcg-fx701 was very
> > erratic in resume (kernel 2.6.21.1; it works well with the .17 ubuntu
> > kernel). With this patch, I have done 7 cycles flawlessly. Even the
> > out-of-tree rtl8180 wireless driver [1] works ok across resumes. 
> 
> Ok, good to hear.
> 
> > The only problem is that there is an gaping delay of 60 seconds (more or
> > less) on resume. I have the syslog trace copied below; could be a timer
> > problem? Is it known? (It is scaring because the laptop seems dead
> > during this time. I'm not and expert, but it seems here:
> 
> It's not known, no, and yeah, that's scary (and 60 seconds is long enough 
> that most people would have grown bored and pushed the power button for 
> five seconds, having considered the resume a failure).
> 
> > [    1.617972] pcmcia: registering new device pcmcia1.0 
> > [   61.612517] PM: Writing back config space on device 0000:00:[...]
> > 
> > ...and time do not advance.
> 
> Do you mean that doing "date" twice does not increase the seconds? If so, 
> that's almost certainly related to the gaping delay. Which timer do you 
> end up using (what does "dmesg | grep clocksource" say)? Does adding 
> "clocksource=acpi_pm" to the kernel command line change things?
> 

I forgot to mention that I have Ingo cfs patch in. But I had the same
behaviour without, so I do not think it's related.

root@rukbat:/sys/power# dmesg | grep clock
[   19.600060] Time: tsc clocksource has been installed.
[   23.028323] Time: acpi_pm clocksource has been installed.

The "time do not advance was an error of my side... I was basing myself
on the timestamp on the syslog, but then realized that this has nothig
to do with the time at which te message is sent. 

Will try to reboot with clocksource=acpi_pm, althoughI think that this
is the one I'm using. 

> Also, what does your lspci look like?
> 
> 		Linus

00:00.0 Host bridge: VIA Technologies, Inc. VT8363/8365 [KT133/KM133] (rev 03)
00:01.0 PCI bridge: VIA Technologies, Inc. VT8363/8365 [KT133/KM133 AGP]
00:07.0 ISA bridge: VIA Technologies, Inc. VT82C686 [Apollo Super South] (rev 40)
00:07.1 IDE interface: VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
00:07.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 1a)
00:07.3 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 1a)
00:07.4 ISA bridge: VIA Technologies, Inc. VT82C686 [Apollo Super ACPI] (rev 40)
00:07.5 Multimedia audio controller: VIA Technologies, Inc. VT82C686 AC97 Audio Controller (rev 50)
00:07.6 Communication controller: VIA Technologies, Inc. AC'97 Modem Controller (rev 30)
00:0a.0 CardBus bridge: Texas Instruments PCI1420
00:0a.1 CardBus bridge: Texas Instruments PCI1420
00:0e.0 FireWire (IEEE 1394): Texas Instruments TSB12LV26 IEEE-1394 Controller (Link)
00:10.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)
01:00.0 VGA compatible controller: ATI Technologies Inc Rage Mobility P/M AGP 2x (rev 64)
02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8180L 802.11b MAC (rev 20)

By the way, suspend to disk (ehem... snapshot/restart) is busted too
(and yes, I have done the echo shutdown > /sys/power/disk thing, he
machine resumes but X no...worked like a charm in 2.6.17.13).

Romano 


