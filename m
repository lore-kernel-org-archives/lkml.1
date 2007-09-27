Return-Path: <linux-kernel-owner+w=401wt.eu-S1758788AbXI0VEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788AbXI0VEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 17:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbXI0VE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 17:04:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44912 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbXI0VE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 17:04:28 -0400
Date: Thu, 27 Sep 2007 22:04:23 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Laurent Riffard <laurent.riffard@free.fr>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, reiserfs-devel@vger.kernel.org
Subject: Re: [RFC][PATCH] make reiserfs stop using 'struct file' for internal xattr operations
Message-ID: <20070927210423.GA6117@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dave Hansen <haveblue@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Laurent Riffard <laurent.riffard@free.fr>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	reiserfs-devel@vger.kernel.org
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org> <46FC021F.8060109@free.fr> <20070927124833.d2691813.akpm@linux-foundation.org> <20070927202607.GA3812@infradead.org> <1190926419.7344.27.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190926419.7344.27.camel@localhost>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 01:53:39PM -0700, Dave Hansen wrote:
> -int reiserfs_commit_write(struct file *f, struct page *page,
> -			  unsigned from, unsigned to);
> -int reiserfs_prepare_write(struct file *f, struct page *page,
> -			   unsigned from, unsigned to);
> +int reiserfs_commit_write(struct page *page, unsigned from, unsigned to);
> +int reiserfs_prepare_write(struct page *page, unsigned from, unsigned to);

I doubt this will work.  These are also used for the ->prepare_write
and ->commit_write aops, and the method signature definitively wants
a file there, even if it's zero..

