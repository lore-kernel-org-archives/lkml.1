Return-Path: <linux-kernel-owner+w=401wt.eu-S1752590AbYJSCwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbYJSCwg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 22:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbYJSCw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 22:52:27 -0400
Received: from mirror.looking-glass.spherevision.org ([70.85.129.236]:39850
	"EHLO octagon.spherevision.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752072AbYJSCw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 22:52:27 -0400
Subject: Re: [2.6.27] constant early exception on boot
From: Rodney Gordon II <meff@spherevision.org>
To: linux-kernel@vger.kernel.org
Cc: meff@spherevision.org
In-Reply-To: <1224333762.7888.0.camel@ghreen.sphere>
References: <1224132742.7417.1.camel@ghreen.sphere>
	 <1224333762.7888.0.camel@ghreen.sphere>
Content-Type: text/plain
Date: Sat, 18 Oct 2008 21:52:56 -0500
Message-Id: <1224384776.8295.0.camel@ghreen.sphere>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-10-18 at 07:42 -0500, Rodney Gordon II wrote:
> On Wed, 2008-10-15 at 23:52 -0500, Rodney Gordon II wrote:
> > Hi all,
> > 
> > Recently with the release of 2.6.27 I have tried this on my main machine
> > (in the form of vanilla 2.6.27 final, Ubuntu Intrepid Beta 2.6.27-rc,
> > and RIPLinux 6.9 2.6.27 final  ----  all AMD64) and I have been getting
> > a pretty regular early exception on my hardware. I will include as much
> > information as I have collected.
> > 
> > System:
> > Asus P5QL-PRO
> > Intel Q6600
> > 4GB RAM (memtest'ed)
> > GeForce 8800GT 512M
> > 
> > Panic:
> > Kernel alive
> > Kernel really alive
> > PANIC: early exception 0e rip 10:ffffffff8072f305 error 0 cr2
> > ffffffffff341000
> > 
> > Working boot dmesg:
> > http://spherevision.org/sync/kernel/ubuntu-8.04-working-dmesg.log
> > 
> > lspci
> > http://spherevision.org/sync/kernel/lspci-vvnn.log
> > 
> > I am available for details/testing/etc for whatever it takes to clean
> > this error up and get it to boot on my hardware. 
> > 
> > Similar page off launchpad.net of error on boot of Intrepid Beta on some
> > with similar outputs of early exceptions: 
> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/54020
> > 
> > Please CC me as I am off list.
> > 
> > Thanks
> 
> More information from earlyprintk:
> 
> ( e820 maps scrolled mostly off screen )
> console [earlyvga0] enabled
> last_pfn = 0x140000 max_arch_pfn=0x3ffffffff
> last_pfn = 0xbff80 max_arch_pfn=0x3ffffffff
> 
> init_memory_mapping
> last_map_addr: bff80000 end: bff80000
> init_memory_mapping
> last_map_addr: 140000000 end: 140000000
> 
> DMI present.
> 
> PANIC: early exception 0e rip 10:ffffffff8072 error 0 cr2 ffffffffff341000
> 
> Pid: 0
> comm: swapper Not Tainted 2.6.27.1 #3
> 
> Call trace:
> [<ffffffff80b52195>] early_idt_handler+0x55/0x69
> [<ffffffff8072c099>] dmi_table+0x45/0x77
> [<ffffffff8072c0a2>] dmi_table+0x4e/0x77
> [<ffffffff80b79db4>] dmi_scan_machine+0x12e/0x19c
> [<ffffffff80b58d58>] setup_arch+0x555/0x4dc
> [<ffffffff80b5285e>] start_kernel+0x5f/0x2dd
> [<ffffffff80b52393>] x86_64_start_kernel+0xe3/0xe7
> 
> RIP 0x10



^^ Fixed by 2.6.27.2.
commit d344a53f2e264ea07c950691c1451a4ff355694b

