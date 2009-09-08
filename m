Return-Path: <linux-kernel-owner+w=401wt.eu-S1752455AbZIHSeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbZIHSeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 14:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbZIHSea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 14:34:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45278 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbZIHSe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 14:34:29 -0400
Date: Tue, 8 Sep 2009 14:34:31 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linux Filesystem Mailing List <linux-fsdevel@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>, Mimi Zohar <zohar@us.ibm.com>,
       James Morris <jmorris@namei.org>
Subject: Re: [PATCH 8/8] jffs2/jfs/xfs: switch over to 'check_acl' rather
	than 'permission()'
Message-ID: <20090908183431.GA22314@infradead.org>
References: <alpine.LFD.2.01.0909071337510.3419@localhost.localdomain> <alpine.LFD.2.01.0909071401210.3419@localhost.localdomain> <alpine.LFD.2.01.0909071402220.3419@localhost.localdomain> <alpine.LFD.2.01.0909071402510.3419@localhost.localdomain> <alpine.LFD.2.01.0909071403110.3419@localhost.localdomain> <alpine.LFD.2.01.0909071403390.3419@localhost.localdomain> <alpine.LFD.2.01.0909071404090.3419@localhost.localdomain> <alpine.LFD.2.01.0909071404370.3419@localhost.localdomain> <alpine.LFD.2.01.0909071405070.3419@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0909071405070.3419@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The split of these patches is a bit odd, either do all in one patch or
one patch per filesystem instead of those groups.

That beeing said if we go down this way I would prefer if we go
down all the way, that is convert the remaining few filesystems that
pass a check_acl argument to generic_permission (btrfs, gfs2, ocfs2)
and just kill off that argument.

After that there is another step we can easily go:  as we now cache the
ACLs in the generic inode instead of the per-fs one we can move the
get_cached_acl call to your acl_permission_check helper (for gfs2/ocfs2
that don't cache ACLs it will always fail), and not call out to the fs
for the fast path at all.

