Return-Path: <linux-kernel-owner+w=401wt.eu-S1761783AbZATBh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761783AbZATBh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 20:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbZATBhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 20:37:12 -0500
Received: from cantor.suse.de ([195.135.220.2]:45390 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbZATBhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 20:37:11 -0500
Date: Mon, 19 Jan 2009 17:36:02 -0800
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       LKML <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: [PATCH] USB: Fix suspend-resume of PCI USB controllers
Message-ID: <20090120013602.GA8377@suse.de>
References: <200901200126.57839.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901200126.57839.rjw@sisk.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 01:26:56AM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Commit a0d4922da2e4ccb0973095d8d29f36f6b1b5f703
> (USB: fix up suspend and resume for PCI host controllers) attempted
> to fix the suspend-resume of PCI USB controllers, but unfortunately
> it did that incorrectly and interrupts are left enabled by the USB
> controllers' ->suspend_late() callback as a result.  This leads to
> serious problems during suspend which are very difficult to debug.
> 
> Fix the issue by removing the ->suspend_late() callback of PCI
> USB controllers and moving the code from there to the ->suspend()
> callback executed with interrupts enabled.  Additionally, make
> the ->resume() callback of PCI USB controllers execute
> pci_enable_wake(dev, PCI_D0, false) to disable wake-up from the
> full power state (PCI_D0).
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Tested-by: Andrey Borzenkov <arvidjaar@mail.ru>
> Tested-by: "Jeff Chua" <jeff.chua.linux@gmail.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Cc: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>


Alan, does this look ok for you?

thanks,

greg k-h
