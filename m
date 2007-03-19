Return-Path: <linux-kernel-owner+w=401wt.eu-S1753417AbXCSJ2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbXCSJ2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 05:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbXCSJ2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 05:28:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48209 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbXCSJ2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 05:28:30 -0400
Date: Mon, 19 Mar 2007 09:28:28 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Dmitriy Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-ntfs-dev@lists.sourceforge.net, xfs@oss.sgi.com, devel@openvz.org
Subject: Re: [PATCH 1/2] fs: remove duplicated iovec checking code v8
Message-ID: <20070319092828.GA3364@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dmitriy Monakhov <dmonakhov@openvz.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ntfs-dev@lists.sourceforge.net, xfs@oss.sgi.com,
	devel@openvz.org
References: <87slc18yhe.fsf@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87slc18yhe.fsf@sw.ru>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 10:49:01AM +0300, Dmitriy Monakhov wrote:
> 
> Where are several places where the same code used for iovec checks.
> This patch just move this code to separate helper function, and replace
> duplicated code with it. IMHO it is better because these are checks that
> we want for all filesystems/drivers that use vectored I/O.

Please move this into the common code path, so it's checked before
entering the filesystem.  This won't cover the calculating count
until we have an iodesc/uio strcuture to pass it down, so feel free
to add a tiny helper for that temporaily.

