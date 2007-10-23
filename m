Return-Path: <linux-kernel-owner+w=401wt.eu-S1752792AbXJWPeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbXJWPeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 11:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbXJWPeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 11:34:12 -0400
Received: from smtp114.sbc.mail.re2.yahoo.com ([68.142.229.91]:21149 "HELO
	smtp114.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752138AbXJWPeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 11:34:12 -0400
X-YMail-OSG: dfJEmf4VM1nSMBdHLXOKXDnoFsm6j3AcbWwRntEOTZosGVAsUgLGE5iRE8QXUhK.JgsPtlCUxVfScAcvGUnx.WnvdpgXDpXboKaTt9QPb7iNKGDWrbrUDghupU.ijctuTdMNQ.GQTum9iQ--
Date: Tue, 23 Oct 2007 10:34:09 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Giacomo Catenazzi <cate@debian.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>
Subject: Re: LSM conversion to static interface
Message-ID: <20071023153409.GA14215@vino.hallyn.com>
References: <167451.96128.qm@web38607.mail.mud.yahoo.com> <alpine.LFD.0.999.0710171913270.26902@woody.linux-foundation.org> <200710192226.53233.agruen@suse.de> <alpine.LFD.0.999.0710191336250.26902@woody.linux-foundation.org> <Pine.LNX.4.64.0710201255170.1997@fbirervta.pbzchgretzou.qr> <471D8A4C.3020101@debian.org> <Pine.LNX.4.64.0710231051090.16684@fbirervta.pbzchgretzou.qr> <20071023152005.GA13767@vino.hallyn.com> <Pine.LNX.4.64.0710231725550.16684@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710231725550.16684@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Jan Engelhardt (jengelh@computergmbh.de):
> 
> On Oct 23 2007 10:20, Serge E. Hallyn wrote:
> >
> >Once the per-process capability bounding set is accepted
> >(http://lkml.org/lkml/2007/10/3/315) you will be able to do something
> >like:
> >
> >	1. Create user 'jdoe' with uid 0
> 
> UID 0 is _not_ acceptable for me.

I'm aware.

> >	2. write a pam module which, when jdoe logs in, takes
> >	   CAP_NET_ADMIN out of his capability bounding set
> >	3. Now jdoe can log in with the kind of capabilities subset
> >	   you describe.
> 
> It is not that easy.
> CAP_DAC_OVERRIDE is given to the subadmin to bypass the pre-security
> checks in kernel code, and then the detailed implementation of
> limitation is done inside multiadm.

You mean the read/write split?

> This is not just raising or lowering capabilities.

Nope, but it's related, and as I pointed out below it fits in pretty
nicely.

> >It's not a perfect solution, since it doesn't allow jdoe any way at all
> >to directly execute a file with more caps (setuid and file capabilities
> >are subject to the capbound).  So there is certainly still a place for
> >multiadm.
> 
> A normal user can execute suid binaries today, and so can s/he with mtadm.
> I do not see where that will change - it does not need any caps atm.

And he will still be able to *run* the suid binary, but if cap_bound is
reduced he won't be able to use capabilities taken out of the bounding
set, multiadm loaded or not.

-serge
