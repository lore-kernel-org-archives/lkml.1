Return-Path: <linux-kernel-owner+w=401wt.eu-S1031057AbXDQCxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031057AbXDQCxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 22:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031058AbXDQCxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 22:53:50 -0400
Received: from ozlabs.org ([203.10.76.45]:56449 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031057AbXDQCxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 22:53:50 -0400
Subject: Re: [Patch -mm 3/3] RFC: Introduce kobject->owner for refcounting.
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>
In-Reply-To: <Pine.LNX.4.44L0.0704161539110.2685-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0704161539110.2685-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Tue, 17 Apr 2007 12:53:10 +1000
Message-Id: <1176778391.14322.273.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-16 at 15:53 -0400, Alan Stern wrote:
> The fundamental rule is that whenever you hand out a pointer to a routine
> living in a module, the receiver has to increment the module's refcount.  
> But the driver core violates this rule all over the place.

Hi Alan,

	Your rule is overly simplistic, unfortunately.  You have two choices:
take a reference count, *or* ensure that the reference will go away when
the module's cleanup routine is called.  Network drivers are a classic
example of the latter.

	Note that you cannot do both: if the cleanup routine calls something
which drops a reference count, it implies that the cleanup routine needs
to be called with non-zero reference count, and it won't be (ignoring
--force).

I hope that clarifies?
Rusty.

