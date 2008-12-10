Return-Path: <linux-kernel-owner+w=401wt.eu-S1754837AbYLJPKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbYLJPKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 10:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871AbYLJPKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 10:10:22 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:44075 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751169AbYLJPKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 10:10:22 -0500
Date: Wed, 10 Dec 2008 10:10:19 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb <linux-usb@vger.kernel.org>,
       Ian Jackson <Ian.Jackson@eu.citrix.com>
Subject: Re: Oops in UHCI when encountering "host controller process error"
In-Reply-To: <493EF5F8.5050008@goop.org>
Message-ID: <Pine.LNX.4.44L0.0812101006540.2175-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Dec 2008, Jeremy Fitzhardinge wrote:

> OK.  If the controller is idle and the kernel wants to submit it some 
> new work, where does that happen?  Can I stick a uhci_sprint_schedule() 
> there to see the state of the structures before it starts to work on them?

The entry point is uhci_urb_enqueue().  You can do whatever you like 
there, but bear in mind that it may be called in interrupt context.  
uhci_sprint_schedule() should be fine.

However I don't really see the point.  If the DMA pool allocations are 
so badly messed up that the initial setup is wrong, why bother to 
search any further?

Alan Stern

