Return-Path: <linux-kernel-owner+w=401wt.eu-S1756406AbZDNVLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbZDNVLo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 17:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbZDNVLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 17:11:31 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:33357 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292AbZDNVLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 17:11:31 -0400
Subject: Re: [PATCH 00/30] C/R OpenVZ/Virtuozzo style
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       hch@infradead.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, mingo@elte.hu
In-Reply-To: <20090414204912.GA28458@x200.localdomain>
References: <20090410023207.GA27788@x200.localdomain>
	 <1239340031.24083.21.camel@nimitz>
	 <20090413091423.GA19236@x200.localdomain>
	 <49E4108A.8050201@cs.columbia.edu>
	 <20090414145830.GA27461@x200.localdomain>
	 <49E4D115.5080601@cs.columbia.edu>
	 <20090414204912.GA28458@x200.localdomain>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 14:11:26 -0700
Message-Id: <1239743486.32604.132.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-15 at 00:49 +0400, Alexey Dobriyan wrote:
> > Going back to my example of a subtree above: what sort of security
> > issues you would have here, assuming all restart operations go via
> > the usual security checks just like syscalls, and we take special
> > care about values we allow as input, e.g. cpu debug registers etc ?
> 
> This is like asking if everything goes through correct security checks
> how will you screw something up. Everything won't go via usual security
> checks.
> 
> Just for giggles, writing exploit for localhost hole becomes easier --
> you very effectively turn off all randomization kernel does because VMA
> boundaries comes from disk.

Alexey, I think there's a bit of a misunderstanding here.  We're
proposing that whatever gets done during the restart would not be able
to elevate above the privilege level of the user doing the restart.  For
instance, a user would not be able to restart a suid application -- that
would require privilege.

In the same way, at checkpoint time, we should deny users the ability to
checkpoint things that are privileged.  We need to pay very close
attention to the kernel interfaces that we use to ensure that all the
normal security checks are observed, of course.  

There's no new hole.  A restore operation is just a pieced-together set
of operations that the user would have already been able to perform.

Again, I think this stems from some of us that think that c/r should be
used outside exclusively checkpointing whole containers.  I think we'll
find some expanded use for c/r on things that aren't strict system
containers.

-- Dave

