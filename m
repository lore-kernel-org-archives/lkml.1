Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045AbXKURVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbXKURVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 12:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbXKURVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 12:21:07 -0500
Received: from web36605.mail.mud.yahoo.com ([209.191.85.22]:40731 "HELO
	web36605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751052AbXKURVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 12:21:05 -0500
X-YMail-OSG: CDmiQVoVM1lzTQFZqkLjuu1nLFYISriSJfuvFLOej8S48FFAkAORJY8JcKfaNlQ8BoG0Rik1sw--
X-RocketYMMF: rancidfat
Date: Wed, 21 Nov 2007 09:21:04 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: + smack-version-11c-simplified-mandatory-access-control-kernel.patch added to -mm tree
To: Stephen Smalley <sds@tycho.nsa.gov>, "Serge E. Hallyn" <serue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, casey@schaufler-ca.com, chrisw@sous-sol.org,
       darwish.07@gmail.com, jmorris@namei.org, method@manicmethod.com,
       morgan@kernel.org, paul.moore@hp.com,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <1195660319.759.50.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <383368.46196.qm@web36605.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Stephen Smalley <sds@tycho.nsa.gov> wrote:

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

A proposal with merit. I'll do it.

> Which brings up an interesting question - what to do with
> security-module-specific capabilities? CAP_MAC_OVERRIDE is specific to
> Smack - other MAC modules like SELinux won't honor it.  Maybe it should
> be CAP_SMACK_OVERRIDE.

But what about the MAC modules like Smack that do honor it?
They shouldn't be using a module specific capability, so
calling it CAP_SMACK_OVERRIDE isn't right because then the
SecureWare* port would have to introduce CAP_SECUREWARE_OVERRIDE
and bam, there go all your shiny new capability values. Further,
Smack isn't what's overridden by CAP_MAC_OVERRIDE, it's the
access control check, which is not the same thing at all at all.
SELinux ignoring CAP_MAC_OVERRIDE is perfectly within the
restrictive model of the LSM. If someone ported the Trusted
Irix 4 MLS system as an LSM** having CAP_MAC_OVERRIDE wouldn't
have to allow read of higher labeled files, as the policy on that
system never allowed that, even for privileged processes.

SELinux has every right to make it's own choices regarding how
it behaves relative to any specific capability because it is
allowed to restrict access in any way it sees fit. I think that
you would get in trouble if you changed the value of a capability
on a task within the LSM, because that will impact the "usual"
access checks, but I wouldn't expect to see you doing that.
SELinux has gone in a different direction on privileged operations
than capabilities, so it's not surprising that the two schemes
don't look like they're meshing very well in this case.

----
*  SecureWare was an MLS "kit". The MLS version of HP/UX was based
   on it, and the Macintosh version got the first ever CMW evaluation.
   SELinux took many of the same design approaches as SecureWare,
   and in it's early versions bore a somewhat frightening resemblence
   to the earlier system.

** Trix4 allowed a privileged process to write lower labeled files,
   but not read higher labeled files. That way any files that got
   created "by accident" were assured to be labeled at least as high
   as the data they contained.


Casey Schaufler
casey@schaufler-ca.com
