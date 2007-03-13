Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272AbXCMPi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbXCMPi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 11:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbXCMPi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 11:38:28 -0400
Received: from smtp114.sbc.mail.mud.yahoo.com ([68.142.198.213]:44437 "HELO
	smtp114.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753272AbXCMPi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 11:38:26 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Mar 2007 11:38:26 EDT
X-YMail-OSG: sfml3O8VM1l8EsUsYDSW6ElRAr_kX5q1qoseXZ5W_JyObLPEX0lLPmIkIfMRIq4PzSqDV1WKzB19xTnmqfQ.DOuJ3a2DmqcTBuwgzECJVvJBLpfqH.7xaZSqDoLD0sv0_14AfcMnyXIysRuv05..1W0Elw--
Date: Tue, 13 Mar 2007 10:31:31 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Valdis.Kletnieks@vt.edu, linux-security-module@vger.kernel.org,
       safford@watson.ibm.com, serue@linux.vnet.ibm.com,
       kjhall@linux.vnet.ibm.com, zohar@us.ibm.com,
       linux-kernel@vger.kernel.org, disec-devel@lists.sourceforge.net,
       selinux@tycho.nsa.gov
Subject: Re: [RFC] [Patch 1/1] IBAC Patch
Message-ID: <20070313153131.GB29812@vino.hallyn.com>
References: <1173394696.5981.12.camel@localhost.localdomain> <200703090319.l293JrpC009714@turing-police.cc.vt.edu> <1173736041.5803.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173736041.5803.3.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Mimi Zohar (zohar@linux.vnet.ibm.com):
> On Thu, 2007-03-08 at 22:19 -0500, Valdis.Kletnieks@vt.edu wrote:
> > On Thu, 08 Mar 2007 17:58:16 EST, Mimi Zohar said:
> > > This is a request for comments for a new Integrity Based Access
> > > Control(IBAC) LSM module which bases access control decisions
> > > on the new integrity framework services. 
> > > 
> > > (Hopefully this will help clarify the interaction between an LSM 
> > > module and LIM module.)
> > 
> > OK, between this and the additional LIM hooks I didn't notice in an earlier
> > patch, we're starting to see the API.   The only problem is that although
> > it may be the right API for *your* code, I suspect it's a non-starter without
> > a discussion about whether it's the right *generic* API for an LIM (which will
> > require at least one dramatic bun fight about what "Integrity" means).
> 
> Absolutely, we need to make sure that the set of LIM hooks is complete and that
> nothing is missing in order to implement different types of LIM providers.  I'm 
> copying the digsig mailing list for their input on requirements, which this API 
> might not satisfy or perhaps address.

(Could you resend the IBAC patch to the disec list as well?)

Is IBAC basically a 'demo' lsm?  It only hooks bprm_security, so you
can't execute anything with a bad hash, right?  So really if you were to
also hook mmap, this would completely do away with the need for digsig?
IBAC is automatically able to use any integrity measurement modules you
write, whether they use gpg like digsig does right now, or use the tpm?

It also shows how simple it would be to hook selinux, though I guess
there are several ways we might want to hook selinux - 1. to check only
security.selinux xattrs, 2. to check integrity of entry point types, 3.
to check integrity of any files labeled by the integrity measurement
module as needing to be checked.

Is there any way for the LSM itself to direct which data and metadata
will be measured?  It looks like this is done by separately configuring
the integrity measurement module - which seems fine to me.

-serge
