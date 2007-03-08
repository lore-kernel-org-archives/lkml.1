Return-Path: <linux-kernel-owner+w=401wt.eu-S933133AbXCHVHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133AbXCHVHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 16:07:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933327AbXCHVHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 16:07:07 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:44846 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933133AbXCHVHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 16:07:04 -0500
Date: Thu, 8 Mar 2007 15:07:00 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       safford@watson.ibm.com, serue@linux.vnet.ibm.com,
       kjhall@linux.vnet.ibm.com, zohar@us.ibm.com
Subject: Re: [RFC][Patch 2/6] integrity: fs hook placement
Message-ID: <20070308210700.GB2750@sergelap.austin.ibm.com>
References: <1173369812.5981.2.camel@localhost.localdomain> <20070308164132.GL6602@sequoia.sous-sol.org> <20070308170733.GA21099@sergelap.austin.ibm.com> <20070308174036.GF10574@sequoia.sous-sol.org> <20070308180136.GB21099@sergelap.austin.ibm.com> <1173381749.3241.41.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173381749.3241.41.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Smalley (sds@tycho.nsa.gov):
> On Thu, 2007-03-08 at 12:01 -0600, Serge E. Hallyn wrote:
> > Quoting Chris Wright (chrisw@sous-sol.org):
> > > * Serge E. Hallyn (serue@us.ibm.com) wrote:
> > > > Are you objecting only to the duplication at the callsites, so that an
> > > > fsnotify-type of consolidation of security and integrity hooks would be
> > > > ok?  Or are you complaining that the security_inode_setxattr and
> > > > integrity_inode_setxattr hooks are too similar anyway, and integrity
> > > > modules should just use some lsm hooks for anything which will be
> > > > authoritative?
> > > 
> > > It's duplication of callsites with many identical implementations
> > > that's the problem.
> > 
> > Yes it's ugly...
> > 
> > But I guess it gets a point across :)
> > 
> > > > (I could see an argument that integirty subsystem should be purely for
> > > > measuring and hence its hooks should never return a value.  Only hitch
> > > > there is that if integrity subsystem hits ENOMEM it should be able to
> > > > refuse the action...)
> > > 
> > > Right, that's what I was expecting to see, just the measurement
> > > infrastructure.
> > 
> > So what you are saying is EVM would stay an LSM, with a cooperating
> > integrity subsystem *just* doing measurements?
> > 
> > That's kind of what i was expecting too, however that doesn't fit as
> > well with the idea that an integrity subsystem prevents the need for lsm
> > stacking.  I think the idea was that evm would still be able to enforce
> > integrity of selinux xattrs without it stack with selinux.  So I can see
> > where this approach came from.
> 
> The enforcement mechanism should be directly integrated into SELinux,
> not stacked as a separate module.

And a big plus of splitting it up as I was describing is that anyone
who wanted could make use of the measurement module to add such
functionality to SELinux, as an alternative to the EVM LSM module.

-serge
