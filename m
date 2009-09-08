Return-Path: <linux-kernel-owner+w=401wt.eu-S1752215AbZIHU4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbZIHU4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 16:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbZIHU4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 16:56:43 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:45112 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbZIHU4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 16:56:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=UrmDu5VtnNysGT5nhyJbBn6sechKQ/UtEPcd+ErCbX8jNAehekFKwO0AxWLrBXkVvz
         sDzQlJM4TdSFXQGiyNvnIW0xibiE79jwqMHuneMLAoJzWVvW+cBrbA0EMlypSvyjGjmb
         iwDNYquq4WyPCeSgQWB3/t4p52xP+nEoS7dFI=
Message-ID: <4AA6C4F5.7050306@gmail.com>
Date: Tue, 08 Sep 2009 16:56:21 -0400
From: Glenn Elliott <arakageeta.lkml@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>,
       Bjoern Brandenburg <bbb@cs.unc.edu>
Subject: Re: 2.6.31-rc8 + patch-2.6.31-rc8-rt9 = oops in mptsas
References: <4AA14523.7070405@gmail.com> <0D1E8821739E724A86F4D16902CE275C1C8EAE092F@inbmail01.lsi.com>
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C1C8EAE092F@inbmail01.lsi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Desai, Kashyap wrote:
> Glenn,
>
> There is one fix in same area recently posted to upstream.
> Can you try applying this patch?
>
> http://marc.info/?l=linux-scsi&m=125187353611068&w=2
>
> Thanks,
> Kashyap
>
> -----Original Message-----
> From: Glenn Elliott [mailto:arakageeta.lkml@gmail.com] 
> Sent: Friday, September 04, 2009 10:20 PM
> To: linux-kernel@vger.kernel.org
> Cc: tglx@linutronix.de; DL-MPT Fusion Linux; Bjoern Brandenburg
> Subject: 2.6.31-rc8 + patch-2.6.31-rc8-rt9 = oops in mptsas
>
> Hello,
>
> I get an oops when I boot 2.6.31-rc8 with the Realtime Preempt patch, 
> patch-2.6.31-rc8-rt9, on my IBM QS22 (Cell Blade-- PPC-based).  It 
> appears to be happening somewhere in the SAS disk related driver, mptsas.
>
> The unpatched 2.6.31-rc8 boots without issue.  I am using the 
> cell_defconfig configuration with the same minor additions (IPv6, 
> auditing, etc.) for both patched and unpatched kernels.  The RT-patched 
> configuration also includes the necessary RT-related settings.
>
> Below is the captured oops, with a little extra logging, from the serial 
> console (it didn't make it to /var/log/messages).  I would be happy to 
> provide any additional information.
>
> Thank you,
> Glenn Elliott
>
> mptscsih: ioc0: attempting task abort! (sc=c0000007fdd02080)
> sd 0:0:0:0: CDB: cdb[0]=0x1a: 1a 00 08 00 04 00
> mptscsih: ioc0: WARNING - Issuing Reset from mptscsih_IssueTaskMgmt!!
> mptbase: ioc0: Initiating recovery
> mptscsih: ioc0: task abort: SUCCESS (sc=c0000007fdd02080)
> mptscsih: ioc0: attempting task abort! (sc=c0000007fdd02080)
> sd 0:0:0:0: CDB: cdb[0]=0x0: 00 00 00 00 00 00
> mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
> mptbase: ioc0: Initiating recovery
> mptscsih: ioc0: WARNING - Issuing Reset from mptscsih_IssueTaskMgmt!!
> mptscsih: ioc0: task abort: SUCCESS (sc=c0000007fdd02080)
> mptscsih: ioc0: attempting target reset! (sc=c0000007fdd02080)
> sd 0:0:0:0: CDB: cdb[0]=0x1a: 1a 00 08 00 04 00
> mptscsih: ioc0: WARNING - TaskMgmt type=3: ioc_state: DOORBELL_ACTIVE 
> (0x2c000000)!
> mptscsih: ioc0: target reset: FAILED (sc=c0000007fdd02080)
> mptscsih: ioc0: attempting bus reset! (sc=c0000007fdd02080)
> sd 0:0:0:0: CDB: cdb[0]=0x1a: 1a 00 08 00 04 00
> mptscsih: ioc0: WARNING - TaskMgmt type=4: ioc_state: DOORBELL_ACTIVE 
> (0x2c000000)!
> mptscsih: ioc0: bus reset: FAILED (sc=c0000007fdd02080)
> mptscsih: ioc0: attempting host reset! (sc=c0000007fdd02080)
> mptscsih: ioc0: host reset: SUCCESS (sc=c0000007fdd02080)
> ------------[ cut here ]------------
> Badness at kernel/workqueue.c:372
> NIP: c000000000086a04 LR: c000000000087cac CTR: c00000000030c5b8
> REGS: c0000007fde230f0 TRAP: 0700   Not tainted  (2.6.31-rc8-rt9)
> MSR: 9000000000029032 <EE,ME,CE,IR,DR>  CR: 44022024  XER: 20000000
> TASK = c0000007fa3e5c50[2606] 'mpt/0' THREAD: c0000007fde20000 CPU: 2
> GPR00: 0000000000000001 c0000007fde23370 c0000000006992b0 c0000003fdde0c80
> GPR04: 0000000000000000 0000000000000000 000000000000000a c0000003fe0ce114
> GPR08: 0000000000000000 c0000007fa3e5c50 c00000000044ebb0 0000000000000000
> GPR12: 0000000000000000 c000000000722a00 0000000000000000 0000000000000004
> GPR16: c0000003fe0ce998 c0000003fe0ce968 0000000000000000 0000000000000000
> GPR20: 0000000000000001 0000000000000000 c0000003fe0ce108 0000000000000001
> GPR24: 0000000000000000 0000000000000001 c0000003fe0ce100 c0000003fe0ce720
> GPR28: c0000003fddf4000 c0000003fdde0c80 c000000000640080 0000000000000000
> NIP [c000000000086a04] .flush_cpu_workqueue+0x2c/0xa4
> LR [c000000000087cac] .flush_workqueue+0x68/0xb8
> Call Trace:
> [c0000007fde23370] [0000000000200200] 0x200200 (unreliable)
> [c0000007fde23470] [c000000000087cac] .flush_workqueue+0x68/0xb8
> [c0000007fde23500] [c00000000030c320] 
> .mptsas_cleanup_fw_event_q+0x128/0x154
> [c0000007fde235b0] [c00000000030c650] .mptsas_ioc_reset+0x98/0xe0
> [c0000007fde23640] [c0000000002f9610] .mpt_signal_reset+0x94/0xb4
> [c0000007fde236c0] [c0000000003018e4] .mpt_do_ioc_recovery+0x15ec/0x16e8
> [c0000007fde23890] [c000000000301ad8] .mpt_HardResetHandler+0xf8/0x19c
> [c0000007fde23930] [c00000000030215c] .mpt_config+0x3d4/0x470
> [c0000007fde23a30] [c0000000002ffd28] .mpt_findImVolumes+0xd0/0x6a0
> [c0000007fde23c00] [c00000000030dacc] 
> .mptsas_firmware_event_work+0x74/0x109c
> [c0000007fde23d90] [c0000000000876e8] .worker_thread+0x20c/0x2e0
> [c0000007fde23ea0] [c00000000008cb88] .kthread+0xa8/0xb4
> [c0000007fde23f90] [c000000000025b68] .kernel_thread+0x54/0x70
> Instruction dump:
> 4bfffe34 fba1ffe8 7c0802a6 f8010010 7c7d1b78 fbe1fff8 f821ff01 e80d01b0
> e92300a0 7c004a78 7c000074 7800d182 <0b000000> 48395349 60000000 38bd0038
>   
Thank you for your suggestion, Kashyap, but it does not appear to help. 
The system still hangs on boot. Is there any other information I can 
gather that may be helpful?

-Glenn
