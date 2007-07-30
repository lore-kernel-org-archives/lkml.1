Return-Path: <linux-kernel-owner+w=401wt.eu-S939019AbXG3Gso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939019AbXG3Gso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 02:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935035AbXG3Gsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 02:48:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754888AbXG3Gsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 02:48:36 -0400
Message-ID: <46AD89BD.90204@redhat.com>
Date: Mon, 30 Jul 2007 14:48:29 +0800
From: Eugene Teo <eteo@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/bluetooth/hci_ldisc.c: fix possible	NULL	dereferences
References: <20070729144736.GA13275@kernel.sg>	 <1185727751.5868.60.camel@violet>  <46AD1A87.8050901@redhat.com> <1185777735.5868.86.camel@violet>
In-Reply-To: <1185777735.5868.86.camel@violet>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcel,

Marcel Holtmann wrote:
>>>> Commit 22ad42033b7d2b3d7928fba9f89d1c7f8a3c9581 did not completely fix all 
>>>> the possible NULL dereferences. Besides hci_uart_close(), we also need to 
>>>> make sure that hdev is valid before calling hci_{unregister,free}_dev().
>>> I don't see any issue. Without HCI_UART_PROTO_SET, the hdev will never
>>> be registered. So no need to protect it twice.
>> Correct me if I am wrong. HCI_UART_PROTO_SET bit is only set if hci_uart_tty_ioctl()
>> is called with HCIUARTSETPROTO. Is it possible for the HCI device to be registered
>> and then unregistered without setting the HCI_UART_PROTO_SET bit in hdev->flags?
> 
> look at the code. The hci_uart_tty_ioctl() is the only function that can
> register the HCI device. So besides opening the TTY and set the line
> discipline, you also have to the set the UART protocol running on top. I
> don't see any way you can achieve to register a HCI device without
> setting the HCI_UART_PROTO_SET bit in hu->flags.

Ok. Thanks for the explanation.

Eugene
