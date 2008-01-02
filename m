Return-Path: <linux-kernel-owner+w=401wt.eu-S1759475AbYABQI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475AbYABQI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 11:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754823AbYABQIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 11:08:18 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:50307 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754481AbYABQIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 11:08:17 -0500
Date: Wed, 2 Jan 2008 11:08:16 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <gregkh@suse.de>
cc: David Miller <davem@davemloft.net>, Dave Young <hidave.darkstar@gmail.com>,
       Greg KH <greg@kroah.com>, <peterz@infradead.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 01/12] Use mutex instead of semaphore in driver core
In-Reply-To: <20080102070008.GA31343@suse.de>
Message-ID: <Pine.LNX.4.44L0.0801021057020.4861-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jan 2008, Greg KH wrote:

> For most cases, yes, I agree with this, but due to the lockdep issues
> that occur here, and the whole mess with the suspend path and locking
> the device tree, that has been hashed out many times in the past, I am
> interested in trying to see if there is any real reason why this is
> absolutely necessary to convert.
> 
> If no one has noticed any issues in this area, I think the complexity
> that will be involved in any such conversion will strongly outweigh any
> simplicity that might be expected.
> 
> I'm very open to potential patches to do this, just don't ignore the
> issues that others have run into in the past when attempting this.

There are two separate things to consider here.  One is struct device 
and the other is struct class.

We know that replacing semaphores with mutexes in struct device doesn't 
sit well with lockdep.  However the replacement may work perfectly 
smoothly for struct class.  It would be worthwhile for Dave Young to 
separate out just that part and try it.

Alan Stern

