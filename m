Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbYI0PWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbYI0PWR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 11:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbYI0PWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 11:22:04 -0400
Received: from hpsmtp-eml17.kpnxchange.com ([213.75.38.117]:53326 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752051AbYI0PWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 11:22:03 -0400
From: Frans Pop <elendil@planet.nl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Warning/Oops report of the week of September 16th, 2008
Date: Sat, 27 Sep 2008 17:21:41 +0200
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       tglx@tglx.de, mingo@elte.hu
References: <20080916092206.6342c498@infradead.org> <alpine.LFD.1.10.0809241541320.3265@nehalem.linux-foundation.org> <20080926112815.0f8e9de6@lxorguk.ukuu.org.uk>
In-Reply-To: <20080926112815.0f8e9de6@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809271721.43075.elendil@planet.nl>
X-OriginalArrivalTime: 27 Sep 2008 15:21:43.0479 (UTC) FILETIME=[BF707470:01C920B4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 September 2008, Alan Cox wrote:
> parport: quickfix the proc registration bug
>
> From: Alan Cox <alan@redhat.com>
>
> Ideally we should have a directory of drivers and a link to the
> 'active' driver. For now just show the first device which is
> effectively the existing semantics without a warning.
>
> Signed-off-by: Alan Cox <alan@redhat.com>

Thanks Greg, but I'm afraid that still gives me the error:

ppdev0: registered pardevice
sysctl table check failed: /dev/parport/parport0/devices/ppdev0/timeslice  
Sysctl already exists
Pid: 7104, comm: hpijs Not tainted 2.6.27-rc7 #21

Call Trace:
 [<ffffffff8024d2ac>] set_fail+0x48/0x53
 [<ffffffff8024d7a1>] sysctl_check_table+0x4ea/0x531
 [<ffffffff8024d7ba>] sysctl_check_table+0x503/0x531
 [<ffffffff8024d7ba>] sysctl_check_table+0x503/0x531
 [<ffffffff8024d7ba>] sysctl_check_table+0x503/0x531
 [<ffffffff8024d7ba>] sysctl_check_table+0x503/0x531
 [<ffffffff8024d7ba>] sysctl_check_table+0x503/0x531
 [<ffffffff8023b378>] ? sysctl_set_parent+0x24/0x39
 [<ffffffff8023c66e>] __register_sysctl_paths+0xee/0x29e
 [<ffffffff80314f05>] ? sprintf+0x68/0x6a
 [<ffffffff8023c847>] register_sysctl_paths+0x29/0x2b
 [<ffffffff8023c85c>] register_sysctl_table+0x13/0x15
 [<ffffffffa00f79d4>] parport_device_proc_register+0xcc/0xf0 [parport]
 [<ffffffffa00f5a07>] parport_register_device+0x25c/0x296 [parport]
 [<ffffffffa03c9a3b>] ? pp_irq+0x0/0x4b [ppdev]
 [<ffffffffa03c93e2>] pp_ioctl+0x16f/0x7c8 [ppdev]
 [<ffffffff80282894>] ? free_pages_and_swap_cache+0x57/0x72
 [<ffffffff8029abbe>] vfs_ioctl+0x2a/0x78
 [<ffffffff8029ae63>] do_vfs_ioctl+0x257/0x274
 [<ffffffff8029aed5>] sys_ioctl+0x55/0x78
 [<ffffffff8020c1eb>] system_call_fastpath+0x16/0x1b

ppdev0: registered pardevice
ppdev0: unregistered pardevice
ppdev0: unregistered pardevice

Cheers,
FJP
