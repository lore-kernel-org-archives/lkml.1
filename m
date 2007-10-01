Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbXJAPjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbXJAPjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 11:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbXJAPjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 11:39:03 -0400
Received: from web36601.mail.mud.yahoo.com ([209.191.85.18]:31210 "HELO
	web36601.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751661AbXJAPjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 11:39:00 -0400
X-YMail-OSG: OnZOYbIVM1nC_gVRflo9GAAK_6h4Va5LXYQHL83qvhj9Zauj_GfwUXfGfuwL79U.mnM3fHo7iTmi7DmOxiVmFpA6oWXtlpLZLwVNoXauygkXnhJ9Tfc-
X-RocketYMMF: rancidfat
Date: Mon, 1 Oct 2007 08:38:59 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
To: James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: casey@schaufler-ca.com, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <Xine.LNX.4.64.0710010146100.13671@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <820574.62101.qm@web36601.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- James Morris <jmorris@namei.org> wrote:

> On Sun, 30 Sep 2007, Andrew Morton wrote:
> 
> > So with the information which I presently have available to me, I'm
> > thinking that this should go into 2.6.24.
> 
> I think the decision to merge Smack is something that needs to be 
> considered in the wider context of overall security architecture.

Please recall the reason that we have LSM. It is so that Linus
does not have to listen to the arguments over security architecture.

> Smack itself looks fine.  It seems like clean code with interesting ideas, 
> and appears to be based upon sound principles.

Thank you.

> Merging Smack, however, would lock the kernel into the LSM API.  
> Presently, as SELinux is the only in-tree user, LSM can still be removed.

Ah, the nut of the issue. What follows then is the argument that
SELinux should be the official security architecture of Linux.
I disagree (like you hadn't figured that out) with this position.

> LSM's weak semantics and pervasive deep hooking of the kernel means that 
> we'll have to continue dealing with several unpleasant issues, such as the 
> abuse of the API by out of tree vendors,

Pulling LSM might slow a small set of abusers, but it wouldn't solve the
problem, what with well documented VFS and driver layers available.

> with a proliferation of 
> binary/proprietary modules which typically maladapt the API for arbitrary 
> purposes and/or use dangerous techniques.  We will continue to waste 
> resources maintaining this capability for them.

HeHe. I recall the response to some Tivoli developers when they
made a request not to long ago. I seriously doubt that they feel
the community is putting out much for them.

> On a broader scale, we'll miss the potential of Linux having a coherent, 
> semantically strong security architecture. I have written about this in 
> some detail before: http://lwn.net/Articles/240019/

Here our opinions diverge strongly. My position is that the
security architecture of SELinux is excessive in it's sophistication.
 
> Briefly, SELinux is a security architecture.  It provides an extremely 
> high degree of flexibility, in terms of both the types of security models 
> implemented, and security policy for those models.  It allows controlled 
> composition of different security models, with a common policy language 
> framework, allowing the entire system to be analyzed.  The same ideas and 
> even code can be reused beyond the kernel as post-DAC security is extended 
> into databases, the desktop, distributed applications etc.  It is a 
> framework which provides a structured, coherent view of the security of 
> the OS (and ultimately, the entire distributed environment).

None of which is new or unique to SELinux.

> If LSM remains, security will never be a first class citizen of the 
> kernel.  Application developers will see multiple security schemes, and 
> either burn themselves trying to support them, or more likely, ignore 
> them.

What is the #1 SELinux FAQ?
    "How do I turn it off?"

I'd suggest that application and system developers are perfectly
capable of making rational decisions regarding the security model
that is appropriate to their environments.

> Core kernel developers will continue to not have enough information to 
> understand what the LSM hooks in their code are supposed to be doing, 
> leading to long term maintenance issues and potential security problems.

Is that hypothetical, or do you have examples?

> LSM will remain a magnet for bad ideas.

Thanks a lot.

> There's a reason we don't have 
> pluggable network stacks, and we are lucky to have had a unified 
> networking framework maintained by people who know to say no to things 
> like STREAMS and TOE.  I would question whether this quality of 
> maintainership would exist if the networking core was simply a bunch of 
> deep hooks into which people dumped arbitrary custom stacks.

The counter argument is of course VFS and the driver interface.
I think that the file systems work pretty well. Except for the
flakey ones.

> LSM will prevent us from making systemic improvements to security, as 
> there will be no common security architecture.  Things like Netfilter 
> would not have been viable with a kernel which simply provided a bunch of 
> hooks for networking stacks and an assortment of implementations.

Unless you consider Smack a systemic improvement to security like I do.

> Much of this we have learned from the experience of LSM, and I think it 
> has been valuable for that, but I think we need to consider now whether we 
> are going to continue down this track in a permanent manner.

Why so defensive? SELinux is a fine implementation of Type Enforcement
and if you like that sort of thing I'm all for you using it. Accept that
it may not be for everyone. I certainly don't expect Smack on everyone's
machine.


Casey Schaufler
casey@schaufler-ca.com
