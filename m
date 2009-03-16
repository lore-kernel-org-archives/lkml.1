Return-Path: <linux-kernel-owner+w=401wt.eu-S1757503AbZCPRFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbZCPRFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 13:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbZCPRFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 13:05:34 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:47088 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbZCPRFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 13:05:33 -0400
Date: Mon, 16 Mar 2009 12:05:20 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Igor Zhbanov <izh1979@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, neilb@suse.de,
       Trond.Myklebust@netapp.com, David Howells <dhowells@redhat.com>,
       James Morris <jmorris@namei.org>
Subject: Re: VFS, NFS security bug? Should CAP_MKNOD and
	CAP_LINUX_IMMUTABLE be added to CAP_FS_MASK?
Message-ID: <20090316170520.GB2996@us.ibm.com>
References: <f44001920903110553t52ce0ba7l4ba97213e1c51873@mail.gmail.com> <20090311232356.GP13540@fieldses.org> <20090312161047.GA15209@us.ibm.com> <517f3f820903121321sf6d2014q8165b925d5d44db7@mail.gmail.com> <20090313175848.GB27891@fieldses.org> <cfd18e0f0903141220u66230ceer22ef0cc6aed1d046@mail.gmail.com> <f44001920903160716i488e3642o869f626a5c3327d0@mail.gmail.com> <20090316163611.GB10959@fieldses.org> <20090316164612.GC10959@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090316164612.GC10959@fieldses.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting J. Bruce Fields (bfields@fieldses.org):
> On Mon, Mar 16, 2009 at 12:36:11PM -0400, bfields wrote:
> > That may be reasonable, but I'd like to see clearer criteria for
> > choosing those.  Some considerations:
> > 
> > 	1. As capabilities(7) says, we must "preserve the traditional
> > 	   semantics for transitions between 0 and non-zero user IDs".
> > 	   The setfsuid() interface predates capabilities, so the
> > 	   introduction of capabilities shouldn't have changed the
> > 	   behavior of a program written in ignorance of capabilities.
> > 	2. Users of the interface (like nfsd!) would be less likely to
> > 	   make mistakes if we had a simpler, more conceptual
> > 	   description of CAP_FS_MASK than just "the following list of
> > 	   capabilities".
> > 	3. If there's a possibility new capabilities will be added again
> > 	   in the future, then we should document CAP_FS_MASK in a way
> > 	   that makes it clear how those new bits will be treated.
> > 	4. We must fix nfsd in any case, either by changing the nfsd
> > 	   code or CAP_FS_MASK, but we should err on the side of not
> > 	   changing CAP_FS_MASK, for obvious backwards-compatibility
> > 	   reasons.
> 
> Also, thinking of the nfsd case: it violates the principal of least
> surprise if dropping CAP_FS_MASK still leaves it possible to make a
> change to the filesystem that would normally require special
> privileges....

Agreed, and so between that and the labeled nfs work, I think we
should add all 4 capabilities to both the CAP_FS_MASK and CAP_NFSD_MASK.

-serge
