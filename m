Return-Path: <linux-kernel-owner+w=401wt.eu-S1761956AbZFMUMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761956AbZFMUMo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 16:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761047AbZFMUMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 16:12:33 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35609 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760447AbZFMUMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 16:12:31 -0400
To: James Bottomley <JBottomley@Novell.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
References: <1244909374.5323.23.camel@mulgrave.site>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 13 Jun 2009 13:12:30 -0700
In-Reply-To: <1244909374.5323.23.camel@mulgrave.site> (James Bottomley's message of "Sat\, 13 Jun 2009 11\:09\:34 -0500")
Message-ID: <m1ski3opu9.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: JBottomley@Novell.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;James Bottomley <JBottomley@Novell.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: BUG in pty_chars_in_buffer with 2.6.30 git head using ssh
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley <JBottomley@Novell.com> writes:

> This is a really odd one.  I've used ssh into this box with this same
> kernel several times before, I got this (actually logged out as me over
> ssh then logged back in as root):

I'm guessing that you managed to hit one of the narrow windows
where (used to have?) races in tty layer.

Last I looked Alan Cox was busily fixing those.

Eric


> ssh used greatest stack depth: 5340 bytes left
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: [<c118beb3>] pty_chars_in_buffer+0x13/0x50
> *pde = 00000000 
> Oops: 0000 [#1] SMP 
> last sysfs file: /sys/devices/pci0000:00/0000:00:1c.4/0000:04:00.0/irq
> Modules linked in: nfsd exportfs nfs lockd auth_rpcgss sunrpc dm_snapshot dm_mirror dm_region_hash dm_log serio_raw i3000_edac rtc_cmos rtc_core rtc_lib ext3 jbd mbcache sg sr_mod cdrom sd_mod uhci_hcd aic94xx libsas libata usbcore tg3 libphy aic7xxx scsi_transport_spi scsi_transport_sas scsi_mod
>
> Pid: 17335, comm: sshd Tainted: G        W  (2.6.30 #66) IBM eServer 206m-[8485IZZ]-
> EIP: 0060:[<c118beb3>] EFLAGS: 00010282 CPU: 0
> EIP is at pty_chars_in_buffer+0x13/0x50
> EAX: 00000000 EBX: f6da08c8 ECX: f6da08c8 EDX: f61085b0
> ESI: 00000000 EDI: f62e4200 EBP: f7a25b0c ESP: f7a25b08
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process sshd (pid: 17335, ti=f7a24000 task=f5e6e0b0 task.ti=f7a24000)
> Stack:
>  f6da08c8 f7a25b14 c11890e5 f7a25b2c c1186e77 00a25b2c 00000000 f62e4200
>  f6da08c8 f7a25b4c c118318a 00000000 c1186d60 f60897c0 0000000b 00000800
>  f62e4200 f7a25e34 c10b810f 000000b2 f7a25bb0 00000000 f7a25bd4 00000020
> Call Trace:
>  [<c11890e5>] ? tty_chars_in_buffer+0x15/0x20
>  [<c1186e77>] ? n_tty_poll+0x117/0x140
>  [<c118318a>] ? tty_poll+0x5a/0x70
>  [<c1186d60>] ? n_tty_poll+0x0/0x140
>  [<c10b810f>] ? do_select+0x32f/0x690
>  [<c10b89f0>] ? __pollwait+0x0/0xc0
>  [<c10b8ab0>] ? pollwake+0x0/0x50
>  [<c10b8ab0>] ? pollwake+0x0/0x50
>  [<c10b8ab0>] ? pollwake+0x0/0x50
>  [<c10b8ab0>] ? pollwake+0x0/0x50
>  [<c10b8ab0>] ? pollwake+0x0/0x50
>  [<c10b8ab0>] ? pollwake+0x0/0x50
>  [<c1036c3f>] ? lock_timer_base+0x1f/0x40
>  [<c127106c>] ? _spin_lock_irqsave+0x2c/0x40
>  [<c1036cfd>] ? mod_timer+0x9d/0xd0
>  [<c10502fb>] ? trace_hardirqs_on+0xb/0x10
>  [<c1036cfd>] ? mod_timer+0x9d/0xd0
>  [<c122e245>] ? tcp_event_new_data_sent+0x85/0xc0
>  [<c1230ac8>] ? tcp_write_xmit+0x1e8/0xa40
>  [<c11e8e76>] ? release_sock+0x26/0xc0
>  [<c10502fb>] ? trace_hardirqs_on+0xb/0x10
>  [<c1032772>] ? local_bh_enable_ip+0x72/0xc0
>  [<c10905df>] ? might_fault+0x3f/0x80
>  [<c10905df>] ? might_fault+0x3f/0x80
>  [<c109061a>] ? might_fault+0x7a/0x80
>  [<c10b8652>] ? core_sys_select+0x1e2/0x330
>  [<c10a984c>] ? do_sync_write+0xcc/0x110
>  [<c1042550>] ? autoremove_wake_function+0x0/0x40
>  [<c10b8957>] ? sys_select+0x27/0xc0
>  [<c10aa34b>] ? sys_write+0x3b/0x70
>  [<c112bcc8>] ? trace_hardirqs_on_thunk+0xc/0x10
>  [<c1002da5>] ? syscall_call+0x7/0xb
> Code: 1c 01 00 00 5d c3 66 90 31 c0 5d c3 8d b6 00 00 00 00 8d bf 00 00 00 00 55 89 e5 53 8b 90 20 01 00 00 89 c3 85 d2 74 30 8b 42 54 <8b> 00 8b 48 1c 85 c9 74 24 89 d0 ff d1 89 c2 8b 43 08 66 83 78 
> EIP: [<c118beb3>] pty_chars_in_buffer+0x13/0x50 SS:ESP 0068:f7a25b08
> CR2: 0000000000000000
> ---[ end trace 4eaa2a86a8e2da25 ]---
>
> And the machine wedged hard.
>
> ssh had got part way to establishing a connection from the other machine
> according to netstat -a.
>
> On reboot, I was able to log in as root perfectly fine.
>
> James
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
