Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbYIVLBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbYIVLBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 07:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbYIVLAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 07:00:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35186 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186AbYIVLAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 07:00:00 -0400
Date: Mon, 22 Sep 2008 06:59:56 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "dm-devel@redhat.com" <dm-devel@redhat.com>,
       "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
       "axboe@kernel.dk" <axboe@kernel.dk>,
       "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/10] VFS: Fix error handling of
	write_super_lockfs/unlockfs
Message-ID: <20080922105956.GA16069@infradead.org>
References: <20080922195526t-sato@mail.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922195526t-sato@mail.jp.nec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 07:55:26PM +0900, Takashi Sato wrote:
> I've changed the type of write_super_lockfs and unlockfs from "void" to
> "int" so that they can return an error. 

Returning an error from the freeze operation makes sense, but for the
unfreeze I don't see the point.  You must however change all existing
instances to actually return a value (even if it's always 0 for now)
to avoid breaking git bisect.

If you touch all instances anyway, it would be nice to rename them
to freeze / unfreze as the current names are more confusing.

