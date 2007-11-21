Return-Path: <linux-kernel-owner+w=401wt.eu-S1757253AbXKUREX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbXKUREX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 12:04:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755403AbXKUREP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 12:04:15 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44788 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755499AbXKUREO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 12:04:14 -0500
Date: Wed, 21 Nov 2007 11:04:11 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       casey@schaufler-ca.com, chrisw@sous-sol.org, darwish.07@gmail.com,
       jmorris@namei.org, method@manicmethod.com, morgan@kernel.org,
       paul.moore@hp.com
Subject: Re: +
	smack-version-11c-simplified-mandatory-access-control-kernel.patch
	added to -mm tree
Message-ID: <20071121170411.GA8511@sergelap.austin.ibm.com>
References: <200711202206.lAKM6BlW025868@imap1.linux-foundation.org> <20071121154849.GA7195@sergelap.austin.ibm.com> <1195660319.759.50.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1195660319.759.50.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Smalley (sds@tycho.nsa.gov):
> On Wed, 2007-11-21 at 09:48 -0600, Serge E. Hallyn wrote:
> > Quoting akpm@linux-foundation.org (akpm@linux-foundation.org):
> > > +/*
> > > + * There are not enough CAP bits available to make this
> > > + * real, so Casey borrowed the capability that looks to
> > > + * him like it has the best balance of similarity amd
> > > + * low use.
> > > + */
> > > +#define CAP_MAC_OVERRIDE CAP_LINUX_IMMUTABLE
> > 
> > Hey Casey,
> > 
> > note that 64-bit capabilities are now in -mm, so you could grab your own
> > capability.
> 
> Which brings up an interesting question - what to do with
> security-module-specific capabilities?  CAP_MAC_OVERRIDE is specific to
> Smack - other MAC modules like SELinux won't honor it.  Maybe it should
> be CAP_SMACK_OVERRIDE.

Yeah, I was thinking it would be renamed to something smack-specific.
The concept of CAP_MAC_OVERRIDE is pretty general, but then users may
for just that reason expect the capability to also let them override
selinux and other capabilities.

For instance the capabilities equivalent to a CAP_MAC_OVERRIDE would
probably be CAP_SETPCAP, since it can be used to add capabilities back
into your inheritable set.  But we wouldn't want to share one capability
for CAP_SETPCAP and CAP_SMACK_OVERRIDE.  CAP_SETPCAP does let you regain
CAP_SMACK_OVERRIDE, but a process could have CAP_SMACK_OVERRIDE but be
denied CAP_NET_ADMIN for instance, or heck even CAP_DAC_OVERRIDE.

So short answer is: I agree :)

thanks,
-serge
