Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818AbZGUOey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbZGUOey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 10:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbZGUOey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 10:34:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48489 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752571AbZGUOex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 10:34:53 -0400
Date: Tue, 21 Jul 2009 10:34:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jason Wessel <jason.wessel@windriver.com>
cc: gregkh@suse.de, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <dbrownell@users.sourceforge.net>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 07/10] ehci-dbgp,ehci: Allow early or late use of the
 dbgp device
In-Reply-To: <4A657296.4050002@windriver.com>
Message-ID: <Pine.LNX.4.44L0.0907211033390.2967-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jul 2009, Jason Wessel wrote:

> Alan Stern wrote:
> > On Mon, 20 Jul 2009, Jason Wessel wrote:
> >> +    /* optional debug port, normally in the first BAR */
> >> +    temp = pci_find_capability(pdev, 0x0a);
> > This isn't going to work very well on systems with non-PCI EHCI
> > controllers.  Maybe you should leave debug-port detection in
> > ehci-pci.c.  The controller doesn't get reset very much in any case.
> >
>  
> 
> The high level debug port detection still needed to move, but you are
> correct, it needs to move with in the ehci-pci.c.
> 
> The ehci_reset() definitely clears the debug controller in the pci
> probe call to ehci_pci_setup().  The debug port detect code just needs
> to get called before the ehci_reset() in this case.
> 
> The repaired patch is inline below.

This is much better.

Alan Stern

