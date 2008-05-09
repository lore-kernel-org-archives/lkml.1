Return-Path: <linux-kernel-owner+w=401wt.eu-S932145AbYEITQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145AbYEITQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 15:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbYEITQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 15:16:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:32324 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756421AbYEITQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 15:16:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=jZ8z2ZKgHnp3/jxEFULybxUdk4f4Jy9PGA1aMtGRdwM6EOMAE4knaEn/OsnLBUMS3y08MA6ey6aQJOlHsdNfbd/tg5JOoDJ7GUHWiyS0OC/65rSjn9P2x+8Gg3413/2gr5oM/qj0Lru0J7WITBxPU1RTlUolgZXWnCmxQYqrCfE=
Date: Fri, 9 May 2008 21:16:19 +0200
From: Karol Lewandowski <lmctlx@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Karol Lewandowski <lmctlx@gmail.com>, ibm-acpi-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [ibm-acpi-devel] BUG: linux-2.6.26-rc1 oops at thinkpad_acpi:led_set_status
Message-ID: <20080509191619.GA2166@localdomain>
References: <20080508231227.GA9157@localdomain> <20080509035306.GA10978@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080509035306.GA10978@khazad-dum.debian.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 12:53:06AM -0300, Henrique de Moraes Holschuh wrote:
> On Fri, 09 May 2008, Karol Lewandowski wrote:
> > On my Thinkpad T21 executing:
> 
> Please send me by private email the acpidump and dmidecode information
> for your ThinkPad, I don't have any for the T21.  Feel free to
> XXXXXX-out the UUID and serial number of your T21 in the dmidecode
> output.

(Sent.)


> The machine was clean after a boot, correct? (no sleeps or other
> known-to-be-busted-in-2.6.26 operations before the OOPS?)

Yes, that's after clean boot.

 
> Assuming the comments on the LED code from the first ibm-acpi maintainer
> are correct, the T20-T22 use the same LED interface, the "LED_OLD"
> ibm-acpi codepath.  That codepath is indeed NOT tested often, as I don't
> have a way to do so.  Bugs there wouldn't surprise me too much.

Well, I try to "test" that... actually I try to use it, and see if it
breaks horribly. ;-)

