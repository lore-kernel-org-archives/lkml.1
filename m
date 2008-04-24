Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbYDXBlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbYDXBlm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 21:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbYDXBle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 21:41:34 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:9088 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbYDXBld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 21:41:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=h7yo5My8WfaZTFLRXmsAGeC2OPJdgGEV1NxgtH8OXMI7aOsbI8+K05xJNOEFBTNOf5SBmhhr7rKjZPD0xLJI1e7o6RxMeOwVecaCL1qBTM8tNBb3+BLQHiKi9wX3Q7c8oXOGcBiPwi8nXd3P7dxKAoYkKs3cCEapg1Kf7K1KzkU=
Message-ID: <dd18b0c30804231841m3bbfab44x53d635b7ea6fc58d@mail.gmail.com>
Date: Thu, 24 Apr 2008 01:41:32 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: spinlock lockup on CPU#0
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I recorded a .mov of a spinlock, but cant seem to send it out,
so I have to manually write it down:

BUG: spinlock lockup on CPU#0, swapper/0, c17fa6c0
Pid: 0. swapper Not tainted 2.6.25-03562-g3dc5063 #1
[<c0219fbb>]  _raw_spin_lock+0xd5/0xf9
[<c0377c6b>] _spin_lock+0x8/0xa
[<c011cdce>]  task_rq_lock+0x44/0x6b
[<c011cfb4>]   try_to_wake+0x2a/0x1c4
[<co11d159>]  default_wake_function+0xb/0xd
[<co118847>] __wake_up_common+0x2f/0x5a
[<c011bc11>] complete+0x2b/0x3e
[<c02ad79a>] usb_api_blocking_completion+0x13/0x15
[<c02abadc>] usb_hcd_giveback_urb+0x52/0x82
[<f88686c7>] ehci_urb_done+0x6f/0x7c [ehci_hcd]
[<f8869614>] qh_completions+0x2d7/0x348 [ehci_hcd]
[<f8869721>] ehci_work+0x9c [ehci_hcd]
[<c0107c35>] ? sched_clock+0xb/0x1c
[<c0119bec>] ? __update_rq_clock+0x94/0x15a
[<f886c827>] ehci_irq+0x138/0x15f [ehci_hcd]
[<c02abd9> ] usb_hcd_irq+0x23/0x51
[<c0151c43>] handle_IRQ_event+0x2a/0x5a
[<c0152d2c>] handle_fasteoi_irq+0x74/0xb6
[<c01058c5>] do_IRQ+0x71/0x8c
[<c01042f7>] common_interrupt+0x23/0x28
[<c011fb07>] ? sched_clock_idle_wakeup_event+0x5b/0x74
[<c02cc212>] acpi_idle_enter_bm+0x2a4/0x31f    [processor]
[<c02cc212>] cpuidle_idle_call+0x5c/0x8c
[<c02cc1b4>] ? cpuidle_idle_call+0x0/0x8c
[<c0102571>] cpu_idle+0xb1/0xd1
[<c036b371>] reset_init+0x49/0x4b
=====================================================


Hopefully the numbers are right, and hopefully this provides enough
info to help the kernel out
regards;

-- 
Justin P. Mattock
