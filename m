Return-Path: <linux-kernel-owner+w=401wt.eu-S1756243AbZKQWLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbZKQWLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:11:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756224AbZKQWLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:11:53 -0500
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:49150 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755122AbZKQWLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:11:11 -0500
Date: Wed, 18 Nov 2009 09:11:08 +1100
From: Dave Chinner <david@fromorbit.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       xfs-masters@oss.sgi.com, xfs@oss.sgi.com
Subject: Re: [PATCH 7/7] xfs: Don't use PF_MEMALLOC
Message-ID: <20091117221108.GK9467@discord.disaster>
References: <20091117161551.3DD4.A69D9226@jp.fujitsu.com> <20091117162235.3DEB.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091117162235.3DEB.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 04:23:43PM +0900, KOSAKI Motohiro wrote:
> 
> Non MM subsystem must not use PF_MEMALLOC. Memory reclaim need few
> memory, anyone must not prevent it. Otherwise the system cause
> mysterious hang-up and/or OOM Killer invokation.

The xfsbufd is a woken run by a registered memory shaker. i.e. it
runs when the system needs to reclaim memory. It forceѕ the
delayed write metadata buffers (of which there can be a lot) to disk
so that they can be reclaimed on IO completion. This IO submission
may require ѕome memory to be allocated to be able to free that
memory.

Hence, AFAICT the use of PF_MEMALLOC is valid here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
