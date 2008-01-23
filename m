Return-Path: <linux-kernel-owner+w=401wt.eu-S1755131AbYAWQnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbYAWQnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 11:43:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbYAWQng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 11:43:36 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:11353 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbYAWQnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 11:43:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:references:in-reply-to:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=nGdY9FwT5PJfeqmTAwZ3HSIlVXHNzFPrVDJuZjPyZmxSboIRntjlbVxrBd49EAu+gXErT7d5UPzwmWIbU2O8rSbImfhyExTy5FPRTpDqcIPiHTqg5Szz56LF7hcp7wT0T3fk3Wrx0wPqCQjenY8u66jC5IBFA6IRDXUnWnPzIEA=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: linux-wireless@vger.kernel.org
Subject: Re: Silent crash witk 2-6.24-rc8-git4
Date: Wed, 23 Jan 2008 16:42:58 +0000
User-Agent: KMail/1.9.7
References: <200801220603.02986.chris2553@googlemail.com> <200801231521.36968.chris2553@googlemail.com>
In-Reply-To: <200801231521.36968.chris2553@googlemail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801231642.58782.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 January 2008, Chris Clayton wrote:
> Hi again.
> 
> On Tuesday 22 January 2008, Chris Clayton wrote:
> > Hi,

and here's another, slightly more complete, one, this time from 2.6.24-rc8-git6
(the none I sent earlier was from -git4, by the way)

Call Trace:
[<c011440a>] __update_rq_clock+0x1a/0xf0
[<e08ff59d>] rt2x00lib_txdone+0x9d/0xd0 [rt2x00lib]
[<e0909573>] rt61pci_txdone+0x153/0x1f0 [rt61pci]
[<e09096ad>] rt61pci_interrupt+0x9d/0xb0 [rt61pci]
[<c0140dc7>] handle_IRQ_event+0x27/0x60
[<c0141fbb>] handle_level_irq+0x6b/0x100
[<c014if50>] handle_level_irq+0x0/0x100
[<c0105db8>] do_IRQ+0x68/0xc0
[<c011440a>] __update_rq_clock+0x1a/0xf0
[<c01042f3>] common_interrupt+0x23/0x28
[<c014007b>] encode_comp2_t+0x4b/0x80
[<c011007b>] acpi_copy_wakeup_routine+0x2b/0x9c
[<c02161fb>] acpi_processor_idle+0x25b/0x36e
[<c01020dc>] cpu_idle+0x5c/0x80
[<c040381b>] start_kernel+0x18b/0x1d0
[<c0403360>] unknown_bootoption+0x0/0x150
========================
Code: 00 00 00 e9 6c ff ff ff 8d b6 00 00 00 00 8d bf 00 00 00 00 55 89 cd 57 56
 53 83 ec 10 89 d3 89 44 24 08 ba 20 00 00 00 8b 40 58 <89> 43 14 a1 10 66 3e c0
 e8 6c f9 82 df 89 44 24 0c 85 c0 89 c7
EIP: [<e0930eb7>] ieee80211_tx_status_irqsafe+0x17/0x120 [mac80211] SS:ESP 0068:
c042ff4c
Kernel panic - not syncing: Fatal exception in interrupt


I'll stop crashing my laptop now :)

Hope this too helps.
> 
> I've now got the part of the panic message that doesn't scroll off-screen:
> 
> [<c01f870e>] acpi_ds_exec_end_op+0xc1/0x387
> [<c020757d>] acpi_ps_get_arguments+0xa9+0x12d
> [<c0207b3a>] acpi_ps_parse_loop+0x259/0x2b7
> [<c0207052>] acpi_ps_parse_aml_walk+0xb3/0x10e
> [<c02080e3>] acpi_ds_init_aml_walk+0xb3/0c10e
> [<c02080e3>] acpi_ps_execute_method+0xaf/0xe5
> [<c020530b>] acpi_ns_evaluate+0x97/0xec
> [<c0204c66>] acpi_evaluate_object+0x136/0x1da
> [<c01f6ebd>] acpi_evaluate_integer+0x7a/0xb8
> [<c0217a81>] acpi_thermal_get_temprature+0x29/0x3d
> [<c0218498>] acpi_thermal_temp_seq_show+0x15/0x58
> [<c017d27a>] seq_read+0xda/0x2a0
> [<c017d1a0>] seq_read+0x0/0x2a0
> [<c01943ac>] proc_reg_read+0x9c/0xb0
> [<c016359c>] vfs_read+0x9c/0xd0
> [<c01637e7>] sys_read+0x47/0x80
> [<c010414a>] syscall_call+0x7/0xb
> =======================
> Code: 00 00 00 e9 6c ff ff ff 8d b6 00 00 00 00 8d bf 00 00 00 00 55 89 cd 57 56
>  53 83 ec 10 89 d3 89 44 24 08 ba 20 00 00 00 8b 40 58 <89> 42 14 a1 10 66 3e c0
>  e8 bc 89 83 df 89 44 24 0c 85 c0 89 c7
> EIP: [<e0927eb7>] ieee80211_tx_status_irqsafe+0x17/0x120 [mac80211] SS:ESP 0068:
> c042ff4c
> Kernel panic - not syncing: fatal exception in interrupt
> 
> Hope this helps. Feel free to send me any patches that might fix or help diagnose.
> 
> Chris
> > 
> > Firstly, I'm not subscribed, so please cc me into any reply.
> > 
> > I've found that I can cause my laptop (DEll Latitude C610) to crash silently 
> > (other than blinking LEDs) with stock 2.6.24-rc8{,-git2,-git3,-git4} kernels. 
> > I suspect the problem is related to the rt61pci driver, so I've cc'd 
> > linux-wireless.
> > 
> > All I have to do to cause the crash is run the following script on the laptop
> > 
> > #!/bin/sh
> > for i in `seq 1 100`; do
> >     echo $i > itercount
> >     rm -f linux-2.6.23.tar.bz2
> >     wget ftp://192.168.1.10/pub/linux-2.6.23.tar.bz2
> > done
> > 
> > The crash will occur usually during the first iteration (and often in the 
> > first 12 megabytes), but never later than the second.
> > 
> > I suspect the rt61pci driver because if I down wlan0 and connect to my network 
> > via eth0, the laptop never crashes (and I've let it run for 50 or so 
> > iterations). Similarly, if I build and install -git4 without the in-tree 
> > rt61pci driver and build and install the out-of-tree rt61 driver from 
> > serialmonkey.com (20071117 snapshot), the script runs fine, although I admit 
> > that I stopped it after eight iterations.
> > 
> > My config, the output, from lspci -vv and the contents of syslog from a crash 
> > are attached. The wireless adapter is a Belkin F5D7010.
> > 
> > Other than maybe a little later on tonight, I won't have much time to give 
> > this further attention over the next couple of days, but I thought it best to 
> > give a heads-up now.
> > 
> > Thanks in advance
> > 
> > Chris
> > 
> 



-- 
Beer is proof that God loves us and wants us to be happy - Benjamin Franklin
