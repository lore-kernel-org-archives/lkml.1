Return-Path: <linux-kernel-owner+w=401wt.eu-S1753399AbYHaOyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbYHaOyA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 10:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbYHaOxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 10:53:47 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:38072 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbYHaOxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 10:53:46 -0400
Message-ID: <48BAAFB0.8060304@cs.helsinki.fi>
Date: Sun, 31 Aug 2008 17:50:24 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>, mpm@selenic.com,
       Dave Chinner <david@fromorbit.com>
Subject: Re: [patch 1/3] dentries: Always use list_del_init() when removing
 a dentry from the lru
References: <20080825212035.861870487@quilx.com> <20080825212053.255444022@quilx.com>
In-Reply-To: <20080825212053.255444022@quilx.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> The patch restores what commit 4a0962abd187df29b7d1378b2f372a55667d54c0
> already implemented. The feature was subsequently clobbered by
> commit da3bbdd4632c0171406b2677e31494afa5bde2f8
> 
> Before this patch some execution path use list_del() instead of
> list_del_init() which results in inconsitencies in the state of d_lru
> when the object is freed.
> 
> The performance of list_del_init() and list_del() is the same.
> So lets just have one dentry removal function named dentry_lru_del() that always
> does a list_del_init().
> 
> The result of this patch is that dentry->d_lru is now always empty when a
> dentry is freed. The dentry defragmentation patch depends on a defined state
> of a dentry on free.
> 
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

Applied, thanks!
