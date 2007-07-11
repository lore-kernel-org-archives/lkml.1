Return-Path: <linux-kernel-owner+w=401wt.eu-S1765255AbXGKPEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765255AbXGKPEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 11:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759723AbXGKPE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 11:04:27 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52448 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758342AbXGKPE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 11:04:27 -0400
Date: Wed, 11 Jul 2007 11:04:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <htejun@gmail.com>
cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Sysfs and suicidal attributes
In-Reply-To: <469464EC.7030502@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0707111100060.4705-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007, Tejun Heo wrote:

> Alright, there's our confusion.  I thought you were gonna use dev->sem
> to protect new device addition && driver binding.  We can use the same
> rwsem directly for binding protection too but I guess there's no big
> difference one way or the other.

The rwsem should not be used for binding protection.  If we did trylock
then binding at the wrong time would fail, which would be bad.  If we
did down_read then we would probably block while holding a device
semaphore, which also would be bad.

> Thanks for enlightening me.  Probably what can be done is blocking
> regular file sysfs nodes automatically and make it optional (optionally
> enable or disable) for bin attrs.

Maybe.  At the moment I don't see any reason to treat binary attributes 
different from text.

It would also be good to find out whether there are any long-running 
sysfs callbacks.

Alan Stern

