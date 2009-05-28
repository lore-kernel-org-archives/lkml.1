Return-Path: <linux-kernel-owner+w=401wt.eu-S1763452AbZE1Qtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763452AbZE1Qtz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 12:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbZE1Qtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 12:49:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:37070 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbZE1Qtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 12:49:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=T2ZQf0uodnsYBEWm4X2Za2STuXUEN+jQd5P0to1UabPySnfaLQCxi2VCHG0GhPvFfZ
         BypMQFjkHOwgVCGS9U+YBGxpYfAJgnNlFxR+0WYOtkWJgiSHzQfteiCUhDJbjqgixHQz
         qGQYWIvXnlUYx8rsIbDe3BtvZ6NCshLL6AKn0=
Date: Thu, 28 May 2009 09:49:43 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, mingo@elte.hu
Subject: Re: EeePC 900 trackpad often not detected at boot in 2.6.30-rc4
Message-ID: <20090528164942.GC18589@dtor-d630.eng.vmware.com>
References: <20090511072135.GA4682@sucs.org> <20090520024658.GD17649@dtor-d630.eng.vmware.com> <20090520054739.GA31552@sucs.org> <200905200025.20280.dmitry.torokhov@gmail.com> <20090526222049.GB27961@sucs.org> <20090528155401.GB18589@dtor-d630.eng.vmware.com> <20090528164231.GA19324@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528164231.GA19324@sucs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 05:42:31PM +0100, Sitsofe Wheeler wrote:
> On Thu, May 28, 2009 at 08:54:01AM -0700, Dmitry Torokhov wrote:
> > On Tue, May 26, 2009 at 11:20:49PM +0100, Sitsofe Wheeler wrote:
> > > I only just saw your reply. After about 50 boots the following occurred:
> > > 
> > > [    3.136500] drivers/input/serio/i8042.c: d4 -> i8042 (command) [1964]
> > > [    3.137015] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [1964]
> > > [    3.140289] ALSA device list:
> > > [    3.140367]   #0: HDA Intel at 0xf7eb8000 irq 16
> > > [    3.140591] TCP cubic registered
> > > [    3.140666] NET: Registered protocol family 17
> > > [    3.140846] Using IPI Shortcut mode
> > > [    3.142878]   Magic number: 9:412:804
> > > [    3.143418] rtc_cmos 00:03: setting system clock to 2009-05-26 21:47:18 UTC (1243374438)
> > > [    3.149589] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [1977]
> > > [    3.151638] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [1979]
> > > [    5.550332] libps2: BINGO!
> > > [    5.550425] drivers/input/serio/i8042.c: d4 -> i8042 (command) [4378]
> > > [    5.551011] drivers/input/serio/i8042.c: f6 -> i8042 (parameter) [4378]
> > > [    5.563688] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [4391]
> > > [    5.563736] drivers/input/serio/i8042.c: d4 -> i8042 (command) [4391]
> > > [    5.564673] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [4391]
> > > [    5.572824] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [4400]
> > > [    5.572863] drivers/input/serio/i8042.c: d4 -> i8042 (command) [4400]
> > > [    5.573811] drivers/input/serio/i8042.c: 0a -> i8042 (parameter) [4400]
> > > [    5.580823] ACPI: Battery Slot [BAT0] (battery present)
> > 
> > Was the mouse in working condition after that? I can't tell from the
> > dmesg since it is trimmed...
> 
> Ah sorry. The mouse/trackpad interrupts (in /proc/interrupts) definitely
> rose (when it goes wrong they usually remain static on some value like
> 15).
> 

OK, great. I also see the mouse is being detected further down in dmesg
now.

> 
> In neither case did I go to X because having the debugging leads to huge
> logs in /var

You can shut off the debugging from userspace by doing:

	echo 0 > /sys/module/i8042/parameters/debug

> but I was rebooting until the following script started
> outputting BINGO!:
> 
> #!/bin/sh
> mount /proc
> grep 12: /proc/interrupts
> dmesg | grep -i bingo
> 
> On a normal boot there will be exactly 115 interrupts if the trackpad
> hasn't been touched but everything is OK just after booting. If there
> are less interrupts you know something has gone wrong...
> 

OK, I guess I will be pushin this to Linus then... Thank you for
testing.

-- 
Dmitry
