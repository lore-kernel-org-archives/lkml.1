Return-Path: <linux-kernel-owner+w=401wt.eu-S1751242AbZIHO6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751242AbZIHO6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 10:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbZIHO6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 10:58:31 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:51646 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbZIHO6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 10:58:30 -0400
Date: Tue, 8 Sep 2009 08:58:32 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jamie Lokier <jamie@shareable.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linux Filesystem Mailing List <linux-fsdevel@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>, Mimi Zohar <zohar@us.ibm.com>,
       James Morris <jmorris@namei.org>
Subject: Re: [PATCH 3/8] Simplify exec_permission_lite() further
Message-ID: <20090908145832.GE26346@parisc-linux.org>
References: <alpine.LFD.2.01.0909071337510.3419@localhost.localdomain> <alpine.LFD.2.01.0909071401210.3419@localhost.localdomain> <alpine.LFD.2.01.0909071402220.3419@localhost.localdomain> <alpine.LFD.2.01.0909071402510.3419@localhost.localdomain> <20090908144012.GB5579@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090908144012.GB5579@shareable.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08, 2009 at 03:40:12PM +0100, Jamie Lokier wrote:
> Linus Torvalds wrote:
> > This function is only called for path components that are already known
> > to be directories (they have a '->lookup' method).  So don't bother
> > doing that whole S_ISDIR() testing,
> 
> A few years ago you briefly discussed diddling the VFS to accept
> objects which are both files and directories.  That is, have
> ->lookup() and also can be read as regular files.
> 
> I don't know if your thinking has changed, and I don't particularly
> care, only thought I'd remind in case it's something you'd like to
> support at some point.

If it's being used as a component of a pathname, we're _using_ it as a
directory, so it won't matter for this case.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
