Return-Path: <linux-kernel-owner+w=401wt.eu-S1751150AbZHLVML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751150AbZHLVML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 17:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751032AbZHLVMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 17:12:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48508 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751005AbZHLVMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 17:12:09 -0400
Date: Wed, 12 Aug 2009 17:12:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [RFC][PATCH 0/3] PM: Asynchronous suspend and resume
In-Reply-To: <200908122218.13975.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0908121702520.23954-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Aug 2009, Rafael J. Wysocki wrote:

> Hi,
> 
> The following patches introduce a mechanism allowing us to execute device
> drivers' suspend and resume callbacks asynchronously during system sleep
> transitions, such as suspend to RAM.  The idea is explained in the [1/1] patch
> message.
> 
> Comments welcome.

I get the idea.  Not bad.  Have you tried it in a serious way?  For 
example, turning on the async_suspend flag for every device?

In one way it isn't as efficient as it could be.  You fire off a bunch
of async threads and then make many of them wait for parent or child
devices.  They could be doing useful work instead.

It would be interesting to invent a way of representing explicitly the 
non-tree dependencies -- assuming there aren't too many of them!  (I 
can just hear the TI guys hollering about power and timer domains...)

Alan Stern

