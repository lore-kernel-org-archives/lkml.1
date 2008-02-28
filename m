Return-Path: <linux-kernel-owner+w=401wt.eu-S932382AbYB1BHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382AbYB1BHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 20:07:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759221AbYB1BHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 20:07:44 -0500
Received: from web36606.mail.mud.yahoo.com ([209.191.85.23]:23117 "HELO
	web36606.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752744AbYB1BHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 20:07:43 -0500
X-YMail-OSG: vQQFemAVM1kMAlDSG_KZ0siZ91a841i.j2zY3VFO2LvbuMJVhwxY7cNqvM0eAt1ii_hmhBuOHQ--
X-RocketYMMF: rancidfat
Date: Wed, 27 Feb 2008 17:07:41 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 01/11] Security: Add hook to get full maclabel xattr name
To: Dave Quigley <dpquigl@tycho.nsa.gov>, casey@schaufler-ca.com
Cc: hch@infradead.org, viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no,
       bfields@fieldses.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <1204157539.24345.3.camel@moss-terrapins.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <804125.16775.qm@web36606.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Dave Quigley <dpquigl@tycho.nsa.gov> wrote:

> 
> On Wed, 2008-02-27 at 15:42 -0800, Casey Schaufler wrote:
> > --- "David P. Quigley" <dpquigl@tycho.nsa.gov> wrote:
> > 
> > ...
> > > +	const char *(*maclabel_getname) (void);
> > 
> > I think that calling this a maclabel is a really bad idea. For one
> > thing, it assumes that all interesting security attributes are for
> > Mandatory Access Control. Also, it assumes that they are stored as
> > xattrs. While these conditions are both met by the two current LSMs
> > I would suggest that this is not a fair assumption for the long
> > haul unless the intention is to lock the lSM into only supporting
> > xattr based label based MAC modules.
> 
> Actually that is a completely fair assumption.

A completely reasonable LSM would be a discretionary time lock.
The owner could set or unset the times when a file might be accessed.
Stored as an xattr, but neither a label nor Mandatory Access Control.
I propose this as an example of why the name maclabel is inappropriate,
because in this case the data involved is neither. Please also consider
that, as horrible as it may seem, an LSM could legitimately require
more than one xattr. A proper Compartmented Mode Workstation, for
example, might have a MAC label and an Information label, and as anyone
familiar with the CMW spec will tell you, they have to be separate.
Granted, the information label is only supposed to be used to indicate
the actual sensitivity of information, but if it's available someone is
going to use it programaticly.

> When this whole thing
> started it was mandated that security attributes be stored in xattrs.

I'll grant you the xattr bit.

> I
> originally had a more convoluted name but after asking around we thought
> this one was better. Not to mention this is a slightly reworked hook
> that was just removed from the LSM since there were no users. While I'm
> open to potentially changing the name the paradigm that we use the xattr
> functionality of linux to handle security labels has been around since
> the beginning of LSM. If we want to revisit that idea I'm willing to do
> it but it needs more people than just you and I to agree to reopen it. 

The paradigm is* a security "blob" which is meaningfull only to the
security module proper. This is what allows SELinux to use secids and
Smack to toss around text strings. It's not MAC data and it's not
an NFS label, it's private to the LSM. It makes a lot of sense to use
an xattr to store a blob but, as the AppArmor people have been known
espouse, it's not the only way. The blob could be referenced from a
table using the inode number (it has been done on other systems and
works fine) rather than an xattr, in which case the whole "name" may
be meaningless.


----
* It was when the whole thing started out at least.

Casey Schaufler
casey@schaufler-ca.com
