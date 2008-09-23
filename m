Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbYIWSO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbYIWSO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 14:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbYIWSOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 14:14:18 -0400
Received: from outbound-mail-110.bluehost.com ([69.89.22.10]:48694 "HELO
	outbound-mail-110.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751796AbYIWSOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 14:14:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=tNkhPtwL77dx+kr7qrMb+56VOzvtYk2eVRIIfb2Xh5n917Pp1sTlZiks7x+3yM8B7/owl3ZyvnHhdqWg4tWZAVtL4H+a97mIKL6x/hOpAg86d+xpP1X0AvRn0zNJEsbX;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Chiang <achiang@hp.com>
Subject: Re: [PATCH] PCI: connect struct pci_dev to struct pci_slot
Date: Tue, 23 Sep 2008 11:14:13 -0700
User-Agent: KMail/1.9.9
Cc: linux-pci <linux-pci@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <20080902154051.GA23638@ldl.fc.hp.com>
In-Reply-To: <20080902154051.GA23638@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809231114.13905.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 2, 2008 8:40 am Alex Chiang wrote:
> The introduction of struct pci_slot (f46753c5e354b857b20ab8e0fe7b25)
> added a struct pci_slot pointer to struct pci_dev, but we forgot to
> associate the two.
>
> Connect the two structs together; the interesting portions of the object
> lifetimes are:
>
> 	- when a new pci_slot is created, connect it to the appropriate
> 	  pci_dev's. A single pci_slot may be associated with multiple
> 	  pci_dev's, e.g. any multi-function PCI device.
>
> 	- when a pci_slot is released, look for all the pci_dev's it was
> 	  associated with, and set their pci_slot pointers to NULL
>
> 	- when a pci_dev is created, look for slots to associate with.
>
> Note -- when a pci_dev is released, we don't need to do any bookkeeping,
> since pci_slot's do not have pointers to pci_dev's.
>
> Signed-off-by: Alex Chiang <achiang@hp.com>

Applied to linux-next.  Thanks.

Jesse
