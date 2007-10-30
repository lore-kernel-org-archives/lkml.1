Return-Path: <linux-kernel-owner+w=401wt.eu-S1754344AbXJ3R5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbXJ3R5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 13:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbXJ3R5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 13:57:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41677 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbXJ3R5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 13:57:38 -0400
Date: Tue, 30 Oct 2007 17:57:31 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Christoph Hellwig <hch@infradead.org>, viro@ftp.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/4] VFS: factor out three helpers for FIBMAP/FIONBIO/FIOASYNC file ioctls
Message-ID: <20071030175731.GB17768@infradead.org>
References: <20071030095932.GD22413@infradead.org> <200710301749.l9UHnmRF000734@agora.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710301749.l9UHnmRF000734@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 01:49:48PM -0400, Erez Zadok wrote:
> BTW, what's the origin of this oddity in fs/ioctl.c:
> 
> #ifdef __sparc__
> 	/* SunOS compatibility item. */
> 	if (O_NONBLOCK != O_NDELAY)
> 		flag |= O_NDELAY;
> #endif
> 
> It seems rather odd to have architecture-specific code in the VFS, no?

When Dave did the sparc port he followed sunos ABIs for lots of things.
When these ABIs are hidden behind ioctl arguments they can't easily
be handled in arch code and we need warts like that.  It's definitively
not recommended for new ports..

