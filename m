Return-Path: <linux-kernel-owner+w=401wt.eu-S1761122AbXLTUfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761122AbXLTUfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 15:35:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756306AbXLTUek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 15:34:40 -0500
Received: from mga07.intel.com ([143.182.124.22]:59321 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760752AbXLTUei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 15:34:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,191,1196668800"; 
   d="scan'208";a="346341669"
Message-ID: <476ACDC6.8070904@linux.intel.com>
Date: Thu, 20 Dec 2007 21:17:10 +0100
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: David Newall <david@davidnewall.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Marcel Holtmann <marcel@holtmann.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Kernel bug: bluetooth meets TTY layer
References: <476A895C.7040903@linux.intel.com> <476AC51F.70400@davidnewall.com>
In-Reply-To: <476AC51F.70400@davidnewall.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall wrote:
> Hi Arjan,
> 
> I've not been able to find this file, "drivers/bluetooth/hci_tty.c", but 
> anyway, This seems to be what happens: Hci_uart_close() flushes using 
> hci_uart_flush().  Subsequently, in hci_dev_do_close(), (one step in 
> hci_unregister_dev()), hci_uart_flush() is called again.  The comment in 
> uart_flush_buffer(), relating to the WARN_ON(), indicates you can't 
> flush after the port is closed; which sounds reasonable.  I think 
> hci_uart_close() should set hdev->flush to NULL before returning.  
> Hci_dev_do_close() does check for this.  The code path is rather 
> involved and I'm not entirely clear of all steps, but I think that's 
> what should be done.
> 
> Patch for stupidly obsolete kernel attached.

looks reasonable; unfortunately I don't know the tty code well enough to judge this patch...
Alan?
