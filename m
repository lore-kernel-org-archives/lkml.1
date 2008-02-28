Return-Path: <linux-kernel-owner+w=401wt.eu-S1762713AbYB1Tc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762713AbYB1Tc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:32:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760842AbYB1TcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:32:10 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:57659 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760698AbYB1TcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:32:08 -0500
Subject: Re: [PATCH 01/11] Security: Add hook to get full maclabel xattr
	name
From: Stephen Smalley <sds@tycho.nsa.gov>
To: casey@schaufler-ca.com
Cc: Dave Quigley <dpquigl@tycho.nsa.gov>, hch@infradead.org,
       viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <746385.69480.qm@web36611.mail.mud.yahoo.com>
References: <746385.69480.qm@web36611.mail.mud.yahoo.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 28 Feb 2008 14:30:35 -0500
Message-Id: <1204227035.31790.207.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-28 at 11:23 -0800, Casey Schaufler wrote:
> --- Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
> > 
> > ...
> > > The paradigm is* a security "blob" which is meaningfull only to the
> > > security module proper. This is what allows SELinux to use secids and
> > > Smack to toss around text strings. It's not MAC data and it's not
> > > an NFS label, it's private to the LSM. It makes a lot of sense to use
> > > an xattr to store a blob but, as the AppArmor people have been known
> > > espouse, it's not the only way. The blob could be referenced from a
> > > table using the inode number (it has been done on other systems and
> > > works fine) rather than an xattr, in which case the whole "name" may
> > > be meaningless.
> > 
> > I think it might help for you to look at how the hook is actually used.
> > It is specific to MAC labeling, and we do not want some random other
> > security attribute name returned here that is for some purpose other
> > than MAC labeling, like security.capability.
> 
> I can see how it's being used just fine, thank you.
> If you only want this interface for SELinux put it in
> SELinux. Don't clutter up the LSM with it. If it's an
> LSM interface it should be potentially useful for any
> and all LSMs, be they label based or not, MAC or DAC.
> Even within a label based MAC scheme it may not be
> sensible, given that a MAC scheme could use multiple
> xattrs (e.g. a B&L sensitivity label and a Biba integrity
> label) to store its blob.
> 
> If what you want in LSM terms is a name to give the blob
> make your interface be security_blob_name(). The LSM can
> deal with this as it sees fit, and NFS can determine if
> it's a blob that it wants to deal with independently.
> Such an interface could even support stacking should
> that ever come about.
> 
> LSM is not supposed to be only for MAC and it's not supposed
> to be only for label based schemes. It's supposed to be
> for additional security restrictions. Providing an interface
> that should be generally applicable with a name that
> constrains it to a specific subset of those schemes is wrong.

Casey, you aren't listening (why am I surprised?).

This is an interface to be used by NFS to get information from the
security module.  The information desired is specific to the MAC
labeling functionality in NFSv4 that is being proposed.  That
functionality is MAC specific (necessarily so, just like the ACL
functionality is ACL specific).  We are hiding the SELinux-specific bits
behind the LSM interface, and non-MAC LSMs are free to return NULL in
order to indicate that they don't support MAC labeling.  We do NOT want
the capability module to return its security blob here, or any other
non-MAC LSM - it will yield the wrong semantics for the NFS MAC support.

In any event, I don't think we need your permission.

-- 
Stephen Smalley
National Security Agency

