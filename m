Return-Path: <linux-kernel-owner+w=401wt.eu-S1758700AbYB2CN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700AbYB2CN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 21:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbYB2CNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 21:13:18 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:64947 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731AbYB2CNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 21:13:16 -0500
Subject: Re: [PATCH 01/11] Security: Add hook to get full maclabel xattr
	name
From: Dave Quigley <dpquigl@tycho.nsa.gov>
To: casey@schaufler-ca.com
Cc: Christoph Hellwig <hch@infradead.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <147227.75672.qm@web36609.mail.mud.yahoo.com>
References: <147227.75672.qm@web36609.mail.mud.yahoo.com>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 20:48:45 -0500
Message-Id: <1204249725.2715.66.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-28 at 18:07 -0800, Casey Schaufler wrote:
> --- Dave Quigley <dpquigl@tycho.nsa.gov> wrote:
> 
> > 
> > On Thu, 2008-02-28 at 20:00 -0500, Christoph Hellwig wrote:
> > > On Thu, Feb 28, 2008 at 07:32:47PM -0500, Dave Quigley wrote:
> > > > I can always go with the original hook name of get_security_xattr_name
> > > > which turns into a security_get_security_xattr_name call which seems a
> > > > bit ludicrous. The only other complaint that I saw from Casey besides
> > > > the name of the function was that there could be more than one xattr. If
> > > > we want to address that then I need another hook that says give me all
> > > > data that the LSM deems important for this file. Which is essentially
> > > > the same thing as taking each of the xattr names that the module will
> > > > provide, grabbing each of them in turn, and concatenating them together.
> > > > For SELinux this is no different than getsecurity with the selinux
> > > > suffix. The same goes for SMACK.
> > > 
> > > What about Casey's suggestion of get_security_blob?  For any reasonable
> > > module that just has a single xattr it's trivial and for those that
> > > have multiple or a different storage model it might get complicated
> > > but that's not our problem for now.
> > 
> > If this is the method we are going to use then we need a corresponding
> > set_security_blob as well.
> 
> Not to sound stupid, but why would you need this?

What do you intend to do with this blob once you have it? Somehow it
needs to be set on the other end. So unless you want each LSM
decomposing the blob inside of NFS you need a hook to allow it to do so.

> 
> > This seems like a paradigm shift for
> > accessing security information in the kernel.
> 
> Well, yes, but look at David Howell's file cacheing work
> before you take too firm a stand.
> 
> > I said to Casey in the
> > beginning that I'd be willing to revisit it but that neither he or I
> > alone could make the decision. Unless I misunderstood the original
> > mandate for security information and that it only applies to how user
> > space accesses it.
> 
> Sorry, I don't understand how user space and mandates go together here

I was inquiring if the mandate to use xattrs for security attributes was
only for userspace's access to them and the kernel could create separate
interfaces for it.

> .
> 
> 
> Casey Schaufler
> casey@schaufler-ca.com

