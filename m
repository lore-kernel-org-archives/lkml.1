Return-Path: <linux-kernel-owner+w=401wt.eu-S934674AbXHGOMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934674AbXHGOMB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 10:12:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755504AbXHGOLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 10:11:52 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:38523 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754928AbXHGOLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 10:11:51 -0400
Date: Tue, 7 Aug 2007 09:11:49 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Andrew Morgan <morgan@kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, Andrew Morgan <agm@google.com>,
       casey@schaufler-ca.com, Andrew Morton <akpm@google.com>,
       KaiGai Kohei <kaigai@kaigai.gr.jp>, James Morris <jmorris@namei.org>,
       linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] file capabilities: clear fcaps on inode change (v2)
Message-ID: <20070807141149.GC8286@sergelap.austin.ibm.com>
References: <20070806185231.GA21550@sergelap.austin.ibm.com> <1186495022.26457.44.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186495022.26457.44.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Smalley (sds@tycho.nsa.gov):
> On Mon, 2007-08-06 at 13:52 -0500, Serge E. Hallyn wrote:
> > >From 1376764cbb54243f088cf00c39000c4f4418f461 Mon Sep 17 00:00:00 2001
> > From: Serge E. Hallyn <serue@us.ibm.com>
> > Date: Mon, 6 Aug 2007 14:20:06 -0400
> > Subject: [PATCH 1/1] file capabilities: clear fcaps on inode change (v2)
> > 
> > When a file with posix capabilities is overwritten, the
> > file capabilities, like a setuid bit, should be removed.
> > 
> > This patch introduces security_inode_killpriv().  This is
> > currently only defined for capability, and is called when
> > an inode is changed to inform the security module that
> > it may want to clear out any privilege attached to that inode.
> > The capability module checks whether any file capabilities
> > are defined for the inode, and, if so, clears them.
> > 
> > Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> > ---
> >  fs/attr.c                |    7 +++++++
> >  fs/nfsd/vfs.c            |    4 ++--
> >  fs/open.c                |    3 ++-
> >  fs/splice.c              |    4 ++++
> >  include/linux/fs.h       |    1 +
> >  include/linux/security.h |   18 ++++++++++++++++++
> >  mm/filemap.c             |    5 +++++
> >  security/capability.c    |    1 +
> >  security/commoncap.c     |   27 +++++++++++++++++++++++++++
> >  security/dummy.c         |    6 ++++++
> >  security/security.c      |    5 +++++
> >  11 files changed, 78 insertions(+), 3 deletions(-)
> > 
> 
> > diff --git a/security/capability.c b/security/capability.c
> > index dc2b66c..e23864e 100644
> > --- a/security/capability.c
> > +++ b/security/capability.c
> > @@ -37,6 +37,7 @@ static struct security_operations capability_ops = {
> >  
> >  	.inode_setxattr =		cap_inode_setxattr,
> >  	.inode_removexattr =		cap_inode_removexattr,
> > +	.inode_removexattr =		cap_inode_killpriv,
> 
> s/inode_removexattr/inode_killpriv/

Well crap - I had fixed that an hour before I sent it.  Which makes me
wonder which version I sent...

> Also, doesn't SELinux then need to define a corresponding hook function
> to call the secondary module?  Otherwise, it will fall back to the dummy
> implementation and stacking selinux + capabilities with file caps won't
> yield the right behavior.

Yes it does.  Will fix that on resend.

thanks,
-serge
