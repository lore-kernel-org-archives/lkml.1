Return-Path: <linux-kernel-owner+w=401wt.eu-S1759631AbYB1NpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759631AbYB1NpP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 08:45:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbYB1NpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 08:45:03 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:42927 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756869AbYB1NpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 08:45:00 -0500
Subject: Re: [PATCH 01/11] Security: Add hook to get full maclabel xattr
	name
From: Stephen Smalley <sds@tycho.nsa.gov>
To: casey@schaufler-ca.com
Cc: Dave Quigley <dpquigl@tycho.nsa.gov>, hch@infradead.org,
       viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <804125.16775.qm@web36606.mail.mud.yahoo.com>
References: <804125.16775.qm@web36606.mail.mud.yahoo.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 28 Feb 2008 08:43:44 -0500
Message-Id: <1204206224.31790.52.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-27 at 17:07 -0800, Casey Schaufler wrote:
> --- Dave Quigley <dpquigl@tycho.nsa.gov> wrote:
> 
> > 
> > On Wed, 2008-02-27 at 15:42 -0800, Casey Schaufler wrote:
> > > --- "David P. Quigley" <dpquigl@tycho.nsa.gov> wrote:
> > > 
> > > ...
> > > > +	const char *(*maclabel_getname) (void);
> > > 
> > > I think that calling this a maclabel is a really bad idea. For one
> > > thing, it assumes that all interesting security attributes are for
> > > Mandatory Access Control. Also, it assumes that they are stored as
> > > xattrs. While these conditions are both met by the two current LSMs
> > > I would suggest that this is not a fair assumption for the long
> > > haul unless the intention is to lock the lSM into only supporting
> > > xattr based label based MAC modules.
> > 
> > Actually that is a completely fair assumption.
> 
> A completely reasonable LSM would be a discretionary time lock.
> The owner could set or unset the times when a file might be accessed.
> Stored as an xattr, but neither a label nor Mandatory Access Control.
> I propose this as an example of why the name maclabel is inappropriate,
> because in this case the data involved is neither. Please also consider
> that, as horrible as it may seem, an LSM could legitimately require
> more than one xattr. A proper Compartmented Mode Workstation, for
> example, might have a MAC label and an Information label, and as anyone
> familiar with the CMW spec will tell you, they have to be separate.
> Granted, the information label is only supposed to be used to indicate
> the actual sensitivity of information, but if it's available someone is
> going to use it programaticly.
> 
> > When this whole thing
> > started it was mandated that security attributes be stored in xattrs.
> 
> I'll grant you the xattr bit.
> 
> > I
> > originally had a more convoluted name but after asking around we thought
> > this one was better. Not to mention this is a slightly reworked hook
> > that was just removed from the LSM since there were no users. While I'm
> > open to potentially changing the name the paradigm that we use the xattr
> > functionality of linux to handle security labels has been around since
> > the beginning of LSM. If we want to revisit that idea I'm willing to do
> > it but it needs more people than just you and I to agree to reopen it. 
> 
> The paradigm is* a security "blob" which is meaningfull only to the
> security module proper. This is what allows SELinux to use secids and
> Smack to toss around text strings. It's not MAC data and it's not
> an NFS label, it's private to the LSM. It makes a lot of sense to use
> an xattr to store a blob but, as the AppArmor people have been known
> espouse, it's not the only way. The blob could be referenced from a
> table using the inode number (it has been done on other systems and
> works fine) rather than an xattr, in which case the whole "name" may
> be meaningless.

I think it might help for you to look at how the hook is actually used.
It is specific to MAC labeling, and we do not want some random other
security attribute name returned here that is for some purpose other
than MAC labeling, like security.capability.

-- 
Stephen Smalley
National Security Agency

