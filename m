Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbZFEDWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbZFEDWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 23:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbZFEDVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 23:21:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752642AbZFEDVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 23:21:54 -0400
Date: Thu, 4 Jun 2009 20:21:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Chubb <peterc@gelato.unsw.edu.au>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Oops with minicom and USB serial with Linux 2.6.30-rc8
Message-Id: <20090604202136.87153c67.akpm@linux-foundation.org>
In-Reply-To: <8763fbbgv6.wl%peter@chubb.wattle.id.au>
References: <8763fbbgv6.wl%peter@chubb.wattle.id.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Jun 2009 11:37:33 +1000 Peter Chubb <peterc@gelato.unsw.edu.au> wrote:

> 
> A new kernel this morning.  Using a Prolific single-port serial
> adapter to talk to a BeagleBoard.  I regularly get this when I hit the
> Beagle's reset button.  I'm not sure I trust the traceback; I'll
> rebuild with frame pointers and see if I can get a better one.

Thanks - the trace _is_ a bit hard to decryot.

> 
> pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
> pl2303 7-2.1:1.0: device disconnected
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: [<c0118369>] __ticket_spin_lock+0x5/0x15
> *pde = 00000000 
> Oops: 0002 [#1] PREEMPT SMP 
> last sysfs file: /sys/devices/pci0000:00/0000:00:1c.0/0000:02:00.0/rfkill/rfkill0/state
> Modules linked in: ext2 mbcache nls_iso8859_1 nls_cp437 cdc_acm pl2303 usbserial kvm_intel kvm kqemu cpufreq_powersave cpufreq_userspace cpufreq_conservative snd_hda_codec_si3054 snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss uvcvideo snd_mixer_oss snd_pcm snd_timer snd iwlagn wmi soundcore snd_page_alloc ehci_hcd joydev uhci_hcd usbcore iwlcore
> 
> Pid: 7414, comm: minicom Not tainted (2.6.30-rc8 #17) HP Pavilion dv9700 Notebook PC    
> EIP: 0060:[<c0118369>] EFLAGS: 00010002 CPU: 1
> EIP is at __ticket_spin_lock+0x5/0x15
> EAX: 00000000 EBX: 00000282 ECX: 00000000 EDX: 00000100
> ESI: 00001d4c EDI: f5bd6600 EBP: f52ba5a0 ESP: f5139d68
>  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> Process minicom (pid: 7414, ti=f5138000 task=f50db480 task.ti=f5138000)
> Stack:
>  c01183c6 c0444a56 c01237ef 0001fcc4 00000000 f81c43a2 c20200c0 00000096
>  f5486000 c2022484 00000001 f5139dc8 c01364a3 c0444d3c c0188630 f81c6554
>  f5bd6600 f5486000 f52ba5a0 f8081708 f5133980 f5bd6658 f81c6978 f5486000
> Call Trace:
>  [<c01183c6>] ? default_spin_lock_flags+0x5/0x7
>  [<c0444a56>] ? _spin_lock_irqsave+0x27/0x2e
>  [<c01237ef>] ? try_to_wake_up+0x1b5/0x1bf
>  [<f81c43a2>] ? pl2303_close+0x44/0x1af [pl2303]
>  [<c01364a3>] ? autoremove_wake_function+0xd/0x2d
>  [<c0444d3c>] ? _spin_unlock+0x5/0x1c
>  [<c0188630>] ? fasync_helper+0xcc/0xde
>  [<f8081708>] ? serial_close+0x7b/0x122 [usbserial]
>  [<f8081cb0>] ? serial_open+0x1e1/0x1ed [usbserial]
>  [<c02ccc0c>] ? tty_open+0x2b6/0x37e
>  [<c0181442>] ? chrdev_open+0x15d/0x174
>  [<c01812e5>] ? chrdev_open+0x0/0x174
>  [<c017daec>] ? __dentry_open+0x132/0x221
>  [<c017dc6c>] ? nameidata_to_filp+0x29/0x3c
>  [<c01881d5>] ? do_filp_open+0x402/0x77b
>  [<c0138823>] ? enqueue_hrtimer+0x5a/0x64
>  [<c0138ef7>] ? __hrtimer_start_range_ns+0x1ff/0x20b
>  [<c0138f10>] ? hrtimer_start+0xd/0x11
>  [<c0444d3c>] ? _spin_unlock+0x5/0x1c
>  [<c018f1d3>] ? alloc_fd+0xc3/0xcd
>  [<c017d8e6>] ? do_sys_open+0x44/0xb9
>  [<c017d99f>] ? sys_open+0x1e/0x23
>  [<c0103157>] ? sysenter_do_call+0x12/0x2c
> Code: 89 44 24 0c 89 da 89 f0 5b 5e e9 48 fd ff ff 89 4c 24 0c 89 5c 24 10 89 f1 5b 0f b7 d2 0f b6 c0 5e e9 29 fe ff ff ba 00 01 00 00 <f0> 66 0f c1 10 38 f2 74 06 f3 90 8a 10 eb f6 c3 53 89 c3 0f b7 
> EIP: [<c0118369>] __ticket_spin_lock+0x5/0x15 SS:ESP 0068:f5139d68
> CR2: 0000000000000000

hm, that's the second report of a sys_open->serial_close oops this week.

I don't recall whether we found out what caused the other one?
