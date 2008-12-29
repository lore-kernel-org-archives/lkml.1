Return-Path: <linux-kernel-owner+w=401wt.eu-S1752042AbYL2POZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbYL2POZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 10:14:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbYL2POR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 10:14:17 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59377 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbYL2POQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 10:14:16 -0500
Date: Mon, 29 Dec 2008 16:27:32 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Al Viro <viro@ZenIV.linux.org.uk>, bfields@fieldses.org,
       xfs-masters@oss.sgi.com
Subject: Re: RFC: Fix f_flags races without the BKL
Message-ID: <20081229152732.GH496@one.firstfloor.org>
References: <20081229041352.6bbdf57c@tpl> <20081229124151.GA29634@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081229124151.GA29634@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2008 at 01:41:51PM +0100, Oleg Nesterov wrote:
> On 12/29, Jonathan Corbet wrote:
> >
> > After pondering for a while, I couldn't come up with anything better than a
> > global file->f_flags mutex.  There's no point in bloating struct file with
> > a mutex just for this purpose; it's hard to imagine that there will be any
> > real contention for this lock.
> 
> Yes, this patch is simple and straightforward, but now we can't change
> ->f_flags in non-preempible context. And the global lock is not very
> nice anyway.
> 
> Once again, can't we use O_LOCK_FLAGS bit? I agree, it is a bit ugly,
> and I won't insist if you don't like is.

I would prefer O_LOCK_FLAGS bit too. The global lock is not very nice
and I don't doubt someone will come up with a workload which
pounds on it.

-Andi
-- 
ak@linux.intel.com
