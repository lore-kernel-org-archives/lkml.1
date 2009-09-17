Return-Path: <linux-kernel-owner+w=401wt.eu-S1754387AbZIQJfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbZIQJfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 05:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbZIQJfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 05:35:31 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:58424 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbZIQJf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 05:35:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=P0MpynKJq0RAzFCx6o4V/bocZtMFKlyjx5S9KPnXQr4TVPsOv9KGOK8OrbtXd7BUsH
         LQlRuVgDHquPifuDIkJuTPQdVF0C0tdIjMX4jNv9Ts73op/PLamgPRkcVI3udAmvX5wL
         CIocD094EQP63SuyKIG+61EL4HncsXuJyCRHE=
Date: Thu, 17 Sep 2009 11:35:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Denys Fedoryschenko <denys@visp.net.lb>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: unable to handle kernel NULL pointer / tty / 2.6.31-vanilla/
	still persists
Message-ID: <20090917093527.GE5184@nowhere>
References: <200909151032.53683.denys@visp.net.lb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909151032.53683.denys@visp.net.lb>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 10:32:53AM +0300, Denys Fedoryschenko wrote:
> Kernel 2.6.31-rc7
> x86 , 32-bit
> gcc 4.4.1



Hi,

If you are on -rc7, then you are missing an important fix:

tty: make sure to flush any pending work when halting the ldisc

Have you tried with 2.6.31 ?

