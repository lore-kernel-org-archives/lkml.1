Return-Path: <linux-kernel-owner+w=401wt.eu-S1753678AbYABHu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbYABHu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 02:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbYABHuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 02:50:50 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52416 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbYABHut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 02:50:49 -0500
Date: Wed, 2 Jan 2008 07:50:33 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Mike Frysinger <vapier@gentoo.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] linux/ufs_fs.h: use __u64 for userspace
Message-ID: <20080102075033.GA16267@infradead.org>
References: <200801012051.41474.vapier@gentoo.org> <20080102020242.GP27566@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080102020242.GP27566@does.not.exist>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 04:02:42AM +0200, Adrian Bunk wrote:
> But userspace anyway can't use them since it doesn't know what "uspi" 
> is, so you should better reduce the userspace visibility of this header.

We had this come up before and the header should not be exported to
userspace at all.  It documents the ufs ondisk structures which are

  a) not a user/kernel interface
  b) may change frequently due to addition of another ufs subvariant.

The only non-kernel user of this known to me is silo, which should just
have it's own header documenting the solaris sparc ufs variant it needs
to understand, possibly by using a copy of the kernel version at any
given point of time.

