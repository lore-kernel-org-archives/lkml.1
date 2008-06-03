Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbYFCKf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbYFCKf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 06:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbYFCKft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 06:35:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46530 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbYFCKfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 06:35:48 -0400
Date: Tue, 3 Jun 2008 11:35:43 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jesper Krogh <jesper@krogh.cc>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: Linux 2.6.26-rc4
Message-ID: <20080603103543.GS28946@ZenIV.linux.org.uk>
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org> <47107.195.41.66.226.1212486572.squirrel@mail.jabbernet.dk> <20080603095713.GR28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080603095713.GR28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2008 at 10:57:13AM +0100, Al Viro wrote:
> On Tue, Jun 03, 2008 at 11:49:32AM +0200, Jesper Krogh wrote:
> 
> > I reported it to the NFS-guys on a .22 kernel, and was directed to the
> > fsdevel list(CC'ed again) back then. Now the problem is reproduces on
> > .26-rc4
> 
> Lovely...  Do you have the full oops trace, with the actual code
> dump?

FWIW, searching for graft_tree on arjan's site:
#12419:
	negative dentry path->dentry
#17367:
	ditto
#17463:
	ditto
#13042:
	probably the same (is that earlier oops you've mentioned?)
#18932:
	WTF is that one doing there?  (graft_tree is never mentioned in it)

Nuts...  I really don't see how that could happen, unless it's NFS
revalidation playing silly buggers with dentries and ->d_revalidate()
there ends up turning dentry passed to it into negative one...

Where does the mountpoint in question live and what gets passed to
sys_mount()?
