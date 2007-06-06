Return-Path: <linux-kernel-owner+w=401wt.eu-S933423AbXFFMNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933423AbXFFMNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 08:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758645AbXFFMND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 08:13:03 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:37429 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762470AbXFFMNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 08:13:01 -0400
Subject: Re: [PATCH] Protection for exploiting null dereference using mmap
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, Alan Cox <alan@redhat.com>, drepper@redhat.com,
       roland@redhat.com, arjan@infradead.org, mingo@elte.hu,
       viro@zeniv.linux.org.uk, jmorris@namei.org, chrisw@redhat.com,
       sgrubb@redhat.com
In-Reply-To: <20070605225302.GE3723@sequoia.sous-sol.org>
References: <1180561713.3633.27.camel@dhcp231-215.rdu.redhat.com>
	 <20070603205653.GE25869@devserv.devel.redhat.com>
	 <1180964306.14220.34.camel@moss-spartans.epoch.ncsc.mil>
	 <1181075666.3978.31.camel@localhost.localdomain>
	 <20070605225302.GE3723@sequoia.sous-sol.org>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 06 Jun 2007 08:12:32 -0400
Message-Id: <1181131952.3699.0.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-05 at 15:53 -0700, Chris Wright wrote:
> * Eric Paris (eparis@redhat.com) wrote:
> > One result of using the dummy hook for non-selinux kernels means that I
> > can't leave the generic module stacking code in the SELinux check.  If
> > the secondary ops are called they will always deny the operation just
> > like in non-selinux systems even if SELinux policy would have allowed
> > the action.  This patch may be the first step to removing the arbitrary
> > LSM module stacking code from SELinux.  I think history has shown the
> > arbitrary module stacking is not a good idea and eventually I want to
> > pull out all the secondary calls which aren't used by the capability
> > module, so I view this as just the first step along those lines.
> 
> Or replace them all with direct library calls to the capability code.

The only tricky part there is retaining the support for falling back on
capabilities upon runtime disable of selinux by /sbin/init.

-- 
Stephen Smalley
National Security Agency

