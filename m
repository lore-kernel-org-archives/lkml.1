Return-Path: <linux-kernel-owner+w=401wt.eu-S933168AbXCHT2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168AbXCHT2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 14:28:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933174AbXCHT2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 14:28:48 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:56037 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933168AbXCHT2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 14:28:47 -0500
Subject: Re: [RFC][Patch 2/6] integrity: fs hook placement
From: Stephen Smalley <sds@tycho.nsa.gov>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Chris Wright <chrisw@sous-sol.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, kjhall@linux.vnet.ibm.com, zohar@us.ibm.com
In-Reply-To: <20070308180136.GB21099@sergelap.austin.ibm.com>
References: <1173369812.5981.2.camel@localhost.localdomain>
	 <20070308164132.GL6602@sequoia.sous-sol.org>
	 <20070308170733.GA21099@sergelap.austin.ibm.com>
	 <20070308174036.GF10574@sequoia.sous-sol.org>
	 <20070308180136.GB21099@sergelap.austin.ibm.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 08 Mar 2007 14:22:29 -0500
Message-Id: <1173381749.3241.41.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-08 at 12:01 -0600, Serge E. Hallyn wrote:
> Quoting Chris Wright (chrisw@sous-sol.org):
> > * Serge E. Hallyn (serue@us.ibm.com) wrote:
> > > Are you objecting only to the duplication at the callsites, so that an
> > > fsnotify-type of consolidation of security and integrity hooks would be
> > > ok?  Or are you complaining that the security_inode_setxattr and
> > > integrity_inode_setxattr hooks are too similar anyway, and integrity
> > > modules should just use some lsm hooks for anything which will be
> > > authoritative?
> > 
> > It's duplication of callsites with many identical implementations
> > that's the problem.
> 
> Yes it's ugly...
> 
> But I guess it gets a point across :)
> 
> > > (I could see an argument that integirty subsystem should be purely for
> > > measuring and hence its hooks should never return a value.  Only hitch
> > > there is that if integrity subsystem hits ENOMEM it should be able to
> > > refuse the action...)
> > 
> > Right, that's what I was expecting to see, just the measurement
> > infrastructure.
> 
> So what you are saying is EVM would stay an LSM, with a cooperating
> integrity subsystem *just* doing measurements?
> 
> That's kind of what i was expecting too, however that doesn't fit as
> well with the idea that an integrity subsystem prevents the need for lsm
> stacking.  I think the idea was that evm would still be able to enforce
> integrity of selinux xattrs without it stack with selinux.  So I can see
> where this approach came from.

The enforcement mechanism should be directly integrated into SELinux,
not stacked as a separate module.

-- 
Stephen Smalley
National Security Agency

