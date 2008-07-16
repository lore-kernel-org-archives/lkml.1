Return-Path: <linux-kernel-owner+w=401wt.eu-S1759455AbYGPKIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759455AbYGPKIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 06:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753040AbYGPKIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 06:08:16 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:36543 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185AbYGPKIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 06:08:15 -0400
Date: Wed, 16 Jul 2008 12:08:01 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Linux I2C <i2c@lm-sensors.org>
Subject: Re: [crash, bisected] I2C,  kobject (ffff81003e8c4160): tried to
 init an initialized object
Message-ID: <20080716120801.3e9b4c80@hyperion.delvare>
In-Reply-To: <20080716110702.3ca61eb2@hyperion.delvare>
References: <20080714224945.629446fa@hyperion.delvare>
	<20080716082352.GA30483@elte.hu>
	<20080716110702.3ca61eb2@hyperion.delvare>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jul 2008 11:07:02 +0200, Jean Delvare wrote:
> Hi Ingo,
> 
> On Wed, 16 Jul 2008 10:23:52 +0200, Ingo Molnar wrote:
> > 
> > hi Jean,
> > 
> > * Jean Delvare <khali@linux-fr.org> wrote:
> > 
> > >       i2c-nforce2: Add support for multiplexing on the Tyan S4985
> > 
> > -tip random boot testing started triggering the following upstream boot 
> > crash, starting two days ago when the i2c tree was merged:
> > 
> > [   11.772002] kobject (ffff81003e8c4160): tried to init an initialized object, something is seriously wrong.
> > [   11.784004] Pid: 1, comm: swapper Not tainted 2.6.26-00007-g279e902-dirty #19896
> > [   11.793651] 
> > [   11.793651] Call Trace:
> > [   11.793651]  [<ffffffff8054471a>] kobject_init+0x7a/0x80
> > [   11.798969]  [<ffffffff805f0f9d>] device_initialize+0x2d/0xd0
> > [   11.806323]  [<ffffffff805f19a1>] device_register+0x11/0x20
> > [   11.811903]  [<ffffffff8087ee3b>] i2c_register_adapter+0xab/0x1d0
> > [   11.817666]  [<ffffffff8087f0e6>] i2c_add_adapter+0x96/0xb0
> > [   11.823761]  [<ffffffff81196372>] nforce2_s4985_init+0x272/0x370
> > [   11.829358]  [<ffffffff8027516a>] ? getnstimeofday+0x3a/0xc0
> > [   11.835365]  [<ffffffff802728ba>] ? ktime_get_ts+0x4a/0x60
> > [   11.840853]  [<ffffffff81196100>] ? nforce2_s4985_init+0x0/0x370
> > [   11.846859]  [<ffffffff81160aa3>] kernel_init+0x123/0x300
> > [   11.852261]  [<ffffffff81160140>] ? early_idt_handler+0x0/0x74
> > [   11.857957]  [<ffffffff80228548>] child_rip+0xa/0x12
> > [   11.863781]  [<ffffffff81160140>] ? early_idt_handler+0x0/0x74
> > [   11.868757]  [<ffffffff81160980>] ? kernel_init+0x0/0x300
> > [   11.874160]  [<ffffffff8022853e>] ? child_rip+0x0/0x12
> > [   11.879989] 
> > [   11.881141] general protection fault: 0000 [1] SMP 
> > [   11.881141] CPU 1 

Good news: I can reproduce this locally. Stay tuned...

-- 
Jean Delvare
