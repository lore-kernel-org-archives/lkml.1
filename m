Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460AbYK0IUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbYK0IUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 03:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbYK0IUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 03:20:17 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38420
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752474AbYK0IUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 03:20:15 -0500
Date: Thu, 27 Nov 2008 00:20:15 -0800 (PST)
Message-Id: <20081127.002015.221466656.davem@davemloft.net>
To: dada1@cosmosbay.com
Cc: mingo@elte.hu, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, efault@gmx.de, a.p.zijlstra@chello.nl,
       netdev@vger.kernel.org, cl@linux-foundation.org, hch@infradead.org
Subject: Re: [PATCH 2/6] fs: Introduce special dentries for pipes, socket,
 anon fd
From: David Miller <davem@davemloft.net>
In-Reply-To: <492DDC5C.1050602@cosmosbay.com>
References: <492DDC5C.1050602@cosmosbay.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Thu, 27 Nov 2008 00:31:40 +0100

> Sockets, pipes and anonymous fds have interesting properties.
 ...
> This patch defines a new DCACHE_SPECIAL flag, to mark a dentry as
> a special one (for sockets, pipes, anonymous fd), and a new
> d_alloc_special(const struct qstr *name, struct inode *inode)
> method, called by the three subsystems.
> 
> Internally, dput() can take a fast path to dput_special() for
> special dentries, avoiding an expensive atomic_dec_and_lock()
> 
> Differences betwen a special dentry and a normal one are :
> 
> 1) Special dentry has the DCACHE_SPECIAL flag
> 2) Special dentry's parent are themselves.
>    This to avoid taking a reference on 'root' dentry, shared
>    by too many dentries.
> 3) They are not hashed into global hash table
> 4) Their d_alias list is empty
> 
> (socket8 bench result : from 27.5s to 24s)
> 
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

Networking bits look fine:

Acked-by: David S. Miller <davem@davemloft.net>
