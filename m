Return-Path: <linux-kernel-owner+w=401wt.eu-S932722Ab0AGAjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722Ab0AGAjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 19:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932410Ab0AGAjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 19:39:18 -0500
Received: from ozlabs.org ([203.10.76.45]:57096 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755888Ab0AGAjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 19:39:17 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Rientjes <rientjes@google.com>
Subject: Re: [patch 6/6] x86: cpumask_of_node() should handle -1 as a node
Date: Thu, 7 Jan 2010 11:09:10 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-16-generic; KDE/4.3.2; i686; ; )
Cc: Anton Blanchard <anton@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org
References: <20100106045509.245662398@samba.org> <20100106233151.GC12742@kryten> <alpine.DEB.2.00.1001061545210.19882@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1001061545210.19882@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001071109.10362.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jan 2010 10:21:06 am David Rientjes wrote:
> On Thu, 7 Jan 2010, Anton Blanchard wrote:
> 
> > I don't like the use of -1 as a node, but it's much more widespread than
> > x86; including sh, powerpc, sparc and the generic topology code. eg:
> > 
> > 
> > #fdef CONFIG_PCI
> > extern int pcibus_to_node(struct pci_bus *pbus);
> > #else
> > static inline int pcibus_to_node(struct pci_bus *pbus)
> > {
> >         return -1;
> > }
> 
> This seems to be the same semantics that NUMA_NO_NODE was defined for, 
> it's not necessarily a special case.

It's widespread, and we've just had another bug due to pcibus_to_node handling
-1 and cpumask_of_node not.  (Search lkml for subject "[Regression] 2.6.33-rc2
 - pci: Commit e0cd516 causes OOPS").

So I think the evidence is in favor of just handling -1.

Cheers,
Rusty.
