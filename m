Return-Path: <linux-kernel-owner+w=401wt.eu-S1760089AbYB2BMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089AbYB2BMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 20:12:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757376AbYB2BHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 20:07:19 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:54437 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757219AbYB2BHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 20:07:17 -0500
Subject: Re: [PATCH 01/11] Security: Add hook to get full maclabel xattr
	name
From: Dave Quigley <dpquigl@tycho.nsa.gov>
To: Christoph Hellwig <hch@infradead.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, casey@schaufler-ca.com,
       viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <20080229010055.GA26176@infradead.org>
References: <746385.69480.qm@web36611.mail.mud.yahoo.com>
	 <1204227035.31790.207.camel@moss-spartans.epoch.ncsc.mil>
	 <20080228234850.GA25829@infradead.org>
	 <1204243497.2715.24.camel@moss-terrapins.epoch.ncsc.mil>
	 <20080229003937.GA16343@infradead.org>
	 <1204245167.2715.37.camel@moss-terrapins.epoch.ncsc.mil>
	 <20080229010055.GA26176@infradead.org>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 19:42:47 -0500
Message-Id: <1204245767.2715.43.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-28 at 20:00 -0500, Christoph Hellwig wrote:
> On Thu, Feb 28, 2008 at 07:32:47PM -0500, Dave Quigley wrote:
> > I can always go with the original hook name of get_security_xattr_name
> > which turns into a security_get_security_xattr_name call which seems a
> > bit ludicrous. The only other complaint that I saw from Casey besides
> > the name of the function was that there could be more than one xattr. If
> > we want to address that then I need another hook that says give me all
> > data that the LSM deems important for this file. Which is essentially
> > the same thing as taking each of the xattr names that the module will
> > provide, grabbing each of them in turn, and concatenating them together.
> > For SELinux this is no different than getsecurity with the selinux
> > suffix. The same goes for SMACK.
> 
> What about Casey's suggestion of get_security_blob?  For any reasonable
> module that just has a single xattr it's trivial and for those that
> have multiple or a different storage model it might get complicated
> but that's not our problem for now.

If this is the method we are going to use then we need a corresponding
set_security_blob as well. This seems like a paradigm shift for
accessing security information in the kernel. I said to Casey in the
beginning that I'd be willing to revisit it but that neither he or I
alone could make the decision. Unless I misunderstood the original
mandate for security information and that it only applies to how user
space accesses it.

Dave

