Return-Path: <linux-kernel-owner+w=401wt.eu-S1755867AbYLJVNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbYLJVNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 16:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755142AbYLJVNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 16:13:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43412 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754795AbYLJVNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 16:13:25 -0500
Date: Wed, 10 Dec 2008 13:13:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: kosaki.motohiro@jp.fujitsu.com, sfr@canb.auug.org.au,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [bug?] bio: add experimental support for inlining a number of
 bio_vecs inside the bio
Message-Id: <20081210131311.e03d6fc5.akpm@linux-foundation.org>
In-Reply-To: <20081210121237.GQ23742@kernel.dk>
References: <20081210164659.9ebb8158.sfr@canb.auug.org.au>
	<20081210183059.4FD6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20081210204630.4FE3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20081210121237.GQ23742@kernel.dk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2008 13:12:38 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:

> > experimental??
> 
> Experimental in the sense that it's the first version, not the concept.
> It's held up well for me, but just yesterday I received the first bug
> report on a ppc platform and now you have this on ia64.


Well there's another bug report up-list.  "next-20081209: pdflush: page
allocation failure (xfs)".

The clearing of (__GFP_WAIT | __GFP_IO) will call the page allocator in the
weakest possible mode and will of course spew page allocations warnings
with great frequency.  It should at least add in __GFP_NOWARN.
