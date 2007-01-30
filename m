Return-Path: <linux-kernel-owner+w=401wt.eu-S965483AbXA3Jmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965483AbXA3Jmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 04:42:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965478AbXA3Jmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 04:42:36 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40639 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965477AbXA3Jmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 04:42:35 -0500
Date: Tue, 30 Jan 2007 09:42:33 +0000
From: Christoph Hellwig <hch@infradead.org>
To: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH 4/4] fs/unionfs/: Don't duplicate the struct nameidata
Message-ID: <20070130094233.GA6972@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	akpm@osdl.org
References: <11701030631109-git-send-email-jsipek@cs.sunysb.edu> <11701030643398-git-send-email-jsipek@cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11701030643398-git-send-email-jsipek@cs.sunysb.edu>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 03:37:42PM -0500, Josef 'Jeff' Sipek wrote:
> The only fields that we have to watch out for are the dentry and vfsmount.
> Additionally, this makes Unionfs gentler on the stack as nameidata is rather
> large.

That's onviously not true at all.  To handle any filesystems using intents
(e.g. NFSv4) you need to do much more.  Then again doing things correctly
doesn't seem to be interesting to the stackable filesystems crowd an this
problem has been constantly ignored over the last year, including merging
ecryptfs which has been broken in the same way.

Folks, if you want your stackable filesystem toys taken seriously you
need to fix these kind of issues instead of talking them away.  And yes,
this will involve some surgery to the VFS.

