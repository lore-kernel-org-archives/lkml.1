Return-Path: <linux-kernel-owner+w=401wt.eu-S1755749AbYGSNN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749AbYGSNN0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 09:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbYGSNNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 09:13:19 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:11241 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbYGSNNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 09:13:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mfMGV49UTfvQhue4YKNiYRsKWnwEbGcC68vP9C6NFYnjXcvBg1siE03pJsr+yGnACq
         2drPyRQyVwTgSgNIM67Wv9zpY0jiqNhwP9bCMP4CXkY1IJP1Vdp16aBCnyVaSGF4iUje
         HQN6g0WHRA5CSbOUsZU9t85e3Gqi65EHmQIA4=
Date: Sat, 19 Jul 2008 17:13:17 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfs: use kstrdup()
Message-ID: <20080719131317.GA7027@asus>
References: <4881BEF4.2020201@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4881BEF4.2020201@cn.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Li Zefan - Sat, Jul 19, 2008 at 06:16:20PM +0800]
| This piece of code can be replaced by a kstrdup().
| 
| Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
| ---
|  fs/namespace.c |    9 +--------
|  1 files changed, 1 insertions(+), 8 deletions(-)
| 
| diff --git a/fs/namespace.c b/fs/namespace.c
| index 4f6f763..08c3b2d 100644
| --- a/fs/namespace.c
| +++ b/fs/namespace.c
| @@ -127,14 +127,7 @@ struct vfsmount *alloc_vfsmnt(const char *name)
|  		INIT_LIST_HEAD(&mnt->mnt_slave_list);
|  		INIT_LIST_HEAD(&mnt->mnt_slave);
|  		atomic_set(&mnt->__mnt_writers, 0);
| -		if (name) {
| -			int size = strlen(name) + 1;
| -			char *newname = kmalloc(size, GFP_KERNEL);
| -			if (newname) {
| -				memcpy(newname, name, size);
| -				mnt->mnt_devname = newname;
| -			}
| -		}
| +		mnt->mnt_devname = kstrdup(name, GFP_KERNEL);
|  	}
|  	return mnt;
|  }
| -- 
| 1.5.4.rc3
| 
| 

but kstrdup may return NULL - is it safe there?
Sorry if that "not smart" question.

		- Cyrill -
