Return-Path: <linux-kernel-owner+w=401wt.eu-S1762382AbYB1TXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762382AbYB1TXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:23:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760001AbYB1TX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:23:27 -0500
Received: from web36611.mail.mud.yahoo.com ([209.191.85.28]:20111 "HELO
	web36611.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758686AbYB1TXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:23:25 -0500
X-YMail-OSG: EA3KhsUVM1mhGCYKqMEDODhux62E4VWG9Zw1m44.8YpB8rjrkLXk95dDtjFndl5DZHcCoEAvuw--
X-RocketYMMF: rancidfat
Date: Thu, 28 Feb 2008 11:23:21 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 01/11] Security: Add hook to get full maclabel xattr name
To: Stephen Smalley <sds@tycho.nsa.gov>, casey@schaufler-ca.com
Cc: Dave Quigley <dpquigl@tycho.nsa.gov>, hch@infradead.org,
       viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <1204206224.31790.52.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <746385.69480.qm@web36611.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Stephen Smalley <sds@tycho.nsa.gov> wrote:

> 
> ...
> > The paradigm is* a security "blob" which is meaningfull only to the
> > security module proper. This is what allows SELinux to use secids and
> > Smack to toss around text strings. It's not MAC data and it's not
> > an NFS label, it's private to the LSM. It makes a lot of sense to use
> > an xattr to store a blob but, as the AppArmor people have been known
> > espouse, it's not the only way. The blob could be referenced from a
> > table using the inode number (it has been done on other systems and
> > works fine) rather than an xattr, in which case the whole "name" may
> > be meaningless.
> 
> I think it might help for you to look at how the hook is actually used.
> It is specific to MAC labeling, and we do not want some random other
> security attribute name returned here that is for some purpose other
> than MAC labeling, like security.capability.

I can see how it's being used just fine, thank you.
If you only want this interface for SELinux put it in
SELinux. Don't clutter up the LSM with it. If it's an
LSM interface it should be potentially useful for any
and all LSMs, be they label based or not, MAC or DAC.
Even within a label based MAC scheme it may not be
sensible, given that a MAC scheme could use multiple
xattrs (e.g. a B&L sensitivity label and a Biba integrity
label) to store its blob.

If what you want in LSM terms is a name to give the blob
make your interface be security_blob_name(). The LSM can
deal with this as it sees fit, and NFS can determine if
it's a blob that it wants to deal with independently.
Such an interface could even support stacking should
that ever come about.

LSM is not supposed to be only for MAC and it's not supposed
to be only for label based schemes. It's supposed to be
for additional security restrictions. Providing an interface
that should be generally applicable with a name that
constrains it to a specific subset of those schemes is wrong.



Casey Schaufler
casey@schaufler-ca.com
