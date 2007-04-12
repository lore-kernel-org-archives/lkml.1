Return-Path: <linux-kernel-owner+w=401wt.eu-S1161607AbXDLMXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161607AbXDLMXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 08:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161603AbXDLMXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 08:23:01 -0400
Received: from neon.samage.net ([85.17.153.66]:42892 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161602AbXDLMW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 08:22:59 -0400
Message-ID: <3630.81.207.0.53.1176380573.squirrel@secure.samage.net>
In-Reply-To: <a781481a0704120235q34d047c8q350b0ed29cde9f0f@mail.gmail.com>
References: <4610D25F.7080005@ceid.upatras.gr>
    <p73r6r3yn9f.fsf@bingen.suse.de> <4610EDF9.9000601@sciensis.com>
    <4616BC09.2080509@tmr.com>
    <4152.81.207.0.53.1175900790.squirrel@secure.samage.net>
    <461715B4.9060701@tmr.com> <009501c77c22$2b4960f0$0864a8c0@scs1>
    <1349.81.207.0.53.1176302225.squirrel@secure.samage.net>
    <000401c77cdd$5ef79910$0864a8c0@scs1>
    <a781481a0704120235q34d047c8q350b0ed29cde9f0f@mail.gmail.com>
Date: Thu, 12 Apr 2007 14:22:53 +0200 (CEST)
Subject: Re: [PATCH resend][CRYPTO]: RSA algorithm patch
From: "Indan Zupancic" <indan@nul.nu>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Cc: "Tasos Parisinos" <t.parisinos@sciensis.com>,
       "Bill Davidsen" <davidsen@tmr.com>, "Andi Kleen" <andi@firstfloor.org>,
       herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: d58e29c6f4e42f76447094ef3ccb23d2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, April 12, 2007 11:35, Satyam Sharma wrote:
> Firstly, I'd like to steer clear of all the RSA-in-kernel-or-userspace
> / MPI-in-kernel-or-userspace arguments. True, MPI / RSA / (PKI? that
> even requires some knowledge of ASN.1 etc to parse certificates) do
> add a lot of bloat to the kernel. That said, I don't see any other
> reason to _not_ do asymmetric crypto in the kernel either. In some
> situations, that in fact simplifies the overall system by avoiding the
> use of additional userspace components / daemons to do the key
> management stuff.

Because it can all be done in userspace? Can trap all binary loading from
user-space too, though that must be done carefully, without changing the
kernel.

> 1. First, sorry, I don't think an RSA implementation not conforming to
> PKCS #1 qualifies to be called RSA at all. That is definitely a *must*
> -- why break strong crypto algorithms such as RSA by implementing them
> in insecure ways?

It's still RSA, that it's not enough to get a complete and secure crypto
system doesn't mean it isn't RSA anymore. Maybe you're right and having
RSA without the rest makes no sense. But things like padding schemes change,
the core RSA algorithm does't, so I think when adding anything that's unused
by the rest of the kernel it has more chance if it's a low maintenance bare
RSA implementation.


> 3. Please, try to re-use the MPI library from GnuPG that has already
> been ported to the kernel -- not the mainline tree, but most
> distributions such as Red Hat, Fedora, Debian, Suse(?) have maintained
> an MPI library in crypto/ for the modsign stuff for years now -- that
> would make your entire RSA module merely a set of wrappers
> (implementing PKCS#1) to the core modular exponentiation functions in
> that MPI library. It also contains implementations of optimized
> algorithms for a lot of the mathematics involved, so you have only to
> benefit from utilizing a library that has been used, maintained and
> tested for years.

Right, and that MPI implementation isn't merged. Perhaps a smaller, simpler,
not complexified by optimisations version has more chance. RSA is damn slow
anyway, so better to concentrate on other things than speed, IMHO.

That said, perhaps the different groups could concentrate on one implementation
they all agree on? That's the main advantage of having it mainline, that there's
a common place to cencentrate all effort into.

But keep in mind that it's a precaurious balance, at least that's how I see it.
Right now it's about a rather static 800 lines of code which implements some
common algorithms. Not much bloat, low maintenance, over all not much reason
to not merge it, except that it isn't used by the rest of the kernel.

If you're going to add the full kitchen sink, it might not look that appealing
anymore, and merging it will become much harder, especially as no one provided
good arguments why it can't be done in user space.

Perhaps, with that in mind, it's better to not merge the bare RSA version either,
as it might give false hope for more, because it looks like most implementations
should be done in user space (either because that's better anyway, or because of
legal reasons).

Greetings,

Indan


