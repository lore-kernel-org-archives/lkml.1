Return-Path: <linux-kernel-owner+w=401wt.eu-S1752642AbYCLOQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbYCLOQA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 10:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbYCLOPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 10:15:51 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53427 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbYCLOPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 10:15:50 -0400
Date: Wed, 12 Mar 2008 09:15:46 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Pavel Emelyanov <xemul@openvz.org>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, menage@google.com, sukadev@us.ibm.com,
       Al Viro <viro@zeniv.linux.org.uk>,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 5/9] Make use of permissions, returned by kobj_lookup
Message-ID: <20080312141546.GD8308@sergelap.austin.ibm.com>
References: <20080307013553.7ed35f91.akpm@linux-foundation.org> <47D11068.9010704@openvz.org> <20080307155921.GB28439@kroah.com> <47D16F9B.6050008@openvz.org> <20080307170104.GA24746@kroah.com> <47D657A3.5080801@openvz.org> <20080311173646.GA26931@kroah.com> <47D793AB.6070008@openvz.org> <20080312130904.GB8308@sergelap.austin.ibm.com> <1205327912.23866.228.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205327912.23866.228.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Smalley (sds@tycho.nsa.gov):
> 
> On Wed, 2008-03-12 at 08:09 -0500, Serge E. Hallyn wrote:
> > Quoting Pavel Emelyanov (xemul@openvz.org):
> > > Greg KH wrote:
> > > > On Tue, Mar 11, 2008 at 12:57:55PM +0300, Pavel Emelyanov wrote:
> > > >> Besides, I've measured some things - the lat_syscall test for open from 
> > > >> lmbench test suite and the nptl perf test. Here are the results:
> > > >>
> > > >>         sec     nosec
> > > >> open    3.0980s  3.0709s
> > > >> nptl    2.7746s  2.7710s
> > > >>
> > > >> So we have 0.88% loss in open and ~0.15% with nptl. I know, this is not that
> > > >> much, but it is noticeable. Besides, this is only two tests, digging deeper
> > > >> may reveal more.
> > > > 
> > > > I think that is in the noise of sampling if you run that test many more
> > > > times.
> > > 
> > > These numbers are average values of 20 runs of each test. I didn't
> > > provide the measurement accuracy, but the abs(open.sec - open.nosec)
> > > is greater than it.
> > > 
> > > >> Let alone the fact that simply turning the CONFIG_SECURITY to 'y' puts +8Kb 
> > > >> to the vmlinux...
> > > >>
> > > >> I think, I finally agree with you and Al Viro, that the kobj mapper is 
> > > >> not the right place to put the filtering, but taking the above numbers 
> > > >> into account, can we put the "hooks" into the #else /* CONFIG_SECURITY */
> > > >> versions of security_inode_permission/security_file_permission/etc?
> > > > 
> > > > Ask the security module interface maintainers about this, not me :)
> > > 
> > > OK :) Thanks for your time, Greg.
> > > 
> > > So, Serge, since you already have a LSM-based version, maybe you can
> > > change it with the proposed "fix" and send it to LSM maintainers for
> > > review?
> > 
> > To take the point of view of someone who neither wants containers nor
> > LSM but just a fast box,
> > 
> > you're asking me to introduce LSM hooks for the !SECURITY case?  :)
> > 
> > I can give it a shot, but I expect some complaints.  Now at least the
> > _mknod hook shouldn't be a hotpath,  and I suppose I can add yet
> > an #ifdef inside the !SECURITY version of security_inode_permission().
> > I still expect some complaints though.  I'll send something soon.
> 
> Not sure I'm following the plot here, but please don't do anything that
> will prohibit the use of containers/namespaces with security modules
> like SELinux/Smack.

Absolutely not.  There would be a redundant explicit hook in the
!SECURITY case, but in the SECURITY=y case the regular hooks would be
used by the device controller.

I definately consider SELinux/Smack+containers an important case.

> Yes, that's a legitimate use case, and there will
> be people who will want to do that - they serve different but
> complementary purposes (containers are _not_ a substitute for MAC).  We
> don't want them to be exclusive of one another.

Agreed.

-serge
