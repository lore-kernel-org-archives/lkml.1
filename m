Return-Path: <linux-kernel-owner+w=401wt.eu-S965729AbXG2WyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965729AbXG2WyT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 18:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964974AbXG2WyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 18:54:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965050AbXG2WyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 18:54:08 -0400
Message-ID: <46AD1A87.8050901@redhat.com>
Date: Mon, 30 Jul 2007 06:53:59 +0800
From: Eugene Teo <eteo@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/bluetooth/hci_ldisc.c: fix possible NULL	dereferences
References: <20070729144736.GA13275@kernel.sg> <1185727751.5868.60.camel@violet>
In-Reply-To: <1185727751.5868.60.camel@violet>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcel,

Marcel Holtmann wrote:
>> Commit 22ad42033b7d2b3d7928fba9f89d1c7f8a3c9581 did not completely fix all 
>> the possible NULL dereferences. Besides hci_uart_close(), we also need to 
>> make sure that hdev is valid before calling hci_{unregister,free}_dev().
> 
> I don't see any issue. Without HCI_UART_PROTO_SET, the hdev will never
> be registered. So no need to protect it twice.

Correct me if I am wrong. HCI_UART_PROTO_SET bit is only set if hci_uart_tty_ioctl()
is called with HCIUARTSETPROTO. Is it possible for the HCI device to be registered
and then unregistered without setting the HCI_UART_PROTO_SET bit in hdev->flags?

Thanks,
Eugene
