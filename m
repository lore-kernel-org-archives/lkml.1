Return-Path: <linux-kernel-owner+w=401wt.eu-S1758248AbZEZWOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248AbZEZWOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbZEZWOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:14:11 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:47596 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbZEZWOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:14:10 -0400
Date: Tue, 26 May 2009 23:14:09 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: EeePC 900 trackpad often not detected at boot in 2.6.30-rc4
Message-ID: <20090526221409.GA27961@sucs.org>
References: <20090511072135.GA4682@sucs.org> <20090513032053.GA29919@dtor-d630.eng.vmware.com> <20090513185356.GA20140@sucs.org> <20090513191953.GA10629@sucs.org> <20090516032754.GC12099@dtor-d630.eng.vmware.com> <20090516032924.GD12099@dtor-d630.eng.vmware.com> <20090518084146.GA25806@sucs.org> <20090518094209.GA21150@sucs.org> <20090520024658.GD17649@dtor-d630.eng.vmware.com> <20090520083846.GH6736@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090520083846.GH6736@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20, 2009 at 10:38:46AM +0200, Ingo Molnar wrote:
> * Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > On Mon, May 18, 2009 at 10:42:10AM +0100, Sitsofe Wheeler wrote:
> > > On Mon, May 18, 2009 at 09:41:46AM +0100, Sitsofe Wheeler wrote:
> > > > 
> > > > And of course just as soon as I finish building a new kernel the issue
> > > > disappears. Even in older kernels that were seemingly showing the
> > > > problem all the time. Sigh.
> > > 
> > > After numerous reboots I finally managed to reproduce the problem the
> > > original way with your patch installed. I have no idea what the
> > > necessary triggers are but I suspect it involves suspend to ram...
> > 
> > It is just unfortunate scheduling that messes us up:
> > 
> > > [    4.267050] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [113]
> > > [    4.270440] drivers/input/serio/i8042.c: d4 -> i8042 (command) [116]
> > > [    4.271016] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [116]
> > > [    4.274883] ALSA device list:
> > > [    4.274963]   #0: HDA Intel at 0xf7eb8000 irq 16
> > > [    4.275258] TCP cubic registered
> > > [    4.276597] NET: Registered protocol family 17
> > > [    4.276802] Using IPI Shortcut mode
> > > [    4.279191]   Magic number: 9:810:70
> > > [    4.279548] rtc_cmos 00:03: setting system clock to 2009-05-18 09:03:27 UTC (1242637407)
> > > [    4.281412] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [127]
> > > [    4.283338] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [129]
> > > [    5.406620] libps2: errorneously fail 754 command
> > 
> > As you can see the device responded to our command and interrupt 
> > fired at 4.28 but for some reason the thread did not get woken up 
> > until 5.40, second and a half later... Crazy if you ask me.
> > 
> > Ingo, do you have any idea why would it not be woken up for so 
> > long???
> 
> possibly something else was running (looping?) in that time? A more 
> detailed trace would tell i guess.

What sort of options do I boot with for such a trace? Would
booting with initcall_debug be enough?

-- 
Sitsofe | http://sucs.org/~sits/
