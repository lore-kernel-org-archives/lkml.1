Return-Path: <linux-kernel-owner+w=401wt.eu-S1756853AbYHKTnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbYHKTnM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 15:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753773AbYHKTm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 15:42:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59968 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098AbYHKTm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 15:42:57 -0400
Date: Mon, 11 Aug 2008 21:42:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh <jaswinderlinux@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Oruba <peter.oruba@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: BUG: scheduling while atomic: swapper/1/0x00000002 in
	2.6.27-rc1-tip
Message-ID: <20080811194240.GJ12788@elte.hu>
References: <3f9a31f40808052015n400ef4d3p19f11a7e57084371@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9a31f40808052015n400ef4d3p19f11a7e57084371@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh <jaswinderlinux@gmail.com> wrote:

> Hello Ingo,
> 
> I am getting this while booting :
> 
> hub 4-0:1.0: USB hub found
> hub 4-0:1.0: 2 ports detected
> BUG: scheduling while atomic: swapper/1/0x00000002
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.27-rc1-tip #13
>  [<c03ab719>] schedule+0xa9/0x68a
>  [<c01e7dff>] idr_get_empty_slot+0x13b/0x1e5
>  [<c01e7dff>] idr_get_empty_slot+0x13b/0x1e5
>  [<c03abe38>] schedule_timeout+0x13/0x99
>  [<c01170db>] __wake_up+0x29/0x39
>  [<c03ab5b9>] wait_for_common+0xab/0x105
>  [<c0119cb7>] default_wake_function+0x0/0x8
>  [<c0129d8d>] call_usermodehelper_exec+0x62/0xa2
>  [<c01e905c>] kobject_uevent_env+0x2d4/0x308
>  [<c0264418>] device_add+0x3ab/0x4e6
>  [<c02645db>] device_create_vargs+0x78/0x99
>  [<c026461a>] device_create+0x1e/0x24
>  [<c023df7d>] misc_register+0xb4/0xef
>  [<c010f696>] microcode_init+0x2a/0xb0
>  [<c010103a>] _stext+0x3a/0x12a
>  [<c04cb47e>] microcode_intel_module_init+0x0/0x35
>  [<c0119cae>] try_to_wake_up+0x154/0x15d
>  [<c012a402>] __create_workqueue_key+0xcf/0x1c1
>  [<c04c0627>] kernel_init+0x177/0x1db
>  [<c04c04b0>] kernel_init+0x0/0x1db
>  [<c0103923>] kernel_thread_helper+0x7/0x10
>  =======================
> BUG: scheduling while atomic: swapper/1/0x00000002
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.27-rc1-tip #13
>  [<c03ab719>] schedule+0xa9/0x68a
>  [<c01e7dff>] idr_get_empty_slot+0x13b/0x1e5
>  [<c03abe38>] schedule_timeout+0x13/0x99
>  [<c01170db>] __wake_up+0x29/0x39
>  [<c03ab5b9>] wait_for_common+0xab/0x105
>  [<c0119cb7>] default_wake_function+0x0/0x8
>  [<c0129d8d>] call_usermodehelper_exec+0x62/0xa2
>  [<c01e905c>] kobject_uevent_env+0x2d4/0x308
>  [<c0264418>] device_add+0x3ab/0x4e6
>  [<c01eb2d0>] strlcpy+0x11/0x3d
>  [<c02665b4>] platform_device_add+0xc9/0xf7
>  [<c026673c>] platform_device_register_simple+0x34/0x4a
>  [<c010f70c>] microcode_init+0xa0/0xb0
>  [<c010103a>] _stext+0x3a/0x12a
>  [<c04cb47e>] microcode_intel_module_init+0x0/0x35
>  [<c0119cae>] try_to_wake_up+0x154/0x15d
>  [<c012a402>] __create_workqueue_key+0xcf/0x1c1
>  [<c04c0627>] kernel_init+0x177/0x1db
>  [<c04c04b0>] kernel_init+0x0/0x1db
>  [<c0103923>] kernel_thread_helper+0x7/0x10
>  =======================
> Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>
> <peter.oruba@amd.com>
> initcall microcode_intel_module_init+0x0/0x35 returned with preemption
> imbalance
> highmem bounce pool size: 64 pages
> 
> 
> Attaching config for reference.

i've Cc:-ed Peter Oruba who has changed this code recently. Peter, 
there's apparently a preemption count leak in the new microcode 
codepaths. Either a missing unlock or some cpu_get/put imbalance or 
similar mishap. Any ideas?

	Ingo