It's regression from 2.6.25.

 
> If you try it using the sysfs led class, do you get the same OOPS? (I
> expect you to. If you don't, I *need* to know this).

Yes, I get oops in the same place, call stack is different of course.

BUG: unable to handle kernel paging request at d096a000
IP: [<d0960534>] :thinkpad_acpi:led_set_status+0xac/0xc3
*pde = 0f81c067 *pte = 00000000 
Oops: 0002 [#1] PREEMPT 
Modules linked in: nfs lockd nfs_acl sunrpc ipv6 autofs4 nls_iso8859_1 dm_snapshot dm_mirror dm_log thinkpad_acpi hwmon backlight led_class nvram fuse irtty_sir sir_dev snd_cs46xx snd_seq_midi snd_rawmidi rt2500pci rt2x00pci parport_pc rt2x00lib irda snd_ac97_codec parport uhci_hcd eeprom_93cx6 ac97_bus

Pid: 1253, comm: ktpacpid Not tainted (2.6.26-rc1-bizet #4)
EIP: 0060:[<d0960534>] EFLAGS: 00010246 CPU: 0
EIP is at led_set_status+0xac/0xc3 [thinkpad_acpi]
EAX: 00000000 EBX: 00000080 ECX: cf801150 EDX: 00000000
ESI: 00000000 EDI: cfb891e8 EBP: d096054b ESP: ced1ff9c
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process ktpacpid (pid: 1253, ti=ced1f000 task=cfafd630 task.ti=ced1f000)
Stack: cfb891ec cfbc6fe0 c0126f5f cfbc6fe0 c0127573 ced1ffd0 00000000 c012761d 
       00000000 cfafd630 c01298b2 ced1ffc8 ced1ffc8 cfbc6fe0 00000000 c01297ff 
       c01297c9 00000000 c0104293 cec14dec 00000000 00000000 00000000 4efbfdff 
Call Trace:
 [<c0126f5f>] run_workqueue+0x83/0x10e
 [<c0127573>] worker_thread+0x0/0xb4
 [<c012761d>] worker_thread+0xaa/0xb4
 [<c01298b2>] autoremove_wake_function+0x0/0x2d
 [<c01297ff>] kthread+0x36/0x5b
 [<c01297c9>] kthread+0x0/0x5b
 [<c0104293>] kernel_thread_helper+0x7/0x10
 =======================
Code: eb 25 ff 34 b5 f0 24 96 d0 53 68 f8 29 96 d0 6a 00 6a 00 ff 35 ec 9d 96 d0 e8 65 ec ff ff 83 c4 18 85 c0 74 0f eb 14 85 c0 75 14 <89> 34 9d 00 9e 96 d0 eb 0b b8 fb ff ff ff eb 04 31 c0 eb ec 5b 
EIP: [<d0960534>] led_set_status+0xac/0xc3 [thinkpad_acpi] SS:ESP 0068:ced1ff9c
---[ end trace 7c7a86bd66b8f726 ]---

 
> Is it always a problem with the last led (number 7), or other leds also
> cause the OOPS?

Leds 1-6 are ok, i.e. they do change state (on/off) and don't cause
ill effects.

Writing anything (on/off/blink) to led 7 (procfs) or "tpacpi::standby"
(sysfs) causes an reproductible oops.


> Also, please try the patch below, and send me the debug output it will
> generate.

Hmm, I added following to my .config and recompiled kernel with your patch:

 +CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y	# this was automatically added
 +CONFIG_DEBUG_BUGVERBOSE=y
 +CONFIG_DEBUG_INFO=y
 +CONFIG_FRAME_POINTER=y

The result is:

 thinkpad_acpi: debug: led 7, status 1, mode 2
 thinkpad_acpi: debug: led is now 0x80
 thinkpad_acpi: debug: will write A=0x0, B=0x80

Yes, no oops...  writing on/off/blink all works through procfs and
sysfs interface works too.

Without .config changes:

 thinkpad_acpi: debug: led 7, status 1, mode 2
 thinkpad_acpi: debug: led is now 0x80
 thinkpad_acpi: debug: will write A=0x0, B=0x80

No oops here either.  Reverting this patch gives:

BUG: unable to handle kernel paging request at d098e000
IP: [<d0984534>] :thinkpad_acpi:led_set_status+0xac/0xc3
*pde = 0f81c067 *pte = 00000000 
Oops: 0002 [#1] PREEMPT 
Modules linked in: nfs lockd nfs_acl sunrpc ipv6 autofs4 nls_iso8859_1 dm_snapshot dm_mirror dm_log thinkpad_acpi hwmon backlight led_class nvram fuse irtty_sir sir_dev snd_cs46xx snd_seq_midi snd_rawmidi rt2500pci rt2x00pci snd_ac97_codec rt2x00lib parport_pc parport ac97_bus irda eeprom_93cx6 uhci_hcd

Pid: 2119, comm: bash Not tainted (2.6.26-rc1-git+afa26be-tpacpi+patch #2)
EIP: 0060:[<d0984534>] EFLAGS: 00010246 CPU: 0
EIP is at led_set_status+0xac/0xc3 [thinkpad_acpi]
EAX: 00000000 EBX: 00000080 ECX: cf801150 EDX: 00000000
ESI: 00000001 EDI: 00000005 EBP: d098d660 ESP: cef7af1c
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process bash (pid: 2119, ti=cef7a000 task=cf89f0d0 task.ti=cef7a000)
Stack: cecc6588 fffffff4 d0986028 cecc658e 00000007 cecc6588 d0986433 09954c08 
       d09863d1 cf95e080 09954c08 fffffffb c0190dc7 d098d660 cfb83c60 c0190da2 
       cf95e080 c018d5a5 cef7afa0 00000005 09954c08 cf95e080 09954c08 c018d528 
Call Trace:
 [<d0986028>] led_write+0x83/0xa1 [thinkpad_acpi]
 [<d0986433>] dispatch_procfs_write+0x62/0x7f [thinkpad_acpi]
 [<d09863d1>] dispatch_procfs_write+0x0/0x7f [thinkpad_acpi]
 [<c0190dc7>] proc_file_write+0x25/0x2e
 [<c0190da2>] proc_file_write+0x0/0x2e
 [<c018d5a5>] proc_reg_write+0x7d/0x90
 [<c018d528>] proc_reg_write+0x0/0x90
 [<c015ed04>] vfs_write+0x83/0xf6
 [<c015f192>] sys_write+0x3c/0x63
 [<c0103721>] sysenter_past_esp+0x6a/0x91
 [<c0320000>] ieee80211_duration+0x157/0x189
 =======================
Code: eb 25 ff 34 b5 f0 64 98 d0 53 68 f8 69 98 d0 6a 00 6a 00 ff 35 ec dd 98 d0 e8 65 ec ff ff 83 c4 18 85 c0 74 0f eb 14 85 c0 75 14 <89> 34 9d 00 de 98 d0 eb 0b b8 fb ff ff ff eb 04 31 c0 eb ec 5b 
EIP: [<d0984534>] led_set_status+0xac/0xc3 [thinkpad_acpi] SS:ESP 0068:cef7af1c
---[ end trace a75276ec710f1fa4 ]---


Any ideas?

(Newest kernel out there, namely git:28a4acb, still produces oops. :-)
