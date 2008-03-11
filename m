Return-Path: <linux-kernel-owner+w=401wt.eu-S1756361AbYCKMt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361AbYCKMt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 08:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbYCKMtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 08:49:47 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:48194 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbYCKMtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 08:49:46 -0400
Date: Tue, 11 Mar 2008 18:19:35 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Roland McGrath <roland@redhat.com>
Cc: libc-alpha@sourceware.org, Jan Blunck <jblunck@suse.de>,
       Erez Zadok <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       Christoph Hellwig <hch@lst.de>, Ulrich Drepper <drepper@redhat.com>,
       Mingming Cao <cmm@us.ibm.com>, Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [RFC] Union mount readdir support in glibc
Message-ID: <20080311124935.GA9121@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20080311055527.GA7256@in.ibm.com> <20080311080929.B076D26F991@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080311080929.B076D26F991@magilla.localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 01:09:29AM -0700, Roland McGrath wrote:
> It seems very unlikely you'd come up with a version of this plan that we'd
> find acceptable in glibc.  readdir does buffering, sometimes entry format
> conversion, and it can skip dummy entries.  That's it.  It's not going to
> become a big hairy thing with all kinds of new state.  Sorry.

In the approach we are suggesting, at the minimum, glibc readdir would
have to maintain a unified cache of dirents with the knowlege of
whiteouts (DT_WHT). Would that be too much ?

> 
> This really is the kernel filesystem's problem.  It just doesn't make sense
> to expect userland to implement half of your directory semantics for you.
> What are you going to do when you want to export a union directory to NFS?
> readdir is a filesystem operation.  You're implementing a filesystem.

Not really. In Union Mount, most of the unification support is done at
VFS layer with some support from filesystems (for things like
whiteouts). It is Unionfs which implements a new filesystem to achieve
unification. Unification is not purely a kernel filesystem's problem, it
involves both VFS and FS.

> 
> Exposing DT_WHT entries may be useful as a user feature.  (BSD had unions
> with whiteouts years ago, and their ls et al have options to let you see
> and operate on whiteouts explicitly so users can make sense of strange
> situations with unions.)  But even for that, we'd have to consider the
> compatibility issues.

AFAIK, even BSD implements duplicate elimination and whiteout
suppression in the userland.

Thanks for your comments.

Regards,
Bharata.
