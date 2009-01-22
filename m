Return-Path: <linux-kernel-owner+w=401wt.eu-S1757568AbZAVGMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbZAVGMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 01:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755187AbZAVGMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 01:12:05 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40197 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766AbZAVGME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 01:12:04 -0500
Date: Thu, 22 Jan 2009 01:11:58 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>, Eric Sesterhenn <snakebyte@gmx.de>,
       Pavel Machek <pavel@suse.cz>, Chris Mason <chris.mason@oracle.com>,
       linux-kernel@vger.kernel.org, npiggin@yahoo.com.au, xfs@oss.sgi.com
Subject: Re: [PATCH] Re: Corrupted XFS log replay oops.
Message-ID: <20090122061158.GA31104@infradead.org>
References: <20090113142147.GE16333@alice> <20090120173455.GC21339@alice> <20090121035703.GH10158@disturbed> <200901211503.07308.nickpiggin@yahoo.com.au> <20090122043747.GU10158@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090122043747.GU10158@disturbed>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 03:37:47PM +1100, Dave Chinner wrote:
>  xfs_buf_t *
>  xlog_get_bp(
>  	xlog_t		*log,
> -	int		num_bblks)
> +	int		nbblks)

Any reason for reanming this variable?  That causes quite a bit of
churn.

>  {
> -	ASSERT(num_bblks > 0);
> +	if (nbblks <= 0 || nbblks > log->l_logBBsize) {
> +		xlog_warn("XFS: Invalid block length (0x%x) given for buffer", nbblks);

And doesn't prevent this line from needing a linebreak to stay under 80
characters :)

Except for these nitpicks it looks fine to me.
