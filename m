Return-Path: <linux-kernel-owner+w=401wt.eu-S1763508AbYBTOXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763508AbYBTOXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 09:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbYBTOXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 09:23:10 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:33177 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510AbYBTOXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 09:23:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=C2RkXpcb5KgtiDjaULc63LP4Fzo19LcKoIIO47aq3eWJq/kIclLQsSF93eEfAFUnuJ6NdN4KzepbLj/sInVVUrVecS4J3b/UHFnayQH8ZOId+/RkqbyFB8rvwD1eJvQeJ9+/vue9TsWu2H+hE0ZsSgABNNuVjmAqUnKpUh4IjTE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [BUG] next-20080219 -  ide oops while bootup at ide_device_add_all ()
Date: Wed, 20 Feb 2008 15:32:01 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       sfr@canb.auug.org.au, Andy Whitcroft <apw@shadowen.org>
References: <47BBA2D6.7020909@linux.vnet.ibm.com>
In-Reply-To: <47BBA2D6.7020909@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802201532.01616.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday 20 February 2008, Kamalesh Babulal wrote:
> Hi, 
> 
> The next-20080219 kernel oops while booting up on x86_64 box. This bug
> was fixed in the 2.6.24-git(s) with the patch posted at
> http://lkml.org/lkml/2008/2/11/350 
> 
> ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> BUG: unable to handle kernel paging request at ffffffff80a37b8d
> IP: [<ffffffff8039470a>] ide_device_add_all+0x1a5/0x517
> PGD 203067 PUD 207063 PMD 0 
> Oops: 0000 [1] SMP 
> last sysfs file: 
> CPU 1 
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.25-rc2-autotest-next-20080219 #1
> RIP: 0010:[<ffffffff8039470a>]  [<ffffffff8039470a>] ide_device_add_all+0x1a5/0x517
> RSP: 0000:ffff8101e7125db0  EFLAGS: 00010206
> RAX: 00000000000a8000 RBX: 0000000000000009 RCX: 0000000000000009
> RDX: ffff8101e7125e60 RSI: 0000000000000000 RDI: ffff8101e7125e60
> RBP: 0000000000000000 R08: 0000000000000000 R09: ffff8101e68de870
> R10: 0000000000000177 R11: 0000000000000174 R12: ffffffff80990080
> R13: 0000000000000000 R14: 000000000000000a R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff8101e710d740(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: ffffffff80a37b8d CR3: 0000000000201000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 1, threadinfo ffff8101e7124000, task ffff8101e7123200)
> Stack:  ffff8101e7125e60 0000000000000009 00000000000001f0 ffffffff80990080
>  0000000000000001 000000000000000a 0000000000000000 ffffffff8088d725
>  0000000000000170 0000000000000171 0000000000000172 0000000000000173
> Call Trace:
>  [<ffffffff8088d725>] ide_generic_init+0x169/0x1d8
>  [<ffffffff808706f7>] kernel_init+0x17d/0x2e9
>  [<ffffffff8020cc78>] child_rip+0xa/0x12
>  [<ffffffff8087057a>] kernel_init+0x0/0x2e9
>  [<ffffffff8020cc6e>] child_rip+0x0/0x12
> 
> 
> Code: 49 ff c5 49 83 fe 0a 0f 85 97 fe ff ff 45 31 ed 48 8b 14 24 41 8a 44 15 00 3c ff 0f 84 4d 01 00 00 0f b6 c0 48 69 c0 00 0c 00 00 <80> b8 8d fb 98 80 0d 48 8d 98 80 f4 98 80 75 15 48 8b 80 88 f4 
> RIP  [<ffffffff8039470a>] ide_device_add_all+0x1a5/0x517
>  RSP <ffff8101e7125db0>
> CR2: ffffffff80a37b8d
> ---[ end trace 31f82065a26d65bf ]---
> Kernel panic - not syncing: Attempted to kill init!

This is fixed now (thanks to Johann Felix Soden).

http://marc.info/?l=linux-ide&m=120351576111554&w=2

[ actually this bug is a good thing because it is clear now that people
  are actively testing linux-next ;-) ]

Thanks,
Bart
