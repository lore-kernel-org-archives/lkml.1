Return-Path: <linux-kernel-owner+w=401wt.eu-S1762221AbZCQMXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762221AbZCQMXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 08:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777AbZCQMXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 08:23:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512AbZCQMXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 08:23:32 -0400
Date: Tue, 17 Mar 2009 08:23:28 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] deadlock when swapping to FAT
In-Reply-To: <878wn7h3la.fsf@devron.myhome.or.jp>
Message-ID: <Pine.LNX.4.64.0903170815110.26754@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0903120819010.26206@hs20-bc2-1.build.redhat.com>
 <87zlfqohfn.fsf@devron.myhome.or.jp> <Pine.LNX.4.64.0903142153330.23664@hs20-bc2-1.build.redhat.com>
 <878wn7h3la.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Mar 2009, OGAWA Hirofumi wrote:

> Mikulas Patocka <mpatocka@redhat.com> writes:
> 
> > Note that the same race condition is happening in all the other 
> > filesystems. Maybe move that i_alloc_sem up to ->bmap method caller?
> 
> It can be. However, I guess locking strategy would be per
> filesystems. Because the fs may be using i_alloc_sem in get_block
> already.

Which ones take it in get_block? I grepped for i_alloc_sem and don't see 
them. Besides, it is mostly taken only for read and recursive taking of 
read-lock for read is allowed. It is taken for writes only in truncate.

Mikulas

> Thanks.
> -- 
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> 
