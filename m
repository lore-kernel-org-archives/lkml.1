Return-Path: <linux-kernel-owner+w=401wt.eu-S1756556AbYBDQpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbYBDQpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 11:45:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756145AbYBDQpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 11:45:25 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43506 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756219AbYBDQpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 11:45:24 -0500
Date: Mon, 4 Feb 2008 10:45:24 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: Ismail D??nmez <ismail@pardus.org.tr>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>,
       linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH] per-process securebits
Message-ID: <20080204164524.GC20130@sergelap.ibm.com>
References: <47A2D439.9050704@kernel.org> <200802030825.49221.ismail@pardus.org.tr> <47A66119.90702@kernel.org> <200802040254.50444.ismail@pardus.org.tr> <47A6661D.7020305@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A6661D.7020305@kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew G. Morgan (morgan@kernel.org):
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Ismail D??nmez wrote:
> | What I meant to ask was what does "per-process securebits" brings as
> extra.
>
> It allows you to create a legacy free process tree. For example, a
> chroot, or container (which Serge can obviously explain in more detail),

(Just to give my thoughts on securebits and containers)

A container is a set of processes which has its own private namespaces
for all or most resources - for instance it sees only processes in its
own pid namespace, and its first process, which is sees as pid 1, is
known as some other pid, maybe 3459, to the rest of the system.

We tend to talk about 'system containers' versus 'application
containers'.  A system container would be like a vserver or openvz
instance, something which looks like a separate machine.  I was
going to say I don't imagine per-process securebits being useful
there, but actually since a system container doesn't need to do any
hardware setup it actually might be a much easier start for a full
SECURE_NOROOT distro than a real machine.  Heck, on a real machine init
and a few legacy deamons could run in the init namespace, while users
log in and apache etc run in a SECURE_NOROOT container.

But I especially like the thought of for instance postfix running in a
carefully crafted application container (with its own virtual network
card and limited file tree and no visibility of other processes) with
SECURE_NOROOT on.

-serge

> environment in which root has no privilege at all. One in which
> privilege comes only from filesystem capabilities.
>
> | FWIW in Pardus 2008 we'll enable Posix file capabilities by default so
> people
> | could "harden" their setups.

Cool.  Be good to see how that goes.  I'm curious about what conceptual
hurdles there might be for sysadmins configuring libpam to exploit
fI+pI.

thanks,
-serge

>
> Cheers
>
> Andrew
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.2.6 (GNU/Linux)
>
> iD8DBQFHpmYd+bHCR3gb8jsRAlDHAJ9RvFRieU2eUPJUHh7K84NMLmytTQCgupfS
> KxdoXz400AeMWJiaikGH9U8=
> =yx8I
> -----END PGP SIGNATURE-----
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
