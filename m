Return-Path: <linux-kernel-owner+w=401wt.eu-S1758039AbYEWKAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039AbYEWKAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 06:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756840AbYEWKAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 06:00:34 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46760 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756917AbYEWKA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 06:00:29 -0400
To: hch@infradead.org
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       swhiteho@redhat.com
In-reply-to: <E1JzTsy-0001b8-Cr@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Fri, 23 May 2008 11:48:28 +0200)
Subject: Re: [patch 04/14] gfs2: dont call permission()
References: <20080521171458.077908538@szeredi.hu> <20080521171546.697638614@szeredi.hu> <20080523091805.GB27119@infradead.org> <E1JzTsy-0001b8-Cr@pomaz-ex.szeredi.hu>
Message-Id: <E1JzU4Y-0001dS-3H@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 23 May 2008 12:00:26 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Generally this sort of recursion through the VFS is ugly and
> unnecessary, it's much better to provide helper for what the VFS is
> doing if there's a lot of duplication.  But in this case there's
> really no point in that at all.

And that's true of lookup_one_len() as well, the last bit of horror
left in this permission() saga.  It's called from lots of places,
often for doing things it's not at all meant to do (e.g. where caller
_knows_ it will return negative, etc...).  One day maybe I'll have
strength to clean that up as well..., but not now.

Miklos
