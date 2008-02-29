Return-Path: <linux-kernel-owner+w=401wt.eu-S1759994AbYB2BIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759994AbYB2BIN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 20:08:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761349AbYB2A5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 19:57:22 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:44769 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761900AbYB2A5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 19:57:19 -0500
Subject: Re: [PATCH 01/11] Security: Add hook to get full maclabel xattr
	name
From: Dave Quigley <dpquigl@tycho.nsa.gov>
To: Christoph Hellwig <hch@infradead.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, casey@schaufler-ca.com,
       viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <20080229003937.GA16343@infradead.org>
References: <746385.69480.qm@web36611.mail.mud.yahoo.com>
	 <1204227035.31790.207.camel@moss-spartans.epoch.ncsc.mil>
	 <20080228234850.GA25829@infradead.org>
	 <1204243497.2715.24.camel@moss-terrapins.epoch.ncsc.mil>
	 <20080229003937.GA16343@infradead.org>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 19:32:47 -0500
Message-Id: <1204245167.2715.37.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-28 at 19:39 -0500, Christoph Hellwig wrote:
> On Thu, Feb 28, 2008 at 07:04:57PM -0500, Dave Quigley wrote:
> > There are several things here. I've spoken to several people about this
> > and the belief I've gotten from most of them is that a recommended
> > attribute is how this is to be transported. The NFSv4 spec people will
> > probably say that if you want xattr like functionality for NFSv4 use
> > named attributes. For us this is not an option since we require
> > semantics to label on create/open and the only way we can do this is by
> > adding a recommended attribute. The create/open calls in NFSv4 takes a
> > list of attributes to use on create as part of the request. I really
> > don't see a difference between the security blob and the
> > username/groupname that NFSv4 currently uses. Also there is a good
> > chance that we will need to translate labels at some point (read future
> > work).
> 
> Then use the existing side-band protocol and ignore the NFSv4 spec
> group.  They're <skip colourful language here> anyway.

The reason we are trying to go through the standards process in the
first place is that there is a desire to use SELinux with large netapp
storage boxes. I don't believe that netapp supports the existing
side-band protocol for NFSv4 and the impression I got was that they we
were going to have an incredibly hard time convincing them of putting
anything in that isn't part of the standard. It seems that adding one
recommended attribute which is described in a 3 page internet draft(Most
of which is BS that is part of the template) would be significantly
easier to get into the standard than trying to push an out of band xattr
protocol. Also, I believe Trond even expressed some discontent with it a
while back when we first started development. 

> 
> > > Wow, that's rude even to someone as direct as me.  Casey is the only
> > > other person having an in-tree LSM, and I think his input in this
> > > area is important.  But if not I as a VFS person can happily give
> > > you my "no" for the current version from the VFS point of view.
> > 
> > I can only speak for myself but honestly I've only seen Casey act
> > confrontational to this idea from the beginning. There is absolutely
> > nothing in here that is SELinux specific, tecnically its not even MAC
> > specific. I said from the beginning that this was perhaps not the best
> > name and we are willing to change it
> 
> And changing the name and minor details is exactly what Casey requested.

I can always go with the original hook name of get_security_xattr_name
which turns into a security_get_security_xattr_name call which seems a
bit ludicrous. The only other complaint that I saw from Casey besides
the name of the function was that there could be more than one xattr. If
we want to address that then I need another hook that says give me all
data that the LSM deems important for this file. Which is essentially
the same thing as taking each of the xattr names that the module will
provide, grabbing each of them in turn, and concatenating them together.
For SELinux this is no different than getsecurity with the selinux
suffix. The same goes for SMACK.

Dave

