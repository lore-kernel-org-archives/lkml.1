Return-Path: <linux-kernel-owner+w=401wt.eu-S1758182AbYJ3RRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182AbYJ3RRy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756871AbYJ3RRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:17:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38986 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755557AbYJ3RRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:17:43 -0400
Subject: Re: [PATCH -v1 1/3] SECURITY: new capable_noaudit interface
From: Eric Paris <eparis@redhat.com>
To: Paul Moore <paul.moore@hp.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org,
       sds@tycho.nsa.gov, jmorris@nameil.org, morgan@kernel.org,
       casey@schaufler-ca.com, esandeen@redhat.com
In-Reply-To: <200810301246.20328.paul.moore@hp.com>
References: <20081029190652.31292.5901.stgit@paris.rdu.redhat.com>
	 <20081030152940.GA24853@us.ibm.com>  <200810301246.20328.paul.moore@hp.com>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 13:17:32 -0400
Message-Id: <1225387052.3235.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-30 at 12:46 -0400, Paul Moore wrote:
> On Thursday 30 October 2008 11:29:40 am Serge E. Hallyn wrote:
> > Quoting Eric Paris (eparis@redhat.com):
> > > Add a new capable interface that will be used by systems that use
> > > audit to make an A or B type decision instead of a security
> > > decision.  Currently this is the case at least for filesystems when
> > > deciding if a process can use the reserved 'root' blocks and for
> > > the case of things like the oom algorithm determining if processes
> > > are root processes and should be less likely to be killed.  These
> > > types of security system requests should not be audited or logged
> > > since they are not really security decisions.  It would be possible
> > > to solve this problem like the vm_enough_memory security check did
> > > by creating a new LSM interface and moving all of the policy into
> > > that interface but proves the needlessly bloat the LSM and provide
> > > complex indirection.
> > >
> > > This merely allows those decisions to be made where they belong and
> > > to not flood logs or printk with denials for thing that are not
> > > security decisions.
> > >
> > > Signed-off-by: Eric Paris <eparis@redhat.com>
> >
> > Please introduce some meaningful defines instead of passing 0 and 1.
> > I.e.
> >
> > #define CAP_NOAUDIT 0
> > #define CAP_AUDIT 1
> >
> > Otherwise, looks fine.
> 
> As a general rule aren't boolean arguments like this frowned upon, with 
> variations on the function preferred, i.e. something like below?
> 
>  int cap_capable(struct task_struct *tsk, int cap);
>  int cap_capable_audit(struct task_struct *tsk, int cap);

Well from outside the "security" subsystem people should call either

has_capability()
has_capability_noaudit()
or
capable()   (which calls has_capability())

How far down do I have to keep duplicating functionality to avoid
booleans?

-Eric

