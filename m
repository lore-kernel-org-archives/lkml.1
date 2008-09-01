Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbYIAPCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbYIAPCN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 11:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbYIAPBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 11:01:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49678 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531AbYIAPBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 11:01:50 -0400
Date: Mon, 1 Sep 2008 11:01:47 -0400
From: Christoph Hellwig <hch@infradead.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: Re: [PATCH] UBIFS: fill f_fsid
Message-ID: <20080901150147.GA20323@infradead.org>
References: <1220194366-12731-1-git-send-email-dedekind@infradead.org> <1220194366-12731-13-git-send-email-dedekind@infradead.org> <1220262187.2982.58.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220262187.2982.58.camel@pmac.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2008 at 10:43:07AM +0100, David Woodhouse wrote:
> On Sun, 2008-08-31 at 17:52 +0300, Artem Bityutskiy wrote:
> > From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> > 
> > UBIFS stores 16-bit UUID in the superblock, and it is a good
> > idea to return part of it in 'f_fsid' filed of kstatfs structure.
> 
> I think you mean a 16-byte UUID, not 16-bit?
> 
> > +	memcpy(&buf->f_fsid, c->uuid, sizeof(__kernel_fsid_t));
> 
> For btrfs I xor the first 64 bits with the second 64 bits, and put
> _that_ into f_fsid. You're just putting the first 64 bits in and
> ignoring the second 64 bits. Neither is really _better_ than the other;
> you just alter the circumstances in which you get collisions. But I
> suppose we might as well be consistent about how we do it?

XFS just puts in the st_dev.  And I can't realy find any useful
defintion of what it's supposed to b anyway..

