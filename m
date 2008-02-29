Return-Path: <linux-kernel-owner+w=401wt.eu-S1757555AbYB2B6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbYB2B6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 20:58:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbYB2B6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 20:58:10 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:61439 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805AbYB2B6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 20:58:08 -0500
Subject: Re: [PATCH 01/11] Security: Add hook to get full maclabel xattr
	name
From: Dave Quigley <dpquigl@tycho.nsa.gov>
To: casey@schaufler-ca.com
Cc: Christoph Hellwig <hch@infradead.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <519499.69572.qm@web36614.mail.mud.yahoo.com>
References: <519499.69572.qm@web36614.mail.mud.yahoo.com>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 20:33:18 -0500
Message-Id: <1204248798.2715.62.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-28 at 17:47 -0800, Casey Schaufler wrote:
> --- Dave Quigley <dpquigl@tycho.nsa.gov> wrote:
> 
> > 
> > ...
> > 
> > The reason we are trying to go through the standards process in the
> > first place is that there is a desire to use SELinux with large netapp
> > storage boxes. I don't believe that netapp supports the existing
> > side-band protocol for NFSv4 and the impression I got was that they we
> > were going to have an incredibly hard time convincing them of putting
> > anything in that isn't part of the standard.
> 
> Most of the original SGI XFS team went to NetApp. The engineer
> who developed the side-band xattr protocol (last I heard he was a
> real estate speculator in Florida) spent lots of time with them.
> They may not be so hostile to the idea as you seem to think.
> 
> > It seems that adding one
> > recommended attribute which is described in a 3 page internet draft(Most
> > of which is BS that is part of the template) would be significantly
> > easier to get into the standard than trying to push an out of band xattr
> > protocol.
> 
> Easier may be pragmatic, but that does not make it right.
> I suggest, that in my opinion (there, is that sufficiently
> non-confrontational?) that Linux and the LSM are much better
> served by a general xattr protocol than by adding a single
> reccommended attribute.

You might be right that Linux and LSM are better served by this, but
this has to be used by more than just Linux. Solaris has the new FMAC
initiative (The F is silent) which will probably want to use this as
well. SEBSD/SEDarwin also has a use for this and they have a MAC label
concept in their OS with a system call for getting/setting it. 

> 
> > Also, I believe Trond even expressed some discontent with it a
> > while back when we first started development. 
> 
> And he wasn't confrontational at all! (insert smiley here)

I'm not about to get between him and Christoph :)

> > 
> > ...
> > > 
> > > And changing the name and minor details is exactly what Casey requested.
> > 
> > I can always go with the original hook name of get_security_xattr_name
> > which turns into a security_get_security_xattr_name call which seems a
> > bit ludicrous.
> 
> Well, that's why I keep suggesting security_blob_name.
> Do you have something against blobs?
> 
> > The only other complaint that I saw from Casey besides
> > the name of the function was that there could be more than one xattr.
> 
> More precisely, I said that there could be a number other than one,
> with zero also being an option, and the possibility existing that the
> name of the blob might not be an xattr (it could be uid, gid, access
> time, or inode number based) and still make a useful LSM.

It seems your argument is against using xattrs. Regardless of this hook
the 0 xattr LSM is still borked by this. security_inode_getsecurity(...,
suffix, ...). It is assumed that the fundamental function for getting
security information takes an xattr suffix. Don't bother responding to
this email eventually you will get to the one where I agree with you on
some points.

> 
> > If
> > we want to address that then I need another hook that says give me all
> > data that the LSM deems important for this file. Which is essentially
> > the same thing as taking each of the xattr names that the module will
> > provide, grabbing each of them in turn, and concatenating them together.
> 
> That would be security_getblob(), would it not?
> And if you have that, why do you need the attribute name?

Keep reading your emails :)
> 
> > For SELinux this is no different than getsecurity with the selinux
> > suffix. The same goes for SMACK.
> 
> True enough, but like I keep saying, those are both single label
> stored in an xattr based MAC systems.
> 
> BTW, I prefer "Smack" to SMACK. Much less 1970's.
> 
> Thank you.
> 
> 
> Casey Schaufler
> casey@schaufler-ca.com

