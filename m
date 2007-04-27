Return-Path: <linux-kernel-owner+w=401wt.eu-S1755551AbXD0KML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbXD0KML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 06:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755553AbXD0KML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 06:12:11 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:56420 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551AbXD0KMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 06:12:10 -0400
Date: Fri, 27 Apr 2007 13:12:08 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Oliver Neukum <oliver@neukum.org>
cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
In-Reply-To: <200704271150.55701.oliver@neukum.org>
Message-ID: <Pine.LNX.4.64.0704271303260.925@sbz-30.cs.Helsinki.FI>
References: <1177567481.5025.211.camel@nigel.suspend2.net>
 <1177654110.4737.91.camel@nigel.suspend2.net>
 <Pine.LNX.4.64.0704270910190.18521@sbz-30.cs.Helsinki.FI>
 <200704271150.55701.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 27. April 2007 08:18 schrieb Pekka J Enberg:
> > No. The snapshot is just that. A snapshot in time. From kernel point of 
> > view, it doesn't matter one bit what when you did it or if the state has 
> > changed before you resume. It's up to userspace to make sure the user 
> > doesn't do real work while the snapshot is being written to disk and 
> > machine is shut down.

On Fri, 27 Apr 2007, Oliver Neukum wrote:
> And where is the benefit in that? How is such user space freezing logic
> simpler than having the kernel do the write?
>
> What can you do in user space if all filesystems are r/o that is worth the
> hassle?

I am talking about snapshot_system() here. It's not given that the 
filesystems need to be read-only (you can snapshot them too). The benefit 
here is that you can do whatever you want with the snapshot (encrypt, 
compress, send over the network)  and have a clean well-defined interface 
in the kernel. In addition, aborting the snapshot is simpler, simply 
munmap() the snapshot.

The problem with writing in the kernel is obvious: we need to add new code 
to the kernel for compression, encryption, and userspace interaction 
(graphical progress bar) that are important for user experience.

				Pekka
