Return-Path: <linux-kernel-owner+w=401wt.eu-S1756924AbXEXKgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbXEXKgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 06:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754922AbXEXKga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 06:36:30 -0400
Received: from gw.goop.org ([64.81.55.164]:53546 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754443AbXEXKg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 06:36:29 -0400
Message-ID: <46556AA6.7040503@goop.org>
Date: Thu, 24 May 2007 11:36:22 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Auke Kok <auke-jan.h.kok@intel.com>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: rmmod e1000 hangs (Was Re: 2.6.22-rc2-mm1)
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
In-Reply-To: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc2/2.6.22-rc2-mm1/
>   

I got a hang while rmmodding e1000.  sysrq-t shows:

rmmod         D 003FFAFC  6616 15923  15911 (NOTLB)
       e9341e44 00000092 82318c15 003ffafc e9341e2c 00000000 e9341e14 823187a1 
       003ffafc 00000000 c0123862 d3dbab80 d3dbad1c c2c08a40 77a67d01 000001ca 
       00000292 e9341e24 c03799cd e9341e54 c0540840 e9341e44 00223389 000000ff 
Call Trace:
 [<c03777b1>] schedule_timeout+0x70/0x8e
 [<c03777e4>] schedule_timeout_uninterruptible+0x15/0x17
 [<c0133d04>] msleep+0x10/0x16
 [<c030d5e0>] dev_close+0x39/0x6b
 [<c030d6ba>] unregister_netdevice+0xa8/0x1b9
 [<c030d7dd>] unregister_netdev+0x12/0x1a
 [<f89b441e>] e1000_remove+0x38/0xcc [e1000]
 [<c0229838>] pci_device_remove+0x19/0x39
 [<c029539a>] __device_release_driver+0x74/0x90
 [<c0295841>] driver_detach+0xa2/0xe1
 [<c0294f16>] bus_remove_driver+0x5d/0x79
 [<c02958a7>] driver_unregister+0x8/0xa
 [<c02299a2>] pci_unregister_driver+0x13/0x55
 [<f89c23a3>] e1000_exit_module+0xd/0xf [e1000]
 [<c0150d96>] sys_delete_module+0x180/0x1a6
 [<c0107fc6>] sysenter_past_esp+0x6b/0xb5
 =======================


The machine seemed otherwise happy, except the keyboard stopped working
shortly afterwards.  I'm not willing to say that's related, but it did
limit how much information I could extract about the state of the
machine at the time.

e1000 wasn't working very well before I tried to rmmod it; it all seemed
OK, but dhcpclient was failing to get an address.

I wonder if it might have something to do with Herbert's carrier changes?

    J
