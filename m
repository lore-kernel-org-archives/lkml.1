Return-Path: <linux-kernel-owner+w=401wt.eu-S1762775AbYHESUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762775AbYHESUF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 14:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761438AbYHESTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 14:19:54 -0400
Received: from ik-out-1112.google.com ([66.249.90.177]:5578 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755555AbYHESTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 14:19:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=q5sc5d/U6O7csjHEodvxB4JVXbTRGGI7/wseLViMyJxvFSmApdkU8vPMz2FtjIzDxD
         UnQNhv9+pJe53xZmWSR64XDG8NrKgpdBCYYp59tfPoe9aB49CUw+B1y1FpbbsUWrwQGU
         bC9ZZ0EYb2pklcmATCGT+tnmzUMCYBaPRurDU=
To: Peter Chubb <peterc@gelato.unsw.edu.au>
Subject: Re: Fixing rt2500pci
Date: Tue, 5 Aug 2008 20:44:18 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       John Linville <linville@tuxdriver.com>
References: <87tze8vu18.wl%peterc@chubb.wattle.id.au> <87tze61yt7.wl%peterc@chubb.wattle.id.au> <87ljzci2qk.wl%peterc@chubb.wattle.id.au>
In-Reply-To: <87ljzci2qk.wl%peterc@chubb.wattle.id.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808052044.19130.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 August 2008, Peter Chubb wrote:
> >>>>> "Peter" == Peter Chubb <peterc@gelato.unsw.edu.au> writes:
> 
> Peter> Ther appears to be another problem in here somewhere.  Every
> Peter> now and then I get a general protect fault with this card and
> Peter> 2.6.27-rc1.  This is on an AMD64 box.  I'm not sure I entirely
> Peter> believe the stack backtrace.
> 
> I recompiled with frame pointers.  Here's another trace.  i believe
> this one :-) This is 2.6.27-rc1 as of 4/8/2008 with my patch applied

I am still not completely happy with the trace, but it at least points a bit
clearer to the source of the problem.

Are you running rt2500pci in managed or adhoc mode?
And when does this bug trigger, when authenticating, associating,
deauthentication or random?

Also could you post some of the rt2500/mac80211 debug messages from the
log from before the actual bug?

Ivo

> general protection fault: 0000 [1] PREEMPT 
> CPU 0 
> Modules linked in: radeon rfcomm l2cap bluetooth sd_mod scsi_mod pcmcia rt2500pci rt2x00pci rt2x00lib led_class mac80211 i2c_piix4 rtc_cmos firewire_ohci snd_hda_intel eeprom_93cx6 rtc_core yenta_socket firewire_core serio_raw usbhid rtc_lib rsrc_nonstatic i2c_core snd_hwdep hid
> Pid: 2181, comm: rt2500pci Not tainted 2.6.27-rc1 #51
> RIP: 0010:[<ffffffff80260c8d>]  [<ffffffff80260c8d>] put_page+0xc/0xd6
> RSP: 0018:ffff88003fbd9bf0  EFLAGS: 00010286
> RAX: 0000000000000000 RBX: fd94ea9eed2c0b41 RCX: 0000000000000000
> RDX: ffff8800352b89c0 RSI: 0000000000000000 RDI: fd94ea9eed2c0b41
> RBP: ffff88003fbd9c00 R08: ffff88003f32e2a0 R09: 0000000000000002
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
> R13: ffff8800352b8014 R14: ffff88003cc0c000 R15: 0000000000000000
> FS:  00007fb7bcdbe6f0(0000) GS:ffffffff8068ae40(0000) knlGS:00000000f7bcf6c0
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 00000000006d20c8 CR3: 000000003527c000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process rt2500pci (pid: 2181, threadinfo ffff88003fbd8000, task ffff88003fb00b00)
> Stack:  0000000000000000 ffff880035283900 ffff88003fbd9c20 ffffffff80482ee8
>  ffff880035283900 ffff88003cc60c00 ffff88003fbd9c40 ffffffff8048358a
>  ffff88003cc60c00 ffff880035283900 ffff88003fbd9c60 ffffffff80482d85
> Call Trace:
>  [<ffffffff80482ee8>] skb_release_data+0x68/0xac
>  [<ffffffff8048358a>] skb_release_all+0x6f/0x73
>  [<ffffffff80482d85>] __kfree_skb+0x11/0x77
>  [<ffffffff80482e11>] kfree_skb+0x26/0x28
>  [<ffffffffa00a8ee4>] ieee80211_sta_rx_queued_mgmt+0xd5f/0xd85 [mac80211]
>  [<ffffffff804835fa>] ? __alloc_skb+0x3b/0x12e
>  [<ffffffff80496f9d>] ? __qdisc_run+0xd1/0x1ea
>  [<ffffffff8048b197>] ? dev_queue_xmit+0x427/0x468
>  [<ffffffff8036b433>] ? delay_tsc+0x25/0xa2
>  [<ffffffff8036b3a5>] ? __delay+0xa/0xc
>  [<ffffffff8036b3c9>] ? __const_udelay+0x22/0x24
>  [<ffffffffa00cf11f>] ? rt2500pci_bbp_check+0x35/0x45 [rt2500pci]
>  [<ffffffffa00aa066>] ieee80211_sta_work+0x99/0x6c3 [mac80211]
>  [<ffffffff8052ae7e>] ? thread_return+0x30/0xa9
>  [<ffffffffa00a9fcd>] ? ieee80211_sta_work+0x0/0x6c3 [mac80211]
>  [<ffffffff8023a2b9>] run_workqueue+0xb2/0x178
>  [<ffffffff8023ac9a>] worker_thread+0xd3/0xe0
>  [<ffffffff8023d9b1>] ? autoremove_wake_function+0x0/0x38
>  [<ffffffff8023abc7>] ? worker_thread+0x0/0xe0
>  [<ffffffff8023d8a1>] kthread+0x49/0x78
>  [<ffffffff8020bc59>] child_rip+0xa/0x11
>  [<ffffffff8023d858>] ? kthread+0x0/0x78
>  [<ffffffff8020bc4f>] ? child_rip+0x0/0x11
> 
> 
> Code: f6 80 38 e0 ff ff 08 74 05 e8 ea a2 2c 00 5e 5b c9 c3 55 48 89 e5 e8 71 ff ff ff c9 31 c0 c3 55 48 89 e5 53 48 89 fb 48 83 ec 08 <f7> 07 00 60 00 00 74 0a e8 05 f9 ff ff e9 b4 00 00 00 ff 4f 08 
> RIP  [<ffffffff80260c8d>] put_page+0xc/0xd6
>  RSP <ffff88003fbd9bf0>
> 


