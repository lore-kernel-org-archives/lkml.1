Return-Path: <linux-kernel-owner+w=401wt.eu-S1763387AbZDAMUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763387AbZDAMUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 08:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762910AbZDAMT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 08:19:58 -0400
Received: from sh.osrg.net ([192.16.179.4]:55974 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762095AbZDAMT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 08:19:57 -0400
Date: Wed, 1 Apr 2009 21:18:43 +0900
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, tj@kernel.org, bharrosh@panasas.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] block: fix SG_IO vector request data length
	handling
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090401115058.GD5178@kernel.dk>
References: <1238583884-13517-3-git-send-email-tj@kernel.org>
	<20090401204716N.fujita.tomonori@lab.ntt.co.jp>
	<20090401115058.GD5178@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090401211851Y.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 01 Apr 2009 21:18:45 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Apr 2009 13:50:58 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Wed, Apr 01 2009, FUJITA Tomonori wrote:
> > On Wed,  1 Apr 2009 20:04:38 +0900
> > Tejun Heo <tj@kernel.org> wrote:
> > 
> > > Impact: fix SG_IO behavior such that it matches the documentation
> > > 
> > > SG_IO howto says that if ->dxfer_len and sum of iovec disagress, the
> > > shorter one wins.  However, the current implementation returns -EINVAL
> > > for such cases.  Trim iovc if it's longer than ->dxfer_len.
> > 
> > Is that description about sg's SG_IO?
> 
> The more important question is what sg.c actually does, that's more
> important than the documentation.

Do you think that Doug is a person who makes such mistake? ;)

Seems that sg worked as the howto says. But I think that I broke it
when I converted sg to use the block layer. I'll fix it soon.

About this patch, as we know, there are lots of subtle differences
between sg's SG_IO and the block's. I'm not sure that it's a good idea
to change the behavior of the block's SG_IO.
