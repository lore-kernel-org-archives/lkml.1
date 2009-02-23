Return-Path: <linux-kernel-owner+w=401wt.eu-S1756740AbZBWTne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbZBWTne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 14:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbZBWTnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 14:43:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34757 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754950AbZBWTnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 14:43:24 -0500
Date: Mon, 23 Feb 2009 11:42:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: nickpiggin@yahoo.com.au, penberg@cs.helsinki.fi, mpm@selenic.com,
       kosaki.motohiro@jp.fujitsu.com, david.vrabel@csr.com,
       hannes@cmpxchg.org, chas@cmf.nrl.navy.mil, johnpol@2ka.mipt.ru,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, npiggin@suse.de
Subject: Re: [patch 1/7] slab: introduce kzfree()
Message-Id: <20090223114200.3d14cc3b.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0902231429360.28573@blonde.anvils>
References: <499BE7F8.80901@csr.com>
	<499DB6EC.3020904@cs.helsinki.fi>
	<Pine.LNX.4.64.0902192022210.8254@blonde.anvils>
	<200902240101.26362.nickpiggin@yahoo.com.au>
	<Pine.LNX.4.64.0902231429360.28573@blonde.anvils>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Feb 2009 14:51:05 +0000 (GMT)
Hugh Dickins <hugh@veritas.com> wrote:

> On Tue, 24 Feb 2009, Nick Piggin wrote:
> > 
> > Well, the buffer is only non-modified in the case of one of the
> > allocators (SLAB). All others overwrite some of the data region
> > with their own metadata.
> > 
> > I think it is OK to use const, though. Because k(z)free has the
> > knowledge that the data will not be touched by the caller any
> > longer.
> 
> Sorry, you're not adding anything new to the thread here.
> 
> Yes, the caller is surrendering the buffer, so we can get
> away with calling the argument const; and Linus argues that's
> helpful in the case of kfree (to allow passing a const pointer
> without having to cast it).
> 
> My contention is that kzfree(const void *ptr) is nonsensical
> because it says please zero this buffer without modifying it.

yup.  The intent of kzfree() is explicitly, overtly, deliberately to
modify the passed memory before freeing it.  Marking it const is dopey.

But the const marker is potentially useful to some caller.  An arguably
misdesigned caller.

> But the change has gone in, I seem to be the only one still
> bothered by it, and I've conceded that the "z" might stand
> for zap rather than zero.

Yeah.  But it's a very small bother.

