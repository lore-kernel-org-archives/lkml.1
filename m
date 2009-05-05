Return-Path: <linux-kernel-owner+w=401wt.eu-S1758310AbZEEIYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310AbZEEIYK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 04:24:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbZEEIXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 04:23:53 -0400
Received: from verein.lst.de ([213.95.11.210]:56315 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050AbZEEIXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 04:23:52 -0400
Date: Tue, 5 May 2009 10:23:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: xfs-masters@oss.sgi.com,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [xfs-masters] fs/xfs/xfs_mount.c:1483: warning: array subscript is above array bounds
Message-ID: <20090505082344.GA21212@lst.de>
References: <Pine.LNX.4.64.0905051001260.4192@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0905051001260.4192@anakin>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 10:05:05AM +0200, Geert Uytterhoeven wrote:
> 
> http://kisskb.ellerman.id.au/kisskb/buildresult/407608/:
> fs/xfs/xfs_mount.c:1483: warning: array subscript is above array bounds
> 
> xfs_mod_sb(xfs_trans_t *tp, __int64_t fields)
> {
> 	xfs_sb_field_t  f;
> 
> 	...
> 	first = xfs_sb_info[f].offset;
> 	...
> }
> 
> xfs_sb_field_t is an enum with 47 values.
> xfs_sb_info[] has at least 47 entries.

That's the conclusion I came to.   I also see similar bogus warnings in
a couple of other places in a full kernel build (not in xfs).

