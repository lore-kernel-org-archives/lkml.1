Return-Path: <linux-kernel-owner+w=401wt.eu-S967878AbXFHJP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967878AbXFHJP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 05:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932071AbXFHJPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 05:15:48 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:6480 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936729AbXFHJPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 05:15:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HZkAd0AVH5je9pWWsTNknpGUEZ9sgvMMtubG+TV3fN5HyeBb9CPFY+WQ7QHKCW7Q+gyzn0fafxgUMJ9CczAEctawGc823eMDeaR+I8VvykZV2OWifEvnxYuAfbGHhu178fDA0tmHmJbWKWhaOtOBbR4mZmqVRAzPbU99pCt3nrA=
Message-ID: <3877989d0706080215x22f35292g8cb999f8720cd87c@mail.gmail.com>
Date: Fri, 8 Jun 2007 17:15:45 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.22-rc4-mm1 -- x86_64 ACPI panic
Cc: "Andy Whitcroft" <apw@shadowen.org>, linux-kernel@vger.kernel.org,
       "Len Brown" <len.brown@intel.com>, "Yu, Luming" <luming.yu@intel.com>,
       "Alexey Starikovskiy" <alexey.y.starikovskiy@intel.com>,
       linux-acpi@vger.kernel.org
In-Reply-To: <20070606105223.c8dece17.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070606020737.4663d686.akpm@linux-foundation.org>
	 <4666BDF1.6080801@shadowen.org>
	 <20070606105223.c8dece17.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The only problem known as to the acpi throttling changes in the mm tree
is a typo ,and the patch to fix it is available here.  Please test and
get results back to me. BTW,the log shows that the acpi-cpufreq.ko has
problem. Would please also try not to load acpi-cpufreq.

http://www.ussg.iu.edu/hypermail/linux/kernel/0706.0/2509.html

On 6/7/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 06 Jun 2007 15:00:17 +0100 Andy Whitcroft <apw@shadowen.org> wrote:
>
> > Getting this on a bigger x86_64 (bl6-13):
> >
> > Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP:
> >  [<ffffffff8037898b>] acpi_processor_throttling_seq_show+0xa7/0xd6
> > PGD 2d77067 PUD 34c3067 PMD 0
> > Oops: 0000 [1] SMP
> > CPU 3
> > Modules linked in: video output button battery asus_acpi ac lp
> > parport_pc parport floppy nvram amd_rng rng_core i2c_amd756 i2c_core
> > Pid: 1634, comm: head Not tainted 2.6.22-rc4-mm1-autokern1 #1
> > RIP: 0010:[<ffffffff8037898b>]  [<ffffffff8037898b>]
> > acpi_processor_throttling_seq_show+0xa7/0xd6
> > RSP: 0018:ffff810003c9de48  EFLAGS: 00010246
> > RAX: 0000000000000020 RBX: ffff8100029e7800 RCX: 0000000000000000
> > RDX: 000000000000002a RSI: ffffffff805993e4 RDI: ffff810002d714c0
> > RBP: ffff810002d714c0 R08: ffff810003f82051 R09: ffff810002d714c0
> > R10: ffffffffffffffff R11: 0000000000000000 R12: 0000000000000000
> > R13: 0000000000000000 R14: 0000000000000000 R15: 00007fff64fd2b90
> > FS:  00002b3545aec6f0(0000) GS:ffff810001683a40(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > CR2: 0000000000000000 CR3: 0000000003966000 CR4: 00000000000006e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Process head (pid: 1634, threadinfo ffff810003c9c000, task ffff810001c8c810)
> > Stack:  00000000000000d0 ffff810002d714c0 0000000000000001 0000000000000001
> >  0000000000002000 ffffffff802ab6eb ffff810003c9df50 ffff810002915d00
> >  ffff810002d714f0 ffff810002fa2000 0000000000000000 fffffffffffffffb
> > Call Trace:
> >  [<ffffffff802ab6eb>] seq_read+0x105/0x28e
> >  [<ffffffff802ab5e6>] seq_read+0x0/0x28e
> >  [<ffffffff802cd085>] proc_reg_read+0x80/0x9a
> >  [<ffffffff802925a7>] vfs_read+0xcb/0x153
> >  [<ffffffff80292943>] sys_read+0x45/0x6e
> >  [<ffffffff8020bc5e>] system_call+0x7e/0x83
> >
> >
> > Code: 45 8b 44 0d 00 44 89 e1 0f 45 d0 31 c0 49 ff c4 49 83 c5 28
> > RIP  [<ffffffff8037898b>] acpi_processor_throttling_seq_show+0xa7/0xd6
> >  RSP <ffff810003c9de48>
> > CR2: 0000000000000000
> > FATAL: Error inserting acpi_cpufreq
> > (/lib/modules/2.6.22-rc4-mm1-autokern1/kernel/arch/x86_64/kernel/cpufreq/acpi-cpufreq.ko):
> > No such device
>
> Was the oops at modprobe time?  If so, it seems weird that
> acpi_processor_throttling_seq_show() would be getting run at that stage.
>
> (The oops trace is supposed to show the oopsing process's
> task_struct.comm[], but it isn't shown here?)
>
> Anyway, there are extensive changes in there added by git-acpi.patch.  I
> suppose we can try to limp along with the below, but it'll probably just
> oops later on.
>
> --- a/drivers/acpi/processor_throttling.c~git-acpi-disable-acpi_processor_throttling_seq_show
> +++ a/drivers/acpi/processor_throttling.c
> @@ -648,6 +648,9 @@ static int acpi_processor_throttling_seq
>                goto end;
>        }
>
> +       seq_puts(seq, "acpi_processor_throttling_seq_show() is busted\n");
> +       goto end;
> +
>        seq_printf(seq, "state count:             %d\n"
>                   "active state:            T%d\n"
>                   "state available: T%d to T%d\n",
> _
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
