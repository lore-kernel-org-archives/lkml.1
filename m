Return-Path: <linux-kernel-owner+w=401wt.eu-S1758280AbYAGTRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280AbYAGTRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 14:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755519AbYAGTRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 14:17:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56397 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbYAGTRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 14:17:03 -0500
Message-ID: <478278C9.8030006@zytor.com>
Date: Mon, 07 Jan 2008 11:08:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
CC: vgoyal@redhat.com, hbabu@us.ibm.com, lkml <linux-kernel@vger.kernel.org>,
       kexec@lists.infradead.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: crashing on lowmem-only config (was: kexec refuses to boot latest
 -mm)
References: <20071228124532.GB32643@linux.vnet.ibm.com> <478264CA.5090300@zytor.com> <20080107175303.GA9319@linux.vnet.ibm.com>
In-Reply-To: <20080107175303.GA9319@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dhaval Giani wrote:
> 
> .config
> 

This appears to be unrelated, but booting this configuration on a stock 
2.6.24-rc7 kernel crashes during bootup with no initrd if the memory 
size is 896 MB or less (i.e. lowmem only):

Bad page state in process 'swapper'
page:c1b59800 flags:0xdead4aad mapping:00000000 mapcount:0 count:0
Trying to fix it up, but a reboot is needed
Backtrace:
Pid: 0, comm: swapper Not tainted 2.6.24-rc7 #1
  [<c0105ff3>] show_trace_log_lvl+0x1a/0x2f
  [<c0106885>] show_trace+0x12/0x14
  [<c0106b7b>] dump_stack+0x6c/0x72
  [<c015c5c3>] bad_page+0x67/0x93
  [<c015d33e>] __free_pages_ok+0x63/0x2f3
  [<c015d5f2>] __free_pages+0x24/0x26
  [<c05c70ea>] __free_pages_bootmem+0x5f/0x63
  [<c05c57c9>] free_all_bootmem_core+0xcd/0x1a4
  [<c05c58ad>] free_all_bootmem+0xd/0xf
  [<c05c244c>] mem_init+0x81/0x31b
  [<c05b4639>] start_kernel+0x2af/0x335
  [<00000000>] 0x0
  =======================
Bad page state in process 'swapper'
[...]
  =======================
BUG: spinlock lockup on CPU#0, swapper/0, 00000e28
Pid: 0, comm: swapper Tainted: G    B   2.6.24-rc7 #1
  [<c0105ff3>] show_trace_log_lvl+0x1a/0x2f
  [<c0106885>] show_trace+0x12/0x14
  [<c0106b7b>] dump_stack+0x6c/0x72
  [<c024b9a9>] _raw_spin_lock+0xc1/0xe2
  [<c0411d08>] _spin_lock+0x32/0x38
  [<c015d3f9>] __free_pages_ok+0x11e/0x2f3
  [<c015d5f2>] __free_pages+0x24/0x26
  [<c05c70ea>] __free_pages_bootmem+0x5f/0x63
  [<c05c57c9>] free_all_bootmem_core+0xcd/0x1a4
  [<c05c58ad>] free_all_bootmem+0xd/0xf
  [<c05c244c>] mem_init+0x81/0x31b
  [<c05b4639>] start_kernel+0x2af/0x335
  [<00000000>] 0x0
  =======================
[hang]

Booting with > 896 MB works...

	-hpa
