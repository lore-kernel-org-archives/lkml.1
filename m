Return-Path: <linux-kernel-owner+w=401wt.eu-S938985AbXG3GkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938985AbXG3GkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 02:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938246AbXG3GkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 02:40:08 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:36246 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938489AbXG3GkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 02:40:07 -0400
Subject: Re: [PATCH] drivers/bluetooth/hci_ldisc.c: fix possible
	NULL	dereferences
From: Marcel Holtmann <marcel@holtmann.org>
To: Eugene Teo <eteo@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46AD1A87.8050901@redhat.com>
References: <20070729144736.GA13275@kernel.sg>
	 <1185727751.5868.60.camel@violet>  <46AD1A87.8050901@redhat.com>
Content-Type: text/plain
Date: Mon, 30 Jul 2007 08:42:15 +0200
Message-Id: <1185777735.5868.86.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eugene,

> >> Commit 22ad42033b7d2b3d7928fba9f89d1c7f8a3c9581 did not completely fix all 
> >> the possible NULL dereferences. Besides hci_uart_close(), we also need to 
> >> make sure that hdev is valid before calling hci_{unregister,free}_dev().
> > 
> > I don't see any issue. Without HCI_UART_PROTO_SET, the hdev will never
> > be registered. So no need to protect it twice.
> 
> Correct me if I am wrong. HCI_UART_PROTO_SET bit is only set if hci_uart_tty_ioctl()
> is called with HCIUARTSETPROTO. Is it possible for the HCI device to be registered
> and then unregistered without setting the HCI_UART_PROTO_SET bit in hdev->flags?

look at the code. The hci_uart_tty_ioctl() is the only function that can
register the HCI device. So besides opening the TTY and set the line
discipline, you also have to the set the UART protocol running on top. I
don't see any way you can achieve to register a HCI device without
setting the HCI_UART_PROTO_SET bit in hu->flags.

Regards

Marcel


