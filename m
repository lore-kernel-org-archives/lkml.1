Return-Path: <linux-kernel-owner+w=401wt.eu-S1753439AbXJALdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbXJALdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 07:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628AbXJALdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 07:33:17 -0400
Received: from namei.org ([69.55.235.186]:36866 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751453AbXJALdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 07:33:16 -0400
Date: Mon, 1 Oct 2007 04:33:05 -0700 (PDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Andrew Morton <akpm@linux-foundation.org>
cc: casey@schaufler-ca.com, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access
 Control Kernel
In-Reply-To: <20070930011618.ccb8351b.akpm@linux-foundation.org>
Message-ID: <Xine.LNX.4.64.0710010146100.13671@us.intercode.com.au>
References: <46FEEBD4.5050401@schaufler-ca.com> <20070930011618.ccb8351b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Sep 2007, Andrew Morton wrote:

> So with the information which I presently have available to me, I'm
> thinking that this should go into 2.6.24.

I think the decision to merge Smack is something that needs to be 
considered in the wider context of overall security architecture.

Smack itself looks fine.  It seems like clean code with interesting ideas, 
and appears to be based upon sound principles.

Merging Smack, however, would lock the kernel into the LSM API.  
Presently, as SELinux is the only in-tree user, LSM can still be removed.

LSM's weak semantics and pervasive deep hooking of the kernel means that 
we'll have to continue dealing with several unpleasant issues, such as the 
abuse of the API by out of tree vendors, with a proliferation of 
binary/proprietary modules which typically maladapt the API for arbitrary 
purposes and/or use dangerous techniques.  We will continue to waste 
resources maintaining this capability for them.

On a broader scale, we'll miss the potential of Linux having a coherent, 
semantically strong security architecture. I have written about this in 
some detail before: http://lwn.net/Articles/240019/

Briefly, SELinux is a security architecture.  It provides an extremely 
high degree of flexibility, in terms of both the types of security models 
implemented, and security policy for those models.  It allows controlled 
composition of different security models, with a common policy language 
framework, allowing the entire system to be analyzed.  The same ideas and 
even code can be reused beyond the kernel as post-DAC security is extended 
into databases, the desktop, distributed applications etc.  It is a 
framework which provides a structured, coherent view of the security of 
the OS (and ultimately, the entire distributed environment).

If LSM remains, security will never be a first class citizen of the 
kernel.  Application developers will see multiple security schemes, and 
either burn themselves trying to support them, or more likely, ignore 
them.
 
Core kernel developers will continue to not have enough information to 
understand what the LSM hooks in their code are supposed to be doing, 
leading to long term maintenance issues and potential security problems.

LSM will remain a magnet for bad ideas.  There's a reason we don't have 
pluggable network stacks, and we are lucky to have had a unified 
networking framework maintained by people who know to say no to things 
like STREAMS and TOE.  I would question whether this quality of 
maintainership would exist if the networking core was simply a bunch of 
deep hooks into which people dumped arbitrary custom stacks.

LSM will prevent us from making systemic improvements to security, as 
there will be no common security architecture.  Things like Netfilter 
would not have been viable with a kernel which simply provided a bunch of 
hooks for networking stacks and an assortment of implementations.

Much of this we have learned from the experience of LSM, and I think it 
has been valuable for that, but I think we need to consider now whether we 
are going to continue down this track in a permanent manner.


- James
-- 
James Morris
<jmorris@namei.org>
