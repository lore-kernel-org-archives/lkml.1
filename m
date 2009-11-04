Return-Path: <linux-kernel-owner+w=401wt.eu-S1753033AbZKDBBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033AbZKDBBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 20:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbZKDBBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 20:01:17 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:57425 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbZKDBBQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 20:01:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YX2kIWnkxdVT95MBwFTrtxyHOEyznAughdVgDtANtge8bn2pS62yz/MLuwPJF642tQ
         G+ZmjwVaO/XEtJGZ0IofyB9Smghx91UmZm+4Pf0n2zjWiFAaInwihiJvrpV9zmemFPyZ
         yb0L5Vlrn1g3gAyI9b6dopkTFENBqgtREKw2s=
MIME-Version: 1.0
In-Reply-To: <20091030061635.GB28648@elf.ucw.cz>
References: <20091030061635.GB28648@elf.ucw.cz>
Date: Wed, 4 Nov 2009 09:01:20 +0800
Message-ID: <a8e1da0911031701q4328604ayef5ee7eb939a9d50@mail.gmail.com>
Subject: Re: 2.6.32-rc5: bluetooth still broken
From: Dave Young <hidave.darkstar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 30, 2009 at 2:16 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
> Today I got this... IIRC I was told it was fixed already...?

Hi, this looks like another case.  Can you tell the way to reproduce?

>
>                                                                        Pavel
>
> ehci_hcd 0000:00:1d.7: suspend root hub
> EXT3 FS on sda4, internal journal
> kjournald starting.  Commit interval 5 seconds
> EXT3 FS on sda2, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> iwl3945 0000:03:00.0: firmware: requesting iwlwifi-3945-2.ucode
> iwl3945 0000:03:00.0: iwlwifi-3945-2.ucode firmware file req failed: -2
> iwl3945 0000:03:00.0: firmware: requesting iwlwifi-3945-1.ucode
> iwl3945 0000:03:00.0: Loaded firmware iwlwifi-3945-1.ucode, which is deprecated.  Please use API v2 instead.
> iwl3945 0000:03:00.0: Firmware has old API version. Expected 2, got 1. New firmware can be obtained from http://www.intellinuxwireless.org.
> iwl3945 0000:03:00.0: loaded firmware version 15.28.1.8
> Registered led device: iwl-phy0::radio
> Registered led device: iwl-phy0::assoc
> Registered led device: iwl-phy0::RX
> Registered led device: iwl-phy0::TX
> coda_read_super: Bad mount data
> coda_read_super: device index: 0
> coda_read_super: rootfid is (01234567.ffffffff.08051b10.00000000)
> coda: Unexpected interruption.
> Failure of coda_cnode_make for root: error -4
> CE: hpet increasing min_delta_ns to 15000 nsec
> CE: hpet increasing min_delta_ns to 22500 nsec
> uhci_hcd 0000:00:1d.3: reserve dev 2 ep81-INT, period 1, phase 0, 23 us
> INFO: trying to register non-static key.
> the code is fine but needs lockdep annotation.
> turning off the locking correctness validator.
> Pid: 30385, comm: ps Not tainted 2.6.32-rc5-00154-gfbad3ad-dirty #83
> Call Trace:
>  [<c0791da9>] ? printk+0x18/0x1a
>  [<c0255492>] __lock_acquire+0x4a2/0xad0
>  [<c0255b28>] lock_acquire+0x68/0x90
>  [<c06733bd>] ? skb_dequeue+0x1d/0x70
>  [<c0794e0b>] _spin_lock_irqsave+0x3b/0x50
>  [<c06733bd>] ? skb_dequeue+0x1d/0x70
>  [<c06733bd>] skb_dequeue+0x1d/0x70
>  [<c0674034>] skb_queue_purge+0x14/0x20
>  [<c07139a7>] l2cap_recv_frame+0x5d7/0x3270
>  [<c02551e5>] ? __lock_acquire+0x1f5/0xad0
>  [<c02551e5>] ? __lock_acquire+0x1f5/0xad0
>  [<c06732c9>] ? skb_queue_tail+0x39/0x50
>  [<c02551e5>] ? __lock_acquire+0x1f5/0xad0
>  [<c050cd50>] ? usb_submit_urb+0x140/0x360
>  [<c02551e5>] ? __lock_acquire+0x1f5/0xad0
>  [<c07167d2>] l2cap_recv_acldata+0x192/0x3d0
>  [<c07079b8>] ? hci_rx_task+0x268/0x440
>  [<c0716640>] ? l2cap_recv_acldata+0x0/0x3d0
>  [<c07079e5>] hci_rx_task+0x295/0x440
>  [<c02551e5>] ? __lock_acquire+0x1f5/0xad0
>  [<c0235b30>] tasklet_action+0x50/0xb0
>  [<c0236275>] __do_softirq+0x85/0x110
>  [<c023632d>] do_softirq+0x2d/0x40
>  [<c0236495>] irq_exit+0x65/0x80
>  [<c0204bbf>] do_IRQ+0x4f/0xc0
>  [<c02034a9>] common_interrupt+0x29/0x30
>  [<c0794a2f>] ? _write_unlock_irq+0x1f/0x30
>  [<c023474f>] do_exit+0x3df/0x650
>  [<c021bdc2>] ? do_page_fault+0x152/0x240
>  [<c02349f3>] do_group_exit+0x33/0x90
>  [<c0234a63>] sys_exit_group+0x13/0x20
>  [<c0202e50>] sysenter_do_call+0x12/0x31
> e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
> 0000:02:00.0: eth0: 10/100 speed: disabling TSO
> hci_acl_tx_to: hci0 ACL tx timeout
> hci_acl_tx_to: hci0 killing stalled ACL connection 80:09:6E:BA:21:00
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bluetooth" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Regards
dave
