Return-Path: <linux-kernel-owner+w=401wt.eu-S1756844AbYGCIVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844AbYGCIVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 04:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbYGCIQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 04:16:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40240 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754523AbYGCHDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 03:03:04 -0400
Date: Thu, 3 Jul 2008 09:02:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [x86-tip] panic during cpu_up
Message-ID: <20080703070242.GA16379@elte.hu>
References: <20080702190651.GA13252@linux.vnet.ibm.com> <20080702205544.GB13252@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080702205544.GB13252@linux.vnet.ibm.com>
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


* Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:

> [Missed cc'ing the LKML last time around]
> 
> On Thu, Jul 03, 2008 at 12:36:51AM +0530, Dhaval Giani wrote:
> > Hi Ingo, Thomas,
> > 
> > I am hitting this on -tip. With 200a86b5d435a217c3d77f3b53cd32cb78c1fde8
> > as the top level commit. Wondering if it is known?
> > 
> > I am trying to fix it atm.
> > 
> > Thanks,
> > 
> > Red Hat Enterprise Linux AS release 4 (Nahant Update 2)
> > Kernel 2.6.26-rc8-tip on an i686
> > 
> > llm11.in.ibm.com login: root
> > Password: 
> > Last login: Thu Jul  3 00:30:47 on ttyS0
> > You have new mail.
> > cd[root@llm11 ~]# cd /sys/devices/system/cpu/cpu1/
> > [root@llm11 cpu1]# echo 0 > online 
> > Breaking affinity for irq 45
> > [root@llm11 cpu1]# echo 1 > online 
> > lockdep: fixing up alternatives.
> > BUG: unable to handle kernel <1>BUG: unable to handle kernel NULL
> > pointer dereference at 00000000
> > IP: [<00000000>]
> > *pde = 00000000 
> > Oops: 0000 [#1] SMP 
> > Modules linked in:
> > 
> > Pid: 0, comm: swapper Not tainted (2.6.26-rc8-tip #1)
> > EIP: 0060:[<00000000>] EFLAGS: 00010002 CPU: 2
> > EIP is at 0x0
> > EAX: c0614c00 EBX: 00000002 ECX: 0799d000 EDX: ffff3bdf
> > BUG: unable to handle kernel NULL pointer dereference at 00000000
> > IP:ESI: 00000000 EDI: 00000000 EBP: f7cadfac ESP: f7cadfa4
> >  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> >  [<00000000>]
> > BUG: unable to handle kernel NULL pointer dereference*pde = 00000000
> > <1>BUG: unable to handle kernel  at 00000000
> > IP:<0>Process swapper (pid: 0, ti=f7cac000 task=f7caaee0
> > task.ti=f7cac000)NULL pointer dereference [<00000000>]
> > *pde = 00000000 <1>BUG: unable to handle kernel 
> > Stack: 
> >  at 00000000
> > IP:NULL pointer dereference [<00000000>]
> >  at 00000000
> > c01020c7 *pde = 00000000 <1>IP:
> > 
> >  [<00000000>]
> > 0402080c *pde = 00000000 f7cadfb4 
> > c040b6cf 00000000 00000000 00000000 00000000 
> >        00000000 00000000 00000000 00000000 00000000 00000000 000000d8
> > 00000000 
> >        00000000 00000000 00000000 00000000 00000000 00000000 00000000 
> > Call Trace:
> >  [<c01020c7>] ? cpu_idle+0x8a/0x9e
> >  [<c040b6cf>] ? start_secondary+0xbb/0xbd
> >  =======================
> > Code:  Bad EIP value.
> > EIP: [<00000000>] 0x0 SS:ESP 0068:f7cadfa4
> > Kernel panic - not syncing: Fatal exception
> > Oops: 0000 [#2] SMP 
> > Pid: 0, comm: swapper Tainted: G      D   2.6.26-rc8-tip #1
> > Modules linked in: [<c01276d7>] 
> > 
> > panic+0x38/0xe0
> > Pid: 0, comm: swapper Tainted: G      D   (2.6.26-rc8-tip #1)
> > EIP: 0060:[<00000000>] EFLAGS: 00010046 CPU: 3
> >  [<c0104bcd>] EIP is at 0x0
> > EAX: c0614c00 EBX: 00000003 ECX: 079a5000 EDX: ffff3bdf
> > ESI: 00000000 EDI: 00000000 EBP: f7cbbfac ESP: f7cbbfa4
> >  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> > Process swapper (pid: 0, ti=f7cba000 task=f7cb8fe0 task.ti=f7cba000)
> > Stack: die+0x130/0x147
> > c01020c7 0602080c f7cbbfb4 c040b6cf 00000000  [<c0411795>] 00000000
> > 00000000 00000000 
> >        00000000 do_page_fault+0x3bd/0x482
> > 00000000  [<c04113d8>] ? 00000000 00000000 00000000 00000000
> > do_page_fault+0x0/0x482
> > 000000d8 00000000  [<c040fbda>] 
> >        00000000 error_code+0x72/0x78
> > 00000000 00000000  [<c01020c7>] ? 00000000 00000000 cpu_idle+0x8a/0x9e
> > 00000000 00000000 
> > Call Trace:
> >  [<c040b6cf>] <0> [<c01020c7>] start_secondary+0xbb/0xbd
> > ?  =======================
> > cpu_idle+0x8a/0x9e
> >  [<c040b6cf>] ? start_secondary+0xbb/0xbd
> >  =======================
> > Code:  Bad EIP value.
> > EIP: [<00000000>] 0x0 SS:ESP 0068:f7cbbfa4
> > Oops: 0000 [#3] <0>Kernel panic - not syncing: Fatal exception
> > SMP Pid: 0, comm: swapper Tainted: G      D   2.6.26-rc8-tip #1
> > 
> >  [<c01276d7>] Modules linked in:
> > 
> > panic+0x38/0xe0
> > Pid: 0, comm: swapper Tainted: G      D   (2.6.26-rc8-tip #1)
> >  [<c0104bcd>] EIP: 0060:[<00000000>] EFLAGS: 00010046 CPU: 7
> > die+0x130/0x147
> > EIP is at 0x0
> >  [<c0411795>] EAX: c0614c00 EBX: 00000007 ECX: 079c5000 EDX: ffff3bdf
> > ESI: 00000000 EDI: 00000000 EBP: f7d1bfac ESP: f7d1bfa4
> >  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> > Process swapper (pid: 0, ti=f7d1a000 task=f7d18be0
> > task.ti=f7d1a000)do_page_fault+0x3bd/0x482
> > 
> > Stack:  [<c04113d8>] c01020c7 ? 0702080c f7d1bfb4
> > do_page_fault+0x0/0x482
> > c040b6cf  [<c040fbda>] 00000000 00000000 error_code+0x72/0x78
> > 00000000 00000000 
> >         [<c01020c7>] ? 00000000 00000000 cpu_idle+0x8a/0x9e
> > 00000000 00000000  [<c040b6cf>] 00000000 00000000 000000d8
> > start_secondary+0xbb/0xbd
> > 00000000  =======================
> > 
> >        00000000 00000000 00000000 00000000 00000000 00000000 00000000 
> > Call Trace:
> >  [<c01020c7>] ? cpu_idle+0x8a/0x9e
> >  [<c040b6cf>] ? start_secondary+0xbb/0xbd
> >  =======================
> > Code:  Bad EIP value.
> > EIP: [<00000000>] 0x0 SS:ESP 0068:f7d1bfa4
> > Kernel panic - not syncing: Fatal exception
> > Oops: 0000 [#4] SMP 
> > Pid: 0, comm: swapper Tainted: G      D   2.6.26-rc8-tip #1
> > Modules linked in: [<c01276d7>] 
> > panic+0x38/0xe0
> > 
> >  [<c0104bcd>] Pid: 0, comm: swapper Tainted: G      D   (2.6.26-rc8-tip
> > #1)
> > EIP: 0060:[<00000000>] EFLAGS: 00010046 CPU: 4
> > die+0x130/0x147
> > EIP is at 0x0
> > EAX: c0614c00 EBX: 00000004 ECX: 079ad000 EDX: ffff3bdf
> > ESI: 00000000 EDI: 00000000 EBP: f7ccbfac ESP: f7ccbfa4
> >  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> > Process swapper (pid: 0, ti=f7cca000 task=f7cc90e0 task.ti=f7cca000)
> > [<c0411795>] 
> > Stack: c01020c7 do_page_fault+0x3bd/0x482
> > 0102080c  [<c04113d8>] f7ccbfb4 c040b6cf 00000000 00000000 00000000
> > 00000000 ? 
> >        00000000 00000000 00000000 00000000 00000000
> > do_page_fault+0x0/0x482
> > 00000000 000000d8 00000000 
> >        00000000 00000000 00000000 00000000 00000000 00000000 00000000 
> > Call Trace:
> >  [<c040fbda>] <0> [<c01020c7>] ? error_code+0x72/0x78
> >  [<c01020c7>] ? cpu_idle+0x8a/0x9e
> > cpu_idle+0x8a/0x9e
> >  [<c040b6cf>] ?  [<c040b6cf>] start_secondary+0xbb/0xbd
> >  =======================
> > start_secondary+0xbb/0xbd
> >  =======================
> > Code:  Bad EIP value.
> > EIP: [<00000000>] 0x0 SS:ESP 0068:f7ccbfa4
> > Oops: 0000 [#5] <0>Kernel panic - not syncing: Fatal exception
> > SMP 
> > Pid: 0, comm: swapper Tainted: G      D   2.6.26-rc8-tip #1
> > Modules linked in: [<c01276d7>] 
> > 
> > panic+0x38/0xe0
> > Pid: 0, comm: swapper Tainted: G      D   (2.6.26-rc8-tip #1)
> >  [<c0104bcd>] EIP: 0060:[<00000000>] EFLAGS: 00010046 CPU: 6
> > die+0x130/0x147
> > EIP is at 0x0
> > EAX: c0614c00 EBX: 00000006 ECX: 079bd000 EDX: ffff3bdf
> > ESI: 00000000 EDI: 00000000 EBP: f7d0bfac ESP: f7d0bfa4
> >  [<c0411795>]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> > Process swapper (pid: 0, ti=f7d0a000 task=f7d092e0
> > task.ti=f7d0a000)do_page_fault+0x3bd/0x482
> > 
> > Stack:  [<c04113d8>] ? c01020c7 0502080c do_page_fault+0x0/0x482
> > f7d0bfb4  [<c040fbda>] c040b6cf error_code+0x72/0x78
> > 00000000  [<c01020c7>] ? 00000000 cpu_idle+0x8a/0x9e
> > 00000000  [<c040b6cf>] 00000000 start_secondary+0xbb/0xbd
> > 
> >         =======================
> > 00000000 00000000 00000000 00000000 00000000 00000000 000000d8 00000000 
> >        00000000 00000000 00000000 00000000 00000000 00000000 00000000 
> > Call Trace:
> >  [<c01020c7>] ? cpu_idle+0x8a/0x9e
> >  [<c040b6cf>] ? start_secondary+0xbb/0xbd
> >  =======================
> > Code:  Bad EIP value.
> > EIP: [<00000000>] 0x0 SS:ESP 0068:f7d0bfa4
> > Kernel panic - not syncing: Fatal exception
> > Pid: 0, comm: swapper Tainted: G      D   2.6.26-rc8-tip #1
> >  [<c01276d7>] panic+0x38/0xe0
> >  [<c0104bcd>] die+0x130/0x147
> >  [<c0411795>] do_page_fault+0x3bd/0x482
> >  [<c04113d8>] ? do_page_fault+0x0/0x482
> >  [<c040fbda>] error_code+0x72/0x78
> >  [<c01020c7>] ? cpu_idle+0x8a/0x9e
> >  [<c040b6cf>] start_secondary+0xbb/0xbd
> >  =======================
> > NULL pointer dereference at 00000000
> > IP: [<00000000>]
> > *pde = 00000000 
> > Oops: 0000 [#6] SMP 
> > Modules linked in:
> > 
> > Pid: 0, comm: swapper Tainted: G      D   (2.6.26-rc8-tip #1)
> > EIP: 0060:[<00000000>] EFLAGS: 00010006 CPU: 1
> > EIP is at 0x0
> > EAX: c0614c00 EBX: 00000001 ECX: 07995000 EDX: ffff3bdf
> > ESI: 00000000 EDI: 00000000 EBP: f7c7ffb4 ESP: f7c7ffac
> >  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> > Process swapper (pid: 0, ti=f7c7e000 task=f7c7cde0 task.ti=f7c7e000)
> > Stack: c01020c7 0202080c f7c7ffbc c040b6cf 00000000 00000000 00000000
> > 00000000 
> >        00000000 00000000 00000000 00000000 000000d8 00000000 00000000
> > 00000000 
> >        00000000 00000000 00000000 00000000 00000000 
> > Call Trace:
> >  [<c01020c7>] ? cpu_idle+0x8a/0x9e
> >  [<c040b6cf>] ? start_secondary+0xbb/0xbd
> >  =======================
> > Code:  Bad EIP value.
> > EIP: [<00000000>] 0x0 SS:ESP 0068:f7c7ffac
> > Kernel panic - not syncing: Fatal exception
> > Pid: 0, comm: swapper Tainted: G      D   2.6.26-rc8-tip #1
> >  [<c01276d7>] panic+0x38/0xe0
> >  [<c0104bcd>] die+0x130/0x147
> >  [<c0411795>] do_page_fault+0x3bd/0x482
> >  [<c04113d8>] ? do_page_fault+0x0/0x482
> >  [<c040fbda>] error_code+0x72/0x78
> >  [<c01020c7>] ? cpu_idle+0x8a/0x9e
> >  [<c040b6cf>] start_secondary+0xbb/0xbd
> >  =======================
> > BUG: NMI Watchdog detected LOCKUP on CPU6, ip c0111959, registers:
> > Modules linked in:
> > 
> > Pid: 0, comm: swapper Tainted: G      D   (2.6.26-rc8-tip #1)
> > EIP: 0060:[<c0111959>] EFLAGS: 00000093 CPU: 6
> > EIP is at __smp_call_function+0x5d/0x7a
> > EAX: 0000009e EBX: 00000005 ECX: 00000006 EDX: f7d092e0
> > ESI: c01047d4 EDI: c0111a5a EBP: f7d0bf00 ESP: f7d0bed0
> >  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> > Process swapper (pid: 0, ti=f7d0a000 task=f7d092e0 task.ti=f7d0a000)
> > Stack: 00000000 c0111a5a 00000000 00000000 c01047d4 00000000 c029915b
> > f7d0bf6c 
> >        00000006 00000001 00000046 00000000 f7d0bf14 c0111acb 00000000
> > f7d0bf6c 
> >        00000006 f7d0bf20 c01276ee f7d0bf6c f7d0bf3c c0104bcd c04d922f
> > c04e06cf 
> > Call Trace:
> >  [<c0111a5a>] ? stop_this_cpu+0x0/0x3a
> >  [<c01047d4>] ? show_trace+0x10/0x12
> >  [<c029915b>] ? do_unblank_screen+0x2a/0xf9
> >  [<c0111acb>] ? native_smp_send_stop+0x37/0x6a
> >  [<c01276ee>] ? panic+0x4f/0xe0
> >  [<c0104bcd>] ? die+0x130/0x147
> >  [<c0411795>] ? do_page_fault+0x3bd/0x482
> >  [<c04113d8>] ? do_page_fault+0x0/0x482
> >  [<c040fbda>] ? error_code+0x72/0x78
> >  [<c01020c7>] ? cpu_idle+0x8a/0x9e
> >  [<c040b6cf>] ? start_secondary+0xbb/0xbd
> >  =======================
> > Code: 85 c0 0f 44 75 e0 89 45 e4 8d 45 d4 a3 d4 33 62 c0 89 75 e0 0f ae
> > f0 0f 1f 00 8b 15 e0 69 57 c0 b8 fb 00 00 00 ff 52 78 39 5d dc <74> 04
> > f3 90 eb f7 83 7d 08 00 74 09 39 5d e0 74 04 f3 90 eb f7 
> > 
> 
> So after digging around a bit, it turns out the pm_idle is NULL. For
> some reason it is not getting set to default_idle if nothing works. I am
> not sure of the path being followed, and its a bit late for me to be
> trying anything serious :).
> 
> This seems to work as a temporary workaround, but obviously is not the
> right fix yet.

hm, interesting - this is a new bug. I'm wondering where that NULL came 
from. x86 boot itself does not leave room for pm_idle to be NULL AFAICS.

One suspect would be cpuidle:

 void cpuidle_uninstall_idle_handler(void)
 {
         if (enabled_devices && (pm_idle != pm_idle_old)) {
                 pm_idle = pm_idle_old;
                 cpuidle_kick_cpus();

The other suspect would be acpi idle:

        /* Fall back to the default idle loop */
        pm_idle = pm_idle_save;

Could you try latest tip/master or the debug patch below? It should show 
where the NULL comes from, without crashing.

A third possibility is if pm_idle itself got genuinely corrupted via 
something else. In that case you should get a warning from process*.c.

	Ingo

-------------------->
commit 3d02d03d4974e0776baf2bc03cbb71d4d670aa85
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu Jul 3 08:52:57 2008 +0200

    debug: "[x86-tip] panic during cpu_up"
    
    Dhaval Giani wrote:
    
    > I am hitting this on -tip. With 200a86b5d435a217c3d77f3b53cd32cb78c1fde8
    > as the top level commit. Wondering if it is known?
    >
    > I am trying to fix it atm.
    >
    > Thanks,
    >
    > Red Hat Enterprise Linux AS release 4 (Nahant Update 2)
    > Kernel 2.6.26-rc8-tip on an i686
    >
    > llm11.in.ibm.com login: root
    > Password:
    > Last login: Thu Jul  3 00:30:47 on ttyS0
    > You have new mail.
    > cd[root@llm11 ~]# cd /sys/devices/system/cpu/cpu1/
    > [root@llm11 cpu1]# echo 0 > online
    > Breaking affinity for irq 45
    > [root@llm11 cpu1]# echo 1 > online
    > lockdep: fixing up alternatives.
    > BUG: unable to handle kernel <1>BUG: unable to handle kernel NULL
    > pointer dereference at 00000000
    > IP: [<00000000>]
    > *pde = 00000000
    > Oops: 0000 [#1] SMP
    > Modules linked in:
    >
    > Pid: 0, comm: swapper Not tainted (2.6.26-rc8-tip #1)
    > EIP: 0060:[<00000000>] EFLAGS: 00010002 CPU: 2
    > EIP is at 0x0
    > EAX: c0614c00 EBX: 00000002 ECX: 0799d000 EDX: ffff3bdf
    > BUG: unable to handle kernel NULL pointer dereference at 00000000
    > IP:ESI: 00000000 EDI: 00000000 EBP: f7cadfac ESP: f7cadfa4
    >  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
    >  [<00000000>]
    > BUG: unable to handle kernel NULL pointer dereference*pde = 00000000
    > <1>BUG: unable to handle kernel  at 00000000
    > IP:<0>Process swapper (pid: 0, ti=f7cac000 task=f7caaee0
    > task.ti=f7cac000)NULL pointer dereference [<00000000>]
    > *pde = 00000000 <1>BUG: unable to handle kernel
    > Stack:
    >  at 00000000
    > IP:NULL pointer dereference [<00000000>]
    >  at 00000000
    > c01020c7 *pde = 00000000 <1>IP:
    >
    >  [<00000000>]
    > 0402080c *pde = 00000000 f7cadfb4
    > c040b6cf 00000000 00000000 00000000 00000000
    >        00000000 00000000 00000000 00000000 00000000 00000000 000000d8
    > 00000000
    >        00000000 00000000 00000000 00000000 00000000 00000000 00000000
    > Call Trace:
    >  [<c01020c7>] ? cpu_idle+0x8a/0x9e
    >  [<c040b6cf>] ? start_secondary+0xbb/0xbd
    >  =======================
    > Code:  Bad EIP value.
    > EIP: [<00000000>] 0x0 SS:ESP 0068:f7cadfa4
    > Kernel panic - not syncing: Fatal exception
    > Oops: 0000 [#2] SMP
    > Pid: 0, comm: swapper Tainted: G      D   2.6.26-rc8-tip #1
    > Modules linked in: [<c01276d7>]
    >
    > panic+0x38/0xe0
    > Pid: 0, comm: swapper Tainted: G      D   (2.6.26-rc8-tip #1)
    > EIP: 0060:[<00000000>] EFLAGS: 00010046 CPU: 3
    >  [<c0104bcd>] EIP is at 0x0
    > EAX: c0614c00 EBX: 00000003 ECX: 079a5000 EDX: ffff3bdf
    > ESI: 00000000 EDI: 00000000 EBP: f7cbbfac ESP: f7cbbfa4
    >  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
    > Process swapper (pid: 0, ti=f7cba000 task=f7cb8fe0 task.ti=f7cba000)
    > Stack: die+0x130/0x147
    > c01020c7 0602080c f7cbbfb4 c040b6cf 00000000  [<c0411795>] 00000000
    > 00000000 00000000
    >        00000000 do_page_fault+0x3bd/0x482
    > 00000000  [<c04113d8>] ? 00000000 00000000 00000000 00000000
    > do_page_fault+0x0/0x482
    > 000000d8 00000000  [<c040fbda>]
    >        00000000 error_code+0x72/0x78
    > 00000000 00000000  [<c01020c7>] ? 00000000 00000000 cpu_idle+0x8a/0x9e
    > 00000000 00000000
    > Call Trace:
    >  [<c040b6cf>] <0> [<c01020c7>] start_secondary+0xbb/0xbd
    > ?  =======================
    > cpu_idle+0x8a/0x9e
    >  [<c040b6cf>] ? start_secondary+0xbb/0xbd
    >  =======================
    > Code:  Bad EIP value.
    > EIP: [<00000000>] 0x0 SS:ESP 0068:f7cbbfa4
    > Oops: 0000 [#3] <0>Kernel panic - not syncing: Fatal exception
    > SMP Pid: 0, comm: swapper Tainted: G      D   2.6.26-rc8-tip #1
    >
    >  [<c01276d7>] Modules linked in:
    >
    > panic+0x38/0xe0
    > Pid: 0, comm: swapper Tainted: G      D   (2.6.26-rc8-tip #1)
    >  [<c0104bcd>] EIP: 0060:[<00000000>] EFLAGS: 00010046 CPU: 7
    > die+0x130/0x147
    > EIP is at 0x0
    >  [<c0411795>] EAX: c0614c00 EBX: 00000007 ECX: 079c5000 EDX: ffff3bdf
    > ESI: 00000000 EDI: 00000000 EBP: f7d1bfac ESP: f7d1bfa4
    >  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
    > Process swapper (pid: 0, ti=f7d1a000 task=f7d18be0
    > task.ti=f7d1a000)do_page_fault+0x3bd/0x482
    >
    > Stack:  [<c04113d8>] c01020c7 ? 0702080c f7d1bfb4
    > do_page_fault+0x0/0x482
    > c040b6cf  [<c040fbda>] 00000000 00000000 error_code+0x72/0x78
    > 00000000 00000000
    >         [<c01020c7>] ? 00000000 00000000 cpu_idle+0x8a/0x9e
    > 00000000 00000000  [<c040b6cf>] 00000000 00000000 000000d8
    > start_secondary+0xbb/0xbd
    > 00000000  =======================
    >
    >        00000000 00000000 00000000 00000000 00000000 00000000 00000000
    > Call Trace:
    >  [<c01020c7>] ? cpu_idle+0x8a/0x9e
    >  [<c040b6cf>] ? start_secondary+0xbb/0xbd
    >  =======================
    > Code:  Bad EIP value.
    > EIP: [<00000000>] 0x0 SS:ESP 0068:f7d1bfa4
    > Kernel panic - not syncing: Fatal exception
    > Oops: 0000 [#4] SMP
    > Pid: 0, comm: swapper Tainted: G      D   2.6.26-rc8-tip #1
    > Modules linked in: [<c01276d7>]
    > panic+0x38/0xe0
    >
    >  [<c0104bcd>] Pid: 0, comm: swapper Tainted: G      D   (2.6.26-rc8-tip
    > #1)
    > EIP: 0060:[<00000000>] EFLAGS: 00010046 CPU: 4
    > die+0x130/0x147
    > EIP is at 0x0
    > EAX: c0614c00 EBX: 00000004 ECX: 079ad000 EDX: ffff3bdf
    > ESI: 00000000 EDI: 00000000 EBP: f7ccbfac ESP: f7ccbfa4
    >  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
    > Process swapper (pid: 0, ti=f7cca000 task=f7cc90e0 task.ti=f7cca000)
    > [<c0411795>]
    > Stack: c01020c7 do_page_fault+0x3bd/0x482
    > 0102080c  [<c04113d8>] f7ccbfb4 c040b6cf 00000000 00000000 00000000
    > 00000000 ?
    >        00000000 00000000 00000000 00000000 00000000
    > do_page_fault+0x0/0x482
    > 00000000 000000d8 00000000
    >        00000000 00000000 00000000 00000000 00000000 00000000 00000000
    > Call Trace:
    >  [<c040fbda>] <0> [<c01020c7>] ? error_code+0x72/0x78
    >  [<c01020c7>] ? cpu_idle+0x8a/0x9e
    > cpu_idle+0x8a/0x9e
    >  [<c040b6cf>] ?  [<c040b6cf>] start_secondary+0xbb/0xbd
    >  =======================
    > start_secondary+0xbb/0xbd
    >  =======================
    > Code:  Bad EIP value.
    > EIP: [<00000000>] 0x0 SS:ESP 0068:f7ccbfa4
    > Oops: 0000 [#5] <0>Kernel panic - not syncing: Fatal exception
    > SMP
    > Pid: 0, comm: swapper Tainted: G      D   2.6.26-rc8-tip #1
    > Modules linked in: [<c01276d7>]
    >
    > panic+0x38/0xe0
    > Pid: 0, comm: swapper Tainted: G      D   (2.6.26-rc8-tip #1)
    >  [<c0104bcd>] EIP: 0060:[<00000000>] EFLAGS: 00010046 CPU: 6
    > die+0x130/0x147
    > EIP is at 0x0
    > EAX: c0614c00 EBX: 00000006 ECX: 079bd000 EDX: ffff3bdf
    > ESI: 00000000 EDI: 00000000 EBP: f7d0bfac ESP: f7d0bfa4
    >  [<c0411795>]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
    > Process swapper (pid: 0, ti=f7d0a000 task=f7d092e0
    > task.ti=f7d0a000)do_page_fault+0x3bd/0x482
    >
    > Stack:  [<c04113d8>] ? c01020c7 0502080c do_page_fault+0x0/0x482
    > f7d0bfb4  [<c040fbda>] c040b6cf error_code+0x72/0x78
    > 00000000  [<c01020c7>] ? 00000000 cpu_idle+0x8a/0x9e
    > 00000000  [<c040b6cf>] 00000000 start_secondary+0xbb/0xbd
    >
    >         =======================
    > 00000000 00000000 00000000 00000000 00000000 00000000 000000d8 00000000
    >        00000000 00000000 00000000 00000000 00000000 00000000 00000000
    > Call Trace:
    >  [<c01020c7>] ? cpu_idle+0x8a/0x9e
    >  [<c040b6cf>] ? start_secondary+0xbb/0xbd
    >  =======================
    > Code:  Bad EIP value.
    > EIP: [<00000000>] 0x0 SS:ESP 0068:f7d0bfa4
    > Kernel panic - not syncing: Fatal exception
    > Pid: 0, comm: swapper Tainted: G      D   2.6.26-rc8-tip #1
    >  [<c01276d7>] panic+0x38/0xe0
    >  [<c0104bcd>] die+0x130/0x147
    >  [<c0411795>] do_page_fault+0x3bd/0x482
    >  [<c04113d8>] ? do_page_fault+0x0/0x482
    >  [<c040fbda>] error_code+0x72/0x78
    >  [<c01020c7>] ? cpu_idle+0x8a/0x9e
    >  [<c040b6cf>] start_secondary+0xbb/0xbd
    >  =======================
    > NULL pointer dereference at 00000000
    > IP: [<00000000>]
    > *pde = 00000000
    > Oops: 0000 [#6] SMP
    > Modules linked in:
    >
    > Pid: 0, comm: swapper Tainted: G      D   (2.6.26-rc8-tip #1)
    > EIP: 0060:[<00000000>] EFLAGS: 00010006 CPU: 1
    > EIP is at 0x0
    > EAX: c0614c00 EBX: 00000001 ECX: 07995000 EDX: ffff3bdf
    > ESI: 00000000 EDI: 00000000 EBP: f7c7ffb4 ESP: f7c7ffac
    >  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
    > Process swapper (pid: 0, ti=f7c7e000 task=f7c7cde0 task.ti=f7c7e000)
    > Stack: c01020c7 0202080c f7c7ffbc c040b6cf 00000000 00000000 00000000
    > 00000000
    >        00000000 00000000 00000000 00000000 000000d8 00000000 00000000
    > 00000000
    >        00000000 00000000 00000000 00000000 00000000
    > Call Trace:
    >  [<c01020c7>] ? cpu_idle+0x8a/0x9e
    >  [<c040b6cf>] ? start_secondary+0xbb/0xbd
    >  =======================
    > Code:  Bad EIP value.
    > EIP: [<00000000>] 0x0 SS:ESP 0068:f7c7ffac
    > Kernel panic - not syncing: Fatal exception
    > Pid: 0, comm: swapper Tainted: G      D   2.6.26-rc8-tip #1
    >  [<c01276d7>] panic+0x38/0xe0
    >  [<c0104bcd>] die+0x130/0x147
    >  [<c0411795>] do_page_fault+0x3bd/0x482
    >  [<c04113d8>] ? do_page_fault+0x0/0x482
    >  [<c040fbda>] error_code+0x72/0x78
    >  [<c01020c7>] ? cpu_idle+0x8a/0x9e
    >  [<c040b6cf>] start_secondary+0xbb/0xbd
    >  =======================
    > BUG: NMI Watchdog detected LOCKUP on CPU6, ip c0111959, registers:
    > Modules linked in:
    >
    > Pid: 0, comm: swapper Tainted: G      D   (2.6.26-rc8-tip #1)
    > EIP: 0060:[<c0111959>] EFLAGS: 00000093 CPU: 6
    > EIP is at __smp_call_function+0x5d/0x7a
    > EAX: 0000009e EBX: 00000005 ECX: 00000006 EDX: f7d092e0
    > ESI: c01047d4 EDI: c0111a5a EBP: f7d0bf00 ESP: f7d0bed0
    >  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
    > Process swapper (pid: 0, ti=f7d0a000 task=f7d092e0 task.ti=f7d0a000)
    > Stack: 00000000 c0111a5a 00000000 00000000 c01047d4 00000000 c029915b
    > f7d0bf6c
    >        00000006 00000001 00000046 00000000 f7d0bf14 c0111acb 00000000
    > f7d0bf6c
    >        00000006 f7d0bf20 c01276ee f7d0bf6c f7d0bf3c c0104bcd c04d922f
    > c04e06cf
    > Call Trace:
    >  [<c0111a5a>] ? stop_this_cpu+0x0/0x3a
    >  [<c01047d4>] ? show_trace+0x10/0x12
    >  [<c029915b>] ? do_unblank_screen+0x2a/0xf9
    >  [<c0111acb>] ? native_smp_send_stop+0x37/0x6a
    >  [<c01276ee>] ? panic+0x4f/0xe0
    >  [<c0104bcd>] ? die+0x130/0x147
    >  [<c0411795>] ? do_page_fault+0x3bd/0x482
    >  [<c04113d8>] ? do_page_fault+0x0/0x482
    >  [<c040fbda>] ? error_code+0x72/0x78
    >  [<c01020c7>] ? cpu_idle+0x8a/0x9e
    >  [<c040b6cf>] ? start_secondary+0xbb/0xbd
    >  =======================
    > Code: 85 c0 0f 44 75 e0 89 45 e4 8d 45 d4 a3 d4 33 62 c0 89 75 e0 0f ae
    > f0 0f 1f 00 8b 15 e0 69 57 c0 b8 fb 00 00 00 ff 52 78 39 5d dc <74> 04
    > f3 90 eb f7 83 7d 08 00 74 09 39 5d e0 74 04 f3 90 eb f7
    >
    >
    > So after digging around a bit, it turns out the pm_idle is NULL. For
    > some reason it is not getting set to default_idle if nothing works.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 28e77d2..75755e2 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -144,6 +144,8 @@ void cpu_idle(void)
 			__get_cpu_var(irq_stat).idle_timestamp = jiffies;
 			/* Don't trace irqs off for idle */
 			stop_critical_timings();
+			if (WARN_ON_ONCE(!pm_idle))
+				pm_idle = default_idle;
 			pm_idle();
 			start_critical_timings();
 		}
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 395a72f..f07278f 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -148,6 +148,8 @@ void cpu_idle(void)
 			enter_idle();
 			/* Don't trace irqs off for idle */
 			stop_critical_timings();
+			if (WARN_ON_ONCE(!pm_idle))
+				pm_idle = default_idle;
 			pm_idle();
 			start_critical_timings();
 			/* In many cases the interrupt that ended idle
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 4976e5d..ff57bb2 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1313,7 +1313,9 @@ int acpi_processor_cst_has_changed(struct acpi_processor *pr)
 		return -ENODEV;
 
 	/* Fall back to the default idle loop */
-	pm_idle = pm_idle_save;
+	WARN_ON_ONCE(!pm_idle_save);
+	if (pm_idle_save)
+		pm_idle = pm_idle_save;
 	synchronize_sched();	/* Relies on interrupts forcing exit from idle. */
 
 	pr->flags.power = 0;
@@ -1864,7 +1866,9 @@ int acpi_processor_power_exit(struct acpi_processor *pr,
 
 	/* Unregister the idle handler when processor #0 is removed. */
 	if (pr->id == 0) {
-		pm_idle = pm_idle_save;
+		WARN_ON_ONCE(!pm_idle_save);
+		if (pm_idle_save)
+			pm_idle = pm_idle_save;
 
 		/*
 		 * We are about to unload the current idle thread pm callback
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 5405769..bb0ba6e 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -95,7 +95,9 @@ void cpuidle_install_idle_handler(void)
 void cpuidle_uninstall_idle_handler(void)
 {
 	if (enabled_devices && (pm_idle != pm_idle_old)) {
-		pm_idle = pm_idle_old;
+		WARN_ON_ONCE(!pm_idle_old);
+		if (pm_idle_old)
+			pm_idle = pm_idle_old;
 		cpuidle_kick_cpus();
 	}
 }
