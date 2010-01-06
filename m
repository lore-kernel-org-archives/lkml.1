Return-Path: <linux-kernel-owner+w=401wt.eu-S932489Ab0AFRgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab0AFRgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 12:36:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932408Ab0AFRgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 12:36:31 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58991 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932407Ab0AFRga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 12:36:30 -0500
Date: Wed, 6 Jan 2010 12:36:29 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: lockdep: inconsistent lock state
Message-ID: <20100106173628.GA14148@infradead.org>
References: <alpine.DEB.2.01.0912261255380.3483@bogon.housecafe.de> <20091227212700.GA7613@discord.disaster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091227212700.GA7613@discord.disaster>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 28, 2009 at 08:27:00AM +1100, Dave Chinner wrote:
> This is the usual false positive that is detected - XFS takes locks in
> reclaim that it also takes in non-reclaim paths. The reclaim path
> from kswapd inverts lock ordering and so we get this report. This
> case has never been a deadlock case because an inode in reclaim
> cannot be referenced by any other path, so once again it is a
> false positive....

This should be gone in 2.6.33-rc as we now tell lockdep about resetting
the dependency graph for the iolock once entering the inode reclaim path.
