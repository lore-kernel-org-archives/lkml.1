Return-Path: <linux-kernel-owner+w=401wt.eu-S934787AbXJQP4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934787AbXJQP4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 11:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763083AbXJQP4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 11:56:23 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47911 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1762484AbXJQP4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 11:56:22 -0400
Date: Wed, 17 Oct 2007 11:56:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: David Miller <davem@davemloft.net>, <david-b@pacbell.net>,
       <linux-usb-users@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-usb-users] OHCI root_port_reset() deadly loop...
In-Reply-To: <20071016222037.GA23793@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0710171152030.4468-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007, Greg KH wrote:

> But perhaps we can order the hardware init stuff from all three together
> like this into a separate module they all depend on.  In a way, that's
> what the lock tried to do, right?  Are we just not catching all places
> we could have hardware being talked to by two modules at the same time?

No, we do catch the one place where it happens.  The problem seems to
be that the hardware update takes some time.  That is, on one side we
take the write lock, talk to the EHCI hardware, and drop the write
lock.  On the other side we take the read lock, talk to the OHCI 
hardware, and drop the read lock.  Nevertheless, the interference 
occurs.  David B.'s interpretation is that the hardware's change of 
state takes more time than the CPU uses in manipulating locks and 
switching tasks.  Hence his suggestion for adding a delay.

Alan Stern

