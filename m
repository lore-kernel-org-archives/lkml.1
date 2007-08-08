Return-Path: <linux-kernel-owner+w=401wt.eu-S935564AbXHHTgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935564AbXHHTgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 15:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762883AbXHHTgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 15:36:38 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40478 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761188AbXHHTgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 15:36:37 -0400
Date: Wed, 8 Aug 2007 20:36:36 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: linux-kernel@vger.kernel.org, John Johansen <jjohansen@suse.de>,
       Jan Blunck <jblunck@suse.de>, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: Re: [RFC 08/10] Pass no NULL vfs_lookup to vfs_create
Message-ID: <20070808193636.GB31354@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andreas Gruenbacher <agruen@suse.de>, linux-kernel@vger.kernel.org,
	John Johansen <jjohansen@suse.de>, Jan Blunck <jblunck@suse.de>,
	Erez Zadok <ezk@cs.sunysb.edu>,
	Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
References: <20070808171622.632749741@suse.de> <20070808171644.407320917@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070808171644.407320917@suse.de>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2007 at 07:16:30PM +0200, Andreas Gruenbacher wrote:
> Never pass a NULL vfs_lookup to vfs_create() or iop->create by creating
> temporary vfs_lookup objects where needed. Remove the obsolete NULL
> checks.

ipc/mqueue.c should be rewritten to use vfs_path_lookup instead.

nfsd is special - people need to deal with the !nameidata or !intent
case anyway because the fs/exportfs/expfs.c code uses lookup_one_len
all over when the filesystem is mared nfs exportable, but fortunately
the filesystem that are nfs exportable are usually not those using
intents.  We might eventually fix this one day by having some kind
open by handle intent, but that should come as part of a large
patch series where we qualify the type of lookup for every single
lookup.
