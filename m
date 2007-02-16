Return-Path: <linux-kernel-owner+w=401wt.eu-S1946278AbXBPWgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946278AbXBPWgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 17:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946275AbXBPWgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 17:36:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946278AbXBPWgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 17:36:13 -0500
Date: Fri, 16 Feb 2007 14:34:46 -0800
From: Pete Zaitcev <zaitcev@redhat.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
       zaitcev@redhat.com, linux-usb-devel@lists.sourceforge.net
Subject: usbnet/rndis (was: Is this bug too obvious?)
Message-Id: <20070216143446.a2134b3c.zaitcev@redhat.com>
In-Reply-To: <45D26222.9040504@redhat.com>
References: <45D25ABE.5080400@redhat.com>
	<Pine.LNX.4.64.0702132000220.20138@iabervon.org>
	<45D26222.9040504@redhat.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Feb 2007 20:13:06 -0500, Chuck Ebbert <cebbert@redhat.com> wrote:

> OK I'll keep looking for the cause of the oops then:
> 
> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=228231

> Feb 12 01:11:29 MyComputer kernel: ohci_hcd 0000:00:02.1: auto-wakeup
> Feb 12 01:11:30 MyComputer kernel: usb 2-3: new full speed USB device using ohci_hcd and address 2
> Feb 12 01:11:30 MyComputer kernel: usb 2-3: configuration #1 chosen from 1 choice
> Feb 12 01:11:30 MyComputer kernel: drivers/usb/class/cdc-acm.c: Ignoring extra header, type -3, length 4
> Feb 12 01:11:30 MyComputer kernel: cdc_acm 2-3:1.1: ttyACM0: USB ACM device
> Feb 12 01:11:30 MyComputer kernel: usbcore: registered new interface driver cdc_acm
> Feb 12 01:11:30 MyComputer kernel: drivers/usb/class/cdc-acm.c: v0.25:USB Abstract Control Model driver for USB modems and ISDN adapters
> Feb 12 01:11:31 MyComputer kernel: usbcore: registered new interface driver cdc_ether
> Feb 12 01:11:31 MyComputer kernel: rndis_host 2-3:1.9: RNDIS init failed, -110
> Feb 12 01:11:31 MyComputer kernel: usb%d: unregister 'rndis_host' usb-0000:00:02.1-3, RNDIS device
> Feb 12 01:11:31 MyComputer kernel: BUGging on (!PageSlab(page))
> Feb 12 01:11:31 MyComputer kernel: ------------[ cut here ]------------
> Feb 12 01:11:31 MyComputer kernel: kernel BUG at mm/slab.c:594!

This looks like a kfree with a bogus address, possibly poisoned.

If you don't do it sooner, I'll look at the error paths in rndis
and/or usbnet.

BTW, for USB code, it's best to send to linux-usb-devel@lists.sourceforge.net.

-- Pete