Thanks,
Frederic.


 
> Happened on heavy network load, looks like as previous one, seems problem 
> still persists.
> It is hyperthreading Xeon, as i heard on such CPU's SMP bugs most easy to 
> trigger. But for me triggered after few days of operation.
> 
> Here is oops:
> 
> [273169.803628] BUG: unable to handle kernel NULL pointer dereference at 
> (null)
> [273169.803710] IP: [<c0250f08>] process_echoes+0x65/0x240
> [273169.803785] *pdpt = 000000002f97d001 *pde = 0000000000000000
> [273169.803854] Oops: 0000 [#1] SMP
> [273169.803922] last sysfs 
> file: /sys/module/nf_conntrack_ipv4/parameters/hashsize
> [273169.804045] Modules linked in: ipt_LOG xt_connlimit xt_NOTRACK iptable_raw 
> ip_gre ipt_REJECT ts_bm xt_string nf_conntrack_netlink nfnetlink iptable_nat 
> nf_nat nf_c
> onntrack_ipv4 nf_conntrack cls_u32 sch_htb tun nf_defrag_ipv
> [273169.804068]
> [273169.804068] Pid: 6261, comm: login Not tainted (2.6.31-build-0046-32bit 
> #4)
> [273169.804068] EIP: 0060:[<c0250f08>] EFLAGS: 00010202 CPU: 1
> [273169.804068] EIP is at process_echoes+0x65/0x240
> [273169.804068] EAX: 00000001 EBX: e6cd0800 ECX: 00001f00 EDX: 00001000
> [273169.804068] ESI: e6cd0800 EDI: 00000000 EBP: f524ad84 ESP: f524ad5c
> [273169.804068]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [273169.804068] Process login (pid: 6261, ti=f524a000 task=f6910ae0 
> task.ti=f524a000)
> [273169.804068] Stack:
> [273169.804068]  e6cd0bc8 e6cd0bdc 00001f00 00000001 00001000 f524ad84 
> c0250c12 e6cd080a
> [273169.804068] <0> e6cd0800 e6cd0958 f524ae94 c02528b5 e6cd0800 c2020220 
> 00000000 e6cd0bf8
> [273169.804068] <0> 00000000 ef07081c 00000000 00000000 ef070820 ef070921 
> 00000000 00000001
> [273169.804068] Call Trace:
> [273169.804068]  [<c0250c12>] ? echo_char_raw+0x45/0x4a
> [273169.804068]  [<c02528b5>] ? n_tty_receive_buf+0xbaf/0x10a5
> [273169.804068]  [<c02fbc5a>] ? schedule+0x75d/0x7c7
> [273169.804068]  [<c01706cc>] ? filemap_fault+0x69/0x2e5
> [273169.804068]  [<c0253d63>] ? tty_ldisc_try+0x36/0x3c
> [273169.804068]  [<c02548f8>] ? flush_to_ldisc+0xf1/0x17f
> [273169.804068]  [<c02549e4>] ? tty_flush_to_ldisc+0xd/0xf
> [273169.804068]  [<c02518d0>] ? n_tty_read+0x2ac/0x5ad
> [273169.804068]  [<c01293e5>] ? default_wake_function+0x0/0xd
> [273169.804068]  [<c0251624>] ? n_tty_read+0x0/0x5ad
> [273169.804068]  [<c024e1b2>] ? tty_read+0x62/0x99
> [273169.804068]  [<c024e150>] ? tty_read+0x0/0x99
> [273169.804068]  [<c0190de2>] ? vfs_read+0x87/0x110
> [273169.804068]  [<c0190f04>] ? sys_read+0x3b/0x60
> [273169.804068]  [<c0102975>] ? syscall_call+0x7/0xb
> [273169.804068] Code: 20 00 00 89 45 e0 8b 83 88 03 00 00 8d 90 00 10 00 00 89 
> c7 8b 83 90 03 00 00 89 55 e8 03 bb 8c 03 00 00 89 45 e4 e9 63 01 00 00 <8a> 
> 07 3c ff 0f
>  85 35 01 00 00 8d 57 01 3b 55 e8 8d 87 01 f0 ff
> [273169.804068] EIP: [<c0250f08>] process_echoes+0x65/0x240 SS:ESP 
> 0068:f524ad5c
> [273169.804068] CR2: 0000000000000000
> [273169.807602] ---[ end trace 25fadd9ce705aa28 ]---
> [273169.807701] Kernel panic - not syncing: Fatal exception
> [273169.807803] Pid: 6261, comm: login Tainted: G      D    
> 2.6.31-build-0046-32bit #4
> [273169.807964] Call Trace:
> [273169.808072]  [<c02fb28c>] ? printk+0xf/0x13
> [273169.808176]  [<c02fb1dd>] panic+0x39/0xd9
> [273169.808278]  [<c01059b7>] oops_end+0x8b/0x9a
> [273169.808378]  [<c0118f49>] no_context+0x13d/0x147
> [273169.808478]  [<c0119066>] __bad_area_nosemaphore+0x113/0x11b
> [273169.808578]  [<c01357b4>] ? lock_timer_base+0x1f/0x3e
> [273169.808676]  [<c01359c1>] ? mod_timer+0x108/0x113
> [273169.808775]  [<c01190ae>] bad_area+0x30/0x39
> [273169.808874]  [<c0119334>] do_page_fault+0x16b/0x26f
> [273169.808975]  [<c01191c9>] ? do_page_fault+0x0/0x26f
> [273169.809087]  [<c02fd2de>] error_code+0x66/0x6c
> [273169.809195]  [<c025007b>] ? tty_release_dev+0x29e/0x3e0
> [273169.809377]  [<c01191c9>] ? do_page_fault+0x0/0x26f
> [273169.809486]  [<c0250f08>] ? process_echoes+0x65/0x240
> [273169.810939]  [<c0250c12>] ? echo_char_raw+0x45/0x4a
> [273169.811040]  [<c02528b5>] n_tty_receive_buf+0xbaf/0x10a5
> [273169.811156]  [<c02fbc5a>] ? schedule+0x75d/0x7c7
> [273169.811267]  [<c01706cc>] ? filemap_fault+0x69/0x2e5
> [273169.811368]  [<c0253d63>] ? tty_ldisc_try+0x36/0x3c
> [273169.811468]  [<c02548f8>] flush_to_ldisc+0xf1/0x17f
> [273169.811571]  [<c02549e4>] tty_flush_to_ldisc+0xd/0xf
> [273169.811674]  [<c02518d0>] n_tty_read+0x2ac/0x5ad
> [273169.811779]  [<c01293e5>] ? default_wake_function+0x0/0xd
> [273169.811884]  [<c0251624>] ? n_tty_read+0x0/0x5ad
> [273169.811988]  [<c024e1b2>] tty_read+0x62/0x99
> [273169.812105]  [<c024e150>] ? tty_read+0x0/0x99
> [273169.812217]  [<c0190de2>] vfs_read+0x87/0x110
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

