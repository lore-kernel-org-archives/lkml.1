Return-Path: <linux-kernel-owner+w=401wt.eu-S932219AbZHCVtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219AbZHCVtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 17:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754796AbZHCVtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 17:49:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60541 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163AbZHCVta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 17:49:30 -0400
Date: Mon, 3 Aug 2009 17:49:30 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ramon de Carvalho Valle <ramon@risesecurity.org>
Cc: linux-kernel@vger.kernel.org, mszeredi@novell.com, hch@lst.de,
       xfs@oss.sgi.com
Subject: Re: [PATCH 1/1] XFS: __xfs_get_blocks check pointer to the target
	device
Message-ID: <20090803214929.GB3167@infradead.org>
References: <1249329808.7686.26.camel@logos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249329808.7686.26.camel@logos>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 05:03:28PM -0300, Ramon de Carvalho Valle wrote:
> The __xfs_get_blocks function does not check if the pointer to the target
> device is valid before dereferencing it.

It should never be zero.  It's set by xfs_imap_to_bmap to either
mp->m_ddev_targp which is always allocated, or to mp->m_rtdev_targp
which is always allocated if we have a realtime device, and
XFS_IS_REALTIME_INODE should only be true in that case.

