Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbYK0IVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbYK0IVA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 03:21:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbYK0IUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 03:20:47 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38429
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752548AbYK0IUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 03:20:46 -0500
Date: Thu, 27 Nov 2008 00:20:46 -0800 (PST)
Message-Id: <20081127.002046.25550570.davem@davemloft.net>
To: dada1@cosmosbay.com
Cc: mingo@elte.hu, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, efault@gmx.de, a.p.zijlstra@chello.nl,
       netdev@vger.kernel.org, cl@linux-foundation.org, hch@infradead.org
Subject: Re: [PATCH 5/6] fs: Introduce special inodes
From: David Miller <davem@davemloft.net>
In-Reply-To: <492DDC99.5060106@cosmosbay.com>
References: <4926D39D.9050603@cosmosbay.com>
	<20081121153453.GA23713@elte.hu>
	<492DDC99.5060106@cosmosbay.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Thu, 27 Nov 2008 00:32:41 +0100

> Goal of this patch is to not touch inode_lock for socket/pipes/anonfd
>  inodes allocation/freeing.
> 
>  In new_inode(), we test if super block has MS_SPECIAL flag set.
>  If yes, we dont put inode in "inode_in_use" list nor "sb->s_inodes" list
>  As inode_lock was taken only to protect these lists, we avoid it as well
> 
>  Using iput_special() from dput_special() avoids taking inode_lock
>  at freeing time.
> 
>  This patch has a very noticeable effect, because we avoid dirtying of three contended cache lines in new_inode(), and five cache lines
>  in iput()
> 
> Note: Not sure if we can use MS_SPECIAL=MS_NOUSER, or if we
> really need a different flag.
> 
> (socket8 bench result : from 20.5s to 2.94s) 
> 
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

No problem with networking part:

Acked-by: David S. Miller <davem@davemloft.net>
