Return-Path: <linux-kernel-owner+w=401wt.eu-S1766907AbXDSRqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766907AbXDSRqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 13:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766912AbXDSRqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 13:46:52 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:47132 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1766906AbXDSRqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 13:46:49 -0400
Subject: Re: AppArmor FAQ
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Andi Kleen <andi@firstfloor.org>
Cc: Karl MacMillan <kmacmill@redhat.com>,
       David Safford <safford@watson.ibm.com>,
       James Morris <jmorris@namei.org>, John Johansen <jjohansen@suse.de>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <p73abx66fme.fsf@bingen.suse.de>
References: <20070416213350.GB4030@suse.de>
	 <Line.LNX.4.64.0704161846110.13905@d.namei>
	 <1176822230.3366.65.camel@localhost.localdomain>
	 <1176825641.5946.41.camel@localhost.localdomain>
	 <p73abx66fme.fsf@bingen.suse.de>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 19 Apr 2007 13:46:30 -0400
Message-Id: <1177004790.27654.147.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-17 at 20:05 +0200, Andi Kleen wrote:
> Karl MacMillan <kmacmill@redhat.com> writes:
>  
> > No - the real fix is to change the applications or to run under a policy
> > that confines all applications. Most of the problems with resolv.conf,
> > mtab, etc. stem from admin processes (e.g., editors or shell scripts)
> > all running under the same unconfined domain.
> > 
> > In some cases applications need modification as only the application has
> > enough information to determine the correct label. Usually this means
> > preserving labels from input files or separating the output into
> > distinct directories so type transitions or label inheritance will work.
> > 
> > restorecond is just a hack not a requirement or a sign that something is
> > wrong with the model. That is why it is a userspace application and not
> > integrated into the kernel mechanism.
> 
> You nicely show one of the major disadvantages of the label model vs the path 
> model here: it requires modification of a lot of applications. 

It is true that many applications that already deal with mode bits need
to become aware of labels, just as with ACLs, and that this makes it a
bit harder and slower to roll out something that is label-based.  But
the right solution is rarely quick and easy, and a lot of work has
already happened to integrate such support into userland.

To look at it in a slightly different way, the AA emphasis on not
modifying applications could be viewed as a limitation.  Ultimately,
users have security goals that go beyond just what the OS can directly
enforce and at least some applications (notably things like X, D-BUS,
PostgreSQL, etc) need to likewise support strong domain separation and
controlled information flow through their own internal objects and
operations.  SELinux provides APIs and infrastructure for such
applications, and has already done quite a bit of work in that space
(D-BUS support, XACE/XSELinux, SE-PostgreSQL), whereas AA seems to have
no interest in going there (and would have to recant its emphasis on no
application mods to do so).  If you actually want to truly confine a
desktop application, you can't limit yourself to the kernel.  And the
label model provides a unifying abstraction for dealing with all of
these various objects, whereas the path/"natural abstraction" model has
no unifying abstraction at all.

-- 
Stephen Smalley
National Security Agency

