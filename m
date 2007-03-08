Return-Path: <linux-kernel-owner+w=401wt.eu-S1752381AbXCHSBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbXCHSBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 13:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752382AbXCHSBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 13:01:48 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:50232 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbXCHSBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 13:01:47 -0500
Date: Thu, 8 Mar 2007 12:01:36 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       safford@watson.ibm.com, serue@linux.vnet.ibm.com,
       kjhall@linux.vnet.ibm.com, zohar@us.ibm.com
Subject: Re: [RFC][Patch 2/6] integrity: fs hook placement
Message-ID: <20070308180136.GB21099@sergelap.austin.ibm.com>
References: <1173369812.5981.2.camel@localhost.localdomain> <20070308164132.GL6602@sequoia.sous-sol.org> <20070308170733.GA21099@sergelap.austin.ibm.com> <20070308174036.GF10574@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070308174036.GF10574@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Chris Wright (chrisw@sous-sol.org):
> * Serge E. Hallyn (serue@us.ibm.com) wrote:
> > Are you objecting only to the duplication at the callsites, so that an
> > fsnotify-type of consolidation of security and integrity hooks would be
> > ok?  Or are you complaining that the security_inode_setxattr and
> > integrity_inode_setxattr hooks are too similar anyway, and integrity
> > modules should just use some lsm hooks for anything which will be
> > authoritative?
> 
> It's duplication of callsites with many identical implementations
> that's the problem.

Yes it's ugly...

But I guess it gets a point across :)

> > (I could see an argument that integirty subsystem should be purely for
> > measuring and hence its hooks should never return a value.  Only hitch
> > there is that if integrity subsystem hits ENOMEM it should be able to
> > refuse the action...)
> 
> Right, that's what I was expecting to see, just the measurement
> infrastructure.

So what you are saying is EVM would stay an LSM, with a cooperating
integrity subsystem *just* doing measurements?

That's kind of what i was expecting too, however that doesn't fit as
well with the idea that an integrity subsystem prevents the need for lsm
stacking.  I think the idea was that evm would still be able to enforce
integrity of selinux xattrs without it stack with selinux.  So I can see
where this approach came from.

-serge
