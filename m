Return-Path: <linux-kernel-owner+w=401wt.eu-S1762202AbZE1PyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762202AbZE1PyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 11:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754554AbZE1PyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 11:54:08 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:38556 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbZE1PyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 11:54:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Rt50XEF8ncX028t5y3BjVOCuHY6eeKyt41DqbAFXOzMJjWPAAwmEsqsG3i7l39i65m
         AzUWh3G0IQQPay4J0yfhZ/uWwuo0em5Tvss6Z+5lEhAd7HpeXyIpyY5DnAl8dPUrxN+r
         2s93jMCaXS9ELu7qJH8GL1vG16FI3B0kU3daY=
Date: Thu, 28 May 2009 08:54:01 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, mingo@elte.hu
Subject: Re: EeePC 900 trackpad often not detected at boot in 2.6.30-rc4
Message-ID: <20090528155401.GB18589@dtor-d630.eng.vmware.com>
References: <20090511072135.GA4682@sucs.org> <20090520024658.GD17649@dtor-d630.eng.vmware.com> <20090520054739.GA31552@sucs.org> <200905200025.20280.dmitry.torokhov@gmail.com> <20090526222049.GB27961@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526222049.GB27961@sucs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 11:20:49PM +0100, Sitsofe Wheeler wrote:
> On Wed, May 20, 2009 at 12:25:19AM -0700, Dmitry Torokhov wrote:
> >
> > On Tuesday 19 May 2009 22:47:39 Sitsofe Wheeler wrote:
> >
> > > This one could be tough to test unless there is a way of forcing the
> > > awkward scheduling...
> > 
> > Umm.... you could try sticking
> > 
> > 	if (timeout == 0)
> > 		printk(KERN_INFO "libps2: BINGO!\n");
> > 
> > 
> > into the body of "if (psmouse->cmdcnt ...)" statement that was modified
> > by the patch I sent and see if it gets activated. If your mouse still
> > works with this message in the logs then the patch is working.
> 
> I only just saw your reply. After about 50 boots the following occurred:
> 
> [    3.136500] drivers/input/serio/i8042.c: d4 -> i8042 (command) [1964]
> [    3.137015] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [1964]
> [    3.140289] ALSA device list:
> [    3.140367]   #0: HDA Intel at 0xf7eb8000 irq 16
> [    3.140591] TCP cubic registered
> [    3.140666] NET: Registered protocol family 17
> [    3.140846] Using IPI Shortcut mode
> [    3.142878]   Magic number: 9:412:804
> [    3.143418] rtc_cmos 00:03: setting system clock to 2009-05-26 21:47:18 UTC (1243374438)
> [    3.149589] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [1977]
> [    3.151638] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [1979]
> [    5.550332] libps2: BINGO!
> [    5.550425] drivers/input/serio/i8042.c: d4 -> i8042 (command) [4378]
> [    5.551011] drivers/input/serio/i8042.c: f6 -> i8042 (parameter) [4378]
> [    5.563688] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [4391]
> [    5.563736] drivers/input/serio/i8042.c: d4 -> i8042 (command) [4391]
> [    5.564673] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [4391]
> [    5.572824] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [4400]
> [    5.572863] drivers/input/serio/i8042.c: d4 -> i8042 (command) [4400]
> [    5.573811] drivers/input/serio/i8042.c: 0a -> i8042 (parameter) [4400]
> [    5.580823] ACPI: Battery Slot [BAT0] (battery present)
> 

Was the mouse in working condition after that? I can't tell from the
dmesg since it is trimmed...

> Another 50 boots later something similar happened:
> 
> [    1.386099] drivers/input/serio/i8042.c: d4 -> i8042 (command) [292]
> [    1.386888] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [292]
> [    1.395793] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [301]
> [    1.398353] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [304]
> [    1.398768] drivers/input/serio/i8042.c: d4 -> i8042 (command) [304]
> [    1.399339] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [304]
> [    1.410073] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [316]
> [    1.411730] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [317]
> [    3.061408] libps2: BINGO!
> [    3.061496] drivers/input/serio/i8042.c: d4 -> i8042 (command) [1967]
> [    3.062009] drivers/input/serio/i8042.c: f6 -> i8042 (parameter) [1967]

What happened with the mouse here?

-- 
Dmitry
