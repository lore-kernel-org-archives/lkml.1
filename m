Return-Path: <linux-kernel-owner+w=401wt.eu-S1757352AbZAPHxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352AbZAPHxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 02:53:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760396AbZAPHx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 02:53:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52653 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762863AbZAPHxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 02:53:25 -0500
Date: Thu, 15 Jan 2009 23:53:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: hooanon05@yahoo.co.jp
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       mhalcrow@us.ibm.com, ecryptfs-devel@lists.launchpad.net
Subject: Re: [PATCH] ecryptfs: some inode attrs, and a question
Message-Id: <20090115235318.f728454e.akpm@linux-foundation.org>
In-Reply-To: <9845.1232091751@jrobl>
References: <7471.1231827621@jrobl>
	<20090115150332.f72ad0f8.akpm@linux-foundation.org>
	<9845.1232091751@jrobl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2009 16:42:31 +0900 hooanon05@yahoo.co.jp wrote:

> Andrew Morton:
> > > +	atomic_inc_return(&lower_dentry->d_inode->i_count);
> > > +	atomic_inc_return(&lower_inode->i_count);
> > 
> > atomic_inc() would suffice here, yes?
> 
> I thought that ..._return() is smp safe and necessary here.
> Because lower_inode may be touched by lower fs (outside of ecryptfs).

atomic_inc() is fully atomic too.  atomic_inc_return() is "special",
in that it does an atomic_inc(), but also returns the result of that
increment to the caller.
