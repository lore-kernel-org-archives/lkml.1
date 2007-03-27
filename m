Return-Path: <linux-kernel-owner+w=401wt.eu-S1751782AbXC0GcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbXC0GcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 02:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbXC0GcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 02:32:10 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43629 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbXC0GcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 02:32:08 -0400
Date: Tue, 27 Mar 2007 09:32:05 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Phillip Susi <psusi@cfl.rr.com>
cc: Mike Snitzer <snitzer@gmail.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: forced umount?
In-Reply-To: <46083C79.1080108@cfl.rr.com>
Message-ID: <Pine.LNX.4.64.0703270929030.31885@sbz-30.cs.Helsinki.FI>
References: <170fa0d20703162106v47dc13e1u1ae5381576f372ed@mail.gmail.com> 
 <45FB6E32.3050009@goop.org>  <170fa0d20703162237m1023cbd2o8ccf9e464c53f4a0@mail.gmail.com>
 <84144f020703170353y4490d0dcr24352c291c96300b@mail.gmail.com>
 <46083C79.1080108@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2007, Phillip Susi wrote:
> Is this revoke system supported for the filesystem as a whole?  I thought it
> was just to force specific files closed, not the whole filesystem.  What if
> the filesystem itself has pending IO to say, update inodes or block bitmaps?
> Can these be aborted?

We never want to _abort_ pending updates only pending reads. So, even with 
revoke(), we need to be careful which is why we do do_fsync() in 
generic_revoke_file() to make sure pending updates are flushed before we 
declare the inode revoked.

But, I haven't looked at forced unmount that much so there may be other 
issues I am not aware of.

			Pekka
