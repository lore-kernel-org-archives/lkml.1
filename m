Return-Path: <linux-kernel-owner+w=401wt.eu-S1756744AbYJPGUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbYJPGUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 02:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755972AbYJPGRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 02:17:15 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:59498 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756477AbYJPGRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 02:17:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:subject:message-id:reply-to:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent:from;
        b=JPUTfAODOoleKskUvypTrSiYt0Mgngay8sN+NmW0TBsbm1EqjZrS3KO/eD7e+uDwPo
         vW/pb3ftO+noM7qL1yYTJYKcR9Jjo3MeAYHH8b3SiwSgN/vEpqGz6aJVfZejSNhrUpDd
         OpwyTGUmF+jAbvaoM97aBL2Efmo5kWBlBL5xE=
Date: Thu, 16 Oct 2008 08:17:07 +0200
To: linux-kernel@vger.kernel.org
Subject: WARNING: at kernel/fork.c:940 copy_process+0x1a0/0x105e()
Message-ID: <20081016061707.GC32756@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is 2.6.27-4432-g459c1ca with pata tree on top of it but I don't think it
causes the following:

..

[    0.259161] NET: Registered protocol family 1
[    0.259898] Machine check exception polling timer started.
[    0.261976] ------------[ cut here ]------------
[    0.262040] WARNING: at kernel/fork.c:940 copy_process+0x1a0/0x105e()
[    0.262091] Modules linked in:
[    0.262172] Pid: 11, comm: khelper Not tainted 2.6.27-4432-g459c1ca-pata #2
[    0.262225] Call Trace:
[    0.262276]  [<c03009eb>] ? printk+0xf/0x14
[    0.262326]  [<c0122c18>] warn_on_slowpath+0x41/0x65
[    0.262378]  [<c013007b>] ? wait_for_helper+0x35/0x68
[    0.262431]  [<c0153601>] ? get_page_from_freelist+0x360/0x409
[    0.262483]  [<c015360a>] ? get_page_from_freelist+0x369/0x409
[    0.262537]  [<c013de7c>] ? mark_held_locks+0x53/0x6a
[    0.262588]  [<c013e01f>] ? trace_hardirqs_on+0xb/0xd
[    0.262639]  [<c013c827>] ? lockdep_init_map+0x74/0x3ae
[    0.262690]  [<c013e01f>] ? trace_hardirqs_on+0xb/0xd
[    0.262744]  [<c01ec91f>] ? __spin_lock_init+0x24/0x49
[    0.262795]  [<c01215e0>] copy_process+0x1a0/0x105e
[    0.262846]  [<c012255f>] do_fork+0xc1/0x1ff
[    0.262896]  [<c01017d0>] kernel_thread+0x75/0x7d
[    0.262948]  [<c012fe15>] ? ____call_usermodehelper+0x0/0x109
[    0.263012]  [<c012fe15>] ? ____call_usermodehelper+0x0/0x109
[    0.263065]  [<c0103b6c>] ? kernel_thread_helper+0x0/0x10
[    0.263758]  [<c012fdfb>] __call_usermodehelper+0x33/0x4d
[    0.263809]  [<c01302a4>] run_workqueue+0xd7/0x1b2
[    0.263860]  [<c0130287>] ? run_workqueue+0xba/0x1b2
[    0.263912]  [<c013e01f>] ? trace_hardirqs_on+0xb/0xd
[    0.263968]  [<c012fdc8>] ? __call_usermodehelper+0x0/0x4d
[    0.264031]  [<c0130436>] worker_thread+0xb7/0xc3
[    0.264083]  [<c013345b>] ? autoremove_wake_function+0x0/0x33
[    0.264135]  [<c013037f>] ? worker_thread+0x0/0xc3
[    0.264185]  [<c01331e1>] kthread+0x3b/0x61
[    0.264234]  [<c01331a6>] ? kthread+0x0/0x61
[    0.264284]  [<c0103b73>] kernel_thread_helper+0x7/0x10
[    0.264342] ---[ end trace a7919e7f17c0a725 ]---
[    0.271019] msgmni has been set to 999
[    0.271559] io scheduler noop registered

..

-- 
Regards/Gruss,
    Boris.
