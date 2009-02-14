Return-Path: <linux-kernel-owner+w=401wt.eu-S1753337AbZBNMxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbZBNMxq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 07:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbZBNMxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 07:53:32 -0500
Received: from senator.holtmann.net ([87.106.208.187]:52798 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbZBNMxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 07:53:31 -0500
Subject: Re: [PATCH] Bluetooth USB: fix kernel panic during suspend - 2.6.24
From: Marcel Holtmann <marcel@holtmann.org>
To: Greg KH <greg@kroah.com>
Cc: Colin Ian King <colin.king@canonical.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20090213190953.GA958@kroah.com>
References: <1234518585.6647.26.camel@ubuntu>
	 <20090213190953.GA958@kroah.com>
Content-Type: text/plain
Date: Sat, 14 Feb 2009 13:53:22 +0100
Message-Id: <1234616002.7293.192.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

> > The kernel panics when hci_usb_tx_complete() calls _urb_unlink()
> > on an _urb which has been previously been removed from a list.
> > This occurs during suspend while audio is being streamed to
> > a bluetooth headset.
> > 
> > The panic occurs because hci_usb_suspend() dequeues _urb
> > and then calls usb_kill_urb() - instead it should put _urb on
> > the killed list first before killing the urb.
> > 
> > Also added a spin_lock around the list_add operation.
> > 
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> Is this still an issue on a supported-by-the-community kernel (.27, .28,
> .29)?

starting with 2.6.29 the hci_usb driver has been replaced by btusb.

Regards

Marcel


