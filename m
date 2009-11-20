Return-Path: <linux-kernel-owner+w=401wt.eu-S1752583AbZKTKnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbZKTKnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 05:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbZKTKnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 05:43:47 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40245 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbZKTKnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 05:43:46 -0500
Date: Fri, 20 Nov 2009 05:43:35 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, Jeff Garzik <jeff@garzik.org>,
       "Wu, Fengguang" <fengguang.wu@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] vfs: Add a trace point in the mark_inode_dirty function
Message-ID: <20091120104335.GB29143@infradead.org>
References: <20091025225342.007138f5@infradead.org> <20091111020108.GA11423@localhost> <20091110223456.01ef355f@infradead.org> <4AFA6AEF.5060306@garzik.org> <20091111081905.270a4e55@infradead.org> <y0m3a4kpsiw.fsf@fche.csb> <4AFB4AC7.1090405@intel.com> <20091112072217.GA31719@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091112072217.GA31719@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guys, I think both the inode number and name do have a use case.  For
file system developers observing the filesystem the inode number is very
useful, and if you look at the ext4 tracing already in tree or the xfs
tracing going in in the next window they use the inode number all over.

Which btw brings up another good argument - to make the tracing really
useful we need to have conventions.  While the inode number seems to be
a realtively easy one printing the device is more difficult.  XFS just
prints the raw major/minor to stay simple, ext4 has a complicated ad-hoc
cache of device names, and this one just prints the superblock id
string.

Of course for a user the name is a lot more meaninful, but also
relatively expensive to generate.  Then again I'm not even sure how the
last pathname component only here is all that useful - it can't be used
to easily find the file.

