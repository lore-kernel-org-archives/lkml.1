Return-Path: <linux-kernel-owner+w=401wt.eu-S1762848AbXK3J3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762848AbXK3J3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 04:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756896AbXK3J3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 04:29:01 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:35273 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322AbXK3J26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 04:28:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WLIDB2zVPIlQRbxQiVl/Qc1DTiOW+6+9Ba2zS9mVOQzFPxcu41vzu435h59MGrfa3QlOZWIJRQWvjncuEbo7gUiNOv2xptQCEds+ANS+IS2TIG4lcgxELo5C72xzWaaYbJ79DNSFYHHsTPDnJNJhWxxBgeDBknngDnSTvnWjQqw=
Message-ID: <40dfeece0711300128s731b3227xaa0b5982193e4b12@mail.gmail.com>
Date: Fri, 30 Nov 2007 09:28:56 +0000
From: "Chris Rutherford" <chrismrutherford@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: ldd irq problem
In-Reply-To: <40dfeece0711291447m2efa4f40i5c2c22a4273ecbc0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <40dfeece0711291447m2efa4f40i5c2c22a4273ecbc0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Helo lkml,

I'm trying to write a LDD but I have got a bug.  Any ideas what i
might be doing wrong?

ret = request_irq(12, handler, SA_INTERRUPT | SA_SHIRQ, "sha1
handler", DEVICE_NAME);
printk (KERN_INFO "req irq %d \n", ret);
enable_irq(12);

I am working on a linux device driver and trying to handle interupts.
using the code above I get the log messages below.

req irq 0
Unbalanced enable for IRQ 12
BUG: warning at kernel/irq/manage.c:118/enable_irq()
 [<c0140889>] enable_irq+0x54/0x87
 [<c02133de>] __driver_attach+0x0/0x5d
 [<e0b6f23b>] device_probe+0x16b/0x173 [raggedstone1]
 [<c01c33ce>] pci_device_probe+0x36/0x57
 [<c0213339>] driver_probe_device+0x42/0x91
 [<c0213416>] __driver_attach+0x38/0x5d
 [<c0212e58>] bus_for_each_dev+0x37/0x59
 [<c02132a3>] driver_attach+0x11/0x13
 [<c02133de>] __driver_attach+0x0/0x5d
 [<c0212b67>] bus_add_driver+0x6b/0xfd
 [<c01c3509>] __pci_register_driver+0x47/0x63
 [<c0135c67>] sys_init_module+0x1732/0x18b5
 [<c015a43b>] do_sync_read+0xb6/0xf1
 [<c016e2db>] dput+0x2a/0x119
 [<c0102bed>] sysenter_past_esp+0x56/0x79


Has any one seen this type of bug message before?  any idea what could
be causing it.

Thanks

Chris
