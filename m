Return-Path: <linux-kernel-owner+w=401wt.eu-S1758613AbZCQSX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613AbZCQSX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 14:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754166AbZCQSXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 14:23:48 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:39056 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbZCQSXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 14:23:47 -0400
Date: Tue, 17 Mar 2009 13:23:35 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Igor Zhbanov <izh1979@gmail.com>, "J. Bruce Fields" <bfields@fieldses.org>,
       Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, neilb@suse.de, Trond.Myklebust@netapp.com,
       David Howells <dhowells@redhat.com>, Andrew Morgan <morgan@kernel.org>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       SELinux <selinux@tycho.nsa.gov>
Subject: Re: =?utf-8?B?0J7RgtCy0LXRgjogVkZTLCBORlMg?=
	=?utf-8?Q?security_bug=3F_Shoul?=
	=?utf-8?Q?d?= CAP_MKNOD and CAP_LINUX_IMMUTABLE be added to
	CAP_FS_MASK?
Message-ID: <20090317182335.GB31633@us.ibm.com>
References: <20090313175848.GB27891@fieldses.org> <f44001920903131137j158c5f76y6a71b58ee964df77@mail.gmail.com> <20090313190002.GA16025@us.ibm.com> <1237227705.1035.93.camel@localhost.localdomain> <20090316184926.GA6729@us.ibm.com> <1237237216.1035.195.camel@localhost.localdomain> <20090316231340.GC15522@us.ibm.com> <1237299633.6582.107.camel@localhost.localdomain> <20090317173903.GA31566@us.ibm.com> <1237312345.6582.140.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237312345.6582.140.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Smalley (sds@tycho.nsa.gov):
> On Tue, 2009-03-17 at 12:39 -0500, Serge E. Hallyn wrote:
> > Quoting Stephen Smalley (sds@tycho.nsa.gov):
> > > > So do you think it makes sense to have CAP_MAC_ADMIN and CAP_FOWNER
> > > > in CAP_FS_MASK?  In other words are you objecting to CAP_SYS_ADMIN
> > > > because of all of its other implications, or because you disagree
> > > > that labels for security modules should be treated as mere fs data
> > > > here?
> > > 
> > > For CAP_FOWNER, yes (and it is already there).  CAP_MAC_ADMIN is less
> > 
> > Sorry, I meant CAP_SETFCAP.  Should it be added?
> 
> Sure - it is only used for filesystem operations.

Ok, so then:

> 
> > > ideal as it isn't clearly tied to filesystem accesses, and likewise for
> > > CAP_MAC_OVERRIDE (but that one is included in CAP_FS_MASK already).
> > 
> > So it is.  I didn't realize that.
> > 
> > > Ideally the capability space would be partitioned into capabilities that
> > > affect filesystem accesses and the rest so that setfsuid() would yield
> > > the expected behavior of only affecting filesystem access.
> > > CAP_SYS_ADMIN is even less suitable due to its pervasive use outside of
> > > the filesystem.  So that's the first concern.
> > > 
> > > The second one is that we don't want CAP_SYS_ADMIN (or CAP_MAC_ADMIN) to
> > > be required when setting SELinux labels.  Only the SELinux permission
> > > checks should govern setting those labels (aside from the usual DAC
> > > ownership || CAP_FOWNER check).
> > 
> > So if a non-selinux kernel is booted, then you think only the usual
> > DAC checks should be required to set selinux labels?
> 
> I'm talking about the dumb NFS server case (non-SELinux NFS server
> providing label and data storage to SELinux clients, MAC enforcement
> handled client-side).  But we aren't there yet, so I don't think we have
> to worry about it right now.

But in cap_inode_setxattr, any security.* xattrs are controlled by
CAP_SYS_ADMIN.  So do you think that this should be changed to a
CAP_XATTR_SECURITY capability which can be added to CAP_FS_MASK?

Or do you think it's ok that fsuid=0 does not allow you to set
security.selinux (or security.SMACK64, etc) xattrs when selinux is
not compiled in?

(You may have already answered this with your EOPNOTSUPP comment, but
I want to make sure I understand right)

> > Does anyone know what the trusted xattrs are used for?
> 
> Not beyond what attr(5) says about them.

Well, if attr(5) says CAP_SYS_ADMIN being needed is the very
thing that defines these xattrs, then changing that seems a
bigger deal.  That really does seem akin to changing kernel-user
API.

thanks,
-serge
