Return-Path: <linux-kernel-owner+w=401wt.eu-S1756414AbYB2Brd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414AbYB2Brd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 20:47:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbYB2BrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 20:47:19 -0500
Received: from web36614.mail.mud.yahoo.com ([209.191.85.31]:37620 "HELO
	web36614.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755621AbYB2BrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 20:47:16 -0500
X-YMail-OSG: mcLmkw4VM1mNY.huLEO3Ze4x3tC.bmu5xmSDPWzJzng.t52U0WrZZvN59WRic6knN7POCVlwHg--
X-RocketYMMF: rancidfat
Date: Thu, 28 Feb 2008 17:47:15 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 01/11] Security: Add hook to get full maclabel xattr name
To: Dave Quigley <dpquigl@tycho.nsa.gov>,
       Christoph Hellwig <hch@infradead.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, casey@schaufler-ca.com,
       viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <1204245167.2715.37.camel@moss-terrapins.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <519499.69572.qm@web36614.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Dave Quigley <dpquigl@tycho.nsa.gov> wrote:

> 
> ...
> 
> The reason we are trying to go through the standards process in the
> first place is that there is a desire to use SELinux with large netapp
> storage boxes. I don't believe that netapp supports the existing
> side-band protocol for NFSv4 and the impression I got was that they we
> were going to have an incredibly hard time convincing them of putting
> anything in that isn't part of the standard.

Most of the original SGI XFS team went to NetApp. The engineer
who developed the side-band xattr protocol (last I heard he was a
real estate speculator in Florida) spent lots of time with them.
They may not be so hostile to the idea as you seem to think.

> It seems that adding one
> recommended attribute which is described in a 3 page internet draft(Most
> of which is BS that is part of the template) would be significantly
> easier to get into the standard than trying to push an out of band xattr
> protocol.

Easier may be pragmatic, but that does not make it right.
I suggest, that in my opinion (there, is that sufficiently
non-confrontational?) that Linux and the LSM are much better
served by a general xattr protocol than by adding a single
reccommended attribute.

> Also, I believe Trond even expressed some discontent with it a
> while back when we first started development. 

And he wasn't confrontational at all! (insert smiley here)
> 
> ...
> > 
> > And changing the name and minor details is exactly what Casey requested.
> 
> I can always go with the original hook name of get_security_xattr_name
> which turns into a security_get_security_xattr_name call which seems a
> bit ludicrous.

Well, that's why I keep suggesting security_blob_name.
Do you have something against blobs?

> The only other complaint that I saw from Casey besides
> the name of the function was that there could be more than one xattr.

More precisely, I said that there could be a number other than one,
with zero also being an option, and the possibility existing that the
name of the blob might not be an xattr (it could be uid, gid, access
time, or inode number based) and still make a useful LSM.

> If
> we want to address that then I need another hook that says give me all
> data that the LSM deems important for this file. Which is essentially
> the same thing as taking each of the xattr names that the module will
> provide, grabbing each of them in turn, and concatenating them together.

That would be security_getblob(), would it not?
And if you have that, why do you need the attribute name?

> For SELinux this is no different than getsecurity with the selinux
> suffix. The same goes for SMACK.

True enough, but like I keep saying, those are both single label
stored in an xattr based MAC systems.

BTW, I prefer "Smack" to SMACK. Much less 1970's.

Thank you.


Casey Schaufler
casey@schaufler-ca.com
