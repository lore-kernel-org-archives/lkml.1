Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbZINVuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbZINVuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 17:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757264AbZINVuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 17:50:14 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:65402 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757260AbZINVuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 17:50:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=q7SvCqf0ZPcbWeVsS10TEaIKMrxQ0r9jOW5+RbgooV2KyViAzESKg4Vi+HaNmFQc6T
         roNyOwmmIqj8hy9Idbe5EZ21PDyu+8ApUybLqHaikCpSfMlYPUL16QpEIXPx0w2t+55o
         yDDNXhy08ge5n+qCvYezoNFMIZdiRkwR0ErAY=
Date: Mon, 14 Sep 2009 23:50:13 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Reiserfs <reiserfs-devel@vger.kernel.org>
Subject: Re: [PATCH 0/4] kill-the-bkl/reiserfs: fix some lock dependency
	inversions
Message-ID: <20090914215011.GM6045@nowhere>
References: <1251167570-5233-1-git-send-email-fweisbec@gmail.com> <20090826201330.GA18761@orion> <20090914203749.GF6045@nowhere> <a4423d670909141433g18659aay6e177b1302e5b4a0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670909141433g18659aay6e177b1302e5b4a0@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 01:33:42AM +0400, Alexander Beregalov wrote:
> > Hi Alexander,
> >
> > It should be fixed now, still in the following tree:
> 
> Hi!
> Another one, similar:
> It is v2.6.31-3123-g99bc470 plus your 805031859(kill-the-bkl/reiserfs:
> panic in case of lock imbalance), UP.
> 
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.31-03149-gdcc030a #1
> -------------------------------------------------------
> udevadm/716 is trying to acquire lock:
>  (&mm->mmap_sem){++++++}, at: [<c107249a>] might_fault+0x4a/0xa0



I hate this mm->mmap_sem....



> 
> but task is already holding lock:
>  (sysfs_mutex){+.+.+.}, at: [<c10cb9aa>] sysfs_readdir+0x5a/0x200
> 
> which lock already depends on the new lock.



This is really weird. This is two externals locks from reiserfs.
I guess I created this dependency somewhere, but how...

Anyway, someone reported a similar bug with this tree some months ago,
I've even met it once but could never be able to reproduce it anymore.

I'll try to find out. Thanks!

