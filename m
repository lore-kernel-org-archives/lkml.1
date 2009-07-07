Return-Path: <linux-kernel-owner+w=401wt.eu-S1755106AbZGGTGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106AbZGGTGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 15:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbZGGTGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 15:06:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56713 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268AbZGGTGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 15:06:45 -0400
Date: Tue, 7 Jul 2009 15:06:43 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Paul Smith <paul@mad-scientist.net>
Cc: Linux XFS <linux-xfs@oss.sgi.com>, christoph hellwig <hch@ifradead.org>,
       david chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.27.25] assfail in xfs_attr_quiesce() during umount
Message-ID: <20090707190643.GA32467@infradead.org>
References: <MAIL10OSN4RHlLx5ERz0002f238@mail1.netezza.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MAIL10OSN4RHlLx5ERz0002f238@mail1.netezza.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 02:42:16PM -0400, Paul Smith wrote:
> According to the thread for the former, it was intended to be resolved
> by "proper per-vfsmount write count in 2.6.25 as part of the per-mount
> r/o patches" (C.Hellwig)
> 
> Did those fixes indeed go into 2.6.25 (or 2.6.27 or below)?  Was there
> something else that needed to be done for XFS to be able take advantage
> of that enhancement?

We haven't fixed the VFS issues yet.  In some later kernel we just
changed the assert to a warn on for now until the issue is sorted out.

> And, is the patch posted by DavidC here:
> http://marc.info/?l=linux-kernel&m=120106649923499&w=2

It looks somehwat dangerous for me.  For now I would just comment
out the assert or change it to a WARN_ON as in the newer kernels.

I've recently started looking at that area in the VFS again and I'll
hopefully make progress on a solution that sets MS_RDONLY at the
correct time.

