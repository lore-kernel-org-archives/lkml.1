Return-Path: <linux-kernel-owner+w=401wt.eu-S1762221AbXLTVeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762221AbXLTVeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 16:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760354AbXLTVeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 16:34:00 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43579 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754653AbXLTVd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 16:33:59 -0500
Date: Thu, 20 Dec 2007 21:26:29 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: David Newall <david@davidnewall.com>,
       Marcel Holtmann <marcel@holtmann.org>, linux-kernel@vger.kernel.org
Subject: Re: Kernel bug: bluetooth meets TTY layer
Message-ID: <20071220212629.46c0476a@the-village.bc.nu>
In-Reply-To: <476ACDC6.8070904@linux.intel.com>
References: <476A895C.7040903@linux.intel.com>
	<476AC51F.70400@davidnewall.com>
	<476ACDC6.8070904@linux.intel.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2007 21:17:10 +0100
Arjan van de Ven <arjan@linux.intel.com> wrote:

> David Newall wrote:
> > Hi Arjan,
> > 
> > I've not been able to find this file, "drivers/bluetooth/hci_tty.c", but 
> > anyway, This seems to be what happens: Hci_uart_close() flushes using 
> > hci_uart_flush().  Subsequently, in hci_dev_do_close(), (one step in 
> > hci_unregister_dev()), hci_uart_flush() is called again.  The comment in 
> > uart_flush_buffer(), relating to the WARN_ON(), indicates you can't 
> > flush after the port is closed; which sounds reasonable.  I think 
> > hci_uart_close() should set hdev->flush to NULL before returning.  
> > Hci_dev_do_close() does check for this.  The code path is rather 
> > involved and I'm not entirely clear of all steps, but I think that's 
> > what should be done.
> > 
> > Patch for stupidly obsolete kernel attached.
> 
> looks reasonable; unfortunately I don't know the tty code well enough to judge this patch...
> Alan?

I don't know the bluetooth code well enough to even guess and I've not
had time to study this one. 

Alan
