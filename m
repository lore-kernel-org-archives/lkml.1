Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbZBQDJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbZBQDJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 22:09:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750744AbZBQDJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 22:09:44 -0500
Received: from netrider.rowland.org ([192.131.102.5]:1893 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750705AbZBQDJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 22:09:44 -0500
Date: Mon, 16 Feb 2009 22:09:42 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
In-Reply-To: <200902170008.31054.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0902162156380.24097-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Feb 2009, Rafael J. Wysocki wrote:

> Phase 1: I agree that system-auto-suspend-on, system-auto-suspend-off would be
> useful, but I don't like the wakelocks interface.  Do you think there is an
> alternative way/mechanism of doing this?

I rather like the suggestions Matthew Garrett has been making.  They 
show how to improve the wakelock interface without losing any function.

Really, the idea behind wakelocks comes down to the question of how to
determine when the system is sufficiently idle to go into auto-suspend.  
There may be occasions when no task is runnable but userspace knows
that the system should not go to sleep because some work will be done
in the near future.  (Arve's example of a non-empty input buffer is
such a case.)  How should userspace let the kernel know whether it's
okay to suspend at these times?  That is the problem userspace
wakelocks are meant to solve.

Kernel wakelocks are a separate matter.  They are more like a form of 
optimization, preventing the kernel from starting an auto-suspend when 
some driver knows beforehand that it will return -EBUSY.

> Phase 3: Probably explicit control left to open/close.

While that's generally a good idea, it's important to recognize that 
some devices should be runtime-suspended even while they are open.  
Basically, any device that is "always open" falls in this category.  
Some examples are the screen, the keyboard, the mouse, and disk drives.  
And of course, some of these things already have runtime power 
management.

Alan Stern

