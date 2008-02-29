Return-Path: <linux-kernel-owner+w=401wt.eu-S932637AbYB2Oqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637AbYB2Oqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 09:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757797AbYB2Oql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 09:46:41 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:53891 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526AbYB2Oqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 09:46:40 -0500
Subject: Re: [PATCH 01/11] Security: Add hook to get full maclabel xattr
	name
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Quigley <dpquigl@tycho.nsa.gov>, casey@schaufler-ca.com,
       viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <1204291806.31790.233.camel@moss-spartans.epoch.ncsc.mil>
References: <746385.69480.qm@web36611.mail.mud.yahoo.com>
	 <1204227035.31790.207.camel@moss-spartans.epoch.ncsc.mil>
	 <20080228234850.GA25829@infradead.org>
	 <1204243497.2715.24.camel@moss-terrapins.epoch.ncsc.mil>
	 <20080229003937.GA16343@infradead.org>
	 <1204245167.2715.37.camel@moss-terrapins.epoch.ncsc.mil>
	 <20080229010055.GA26176@infradead.org>
	 <1204291806.31790.233.camel@moss-spartans.epoch.ncsc.mil>
Content-Type: text/plain
Organization: National Security Agency
Date: Fri, 29 Feb 2008 09:45:57 -0500
Message-Id: <1204296357.31790.273.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-29 at 08:30 -0500, Stephen Smalley wrote:
> On Thu, 2008-02-28 at 20:00 -0500, Christoph Hellwig wrote:
> > On Thu, Feb 28, 2008 at 07:32:47PM -0500, Dave Quigley wrote:
> > > I can always go with the original hook name of get_security_xattr_name
> > > which turns into a security_get_security_xattr_name call which seems a
> > > bit ludicrous. The only other complaint that I saw from Casey besides
> > > the name of the function was that there could be more than one xattr. If
> > > we want to address that then I need another hook that says give me all
> > > data that the LSM deems important for this file. Which is essentially
> > > the same thing as taking each of the xattr names that the module will
> > > provide, grabbing each of them in turn, and concatenating them together.
> > > For SELinux this is no different than getsecurity with the selinux
> > > suffix. The same goes for SMACK.
> > 
> > What about Casey's suggestion of get_security_blob?  For any reasonable
> > module that just has a single xattr it's trivial and for those that
> > have multiple or a different storage model it might get complicated
> > but that's not our problem for now.
> 
> Possibly I'm missing something, but if I'm implementing a security
> module that has any security attribute at all, e.g. capability module
> with security.capability, and I see a hook called "get_security_blob" or
> "get_security_attr" or the like, I'll implement that hook and return my
> attribute there.  Which in turn will _break_ the labeled NFS
> functionality because it is expecting a MAC label specifically.
> 
> The whole point here is that we do not want modules like capability to
> return their security attributes here, because this is to support
> labeled NFS functionality in support of enforcing MAC.
> 
> I don't especially care about the hook name per se, but the interface
> (whatever it may be) needs to convey the proper semantics, and the
> semantics truly are MAC specific (and should be).

BTW, to date, "security blob" has been used to refer to the structures
allocated by the security modules referenced by the void* security
fields in the kernel data structures (task, inode, ...), while
"secctx" (security context) and "secid" (security id) have been
leveraged by subsystems like audit, netlink and labeled IPSEC to
represent security labels.

-- 
Stephen Smalley
National Security Agency

