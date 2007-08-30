Return-Path: <linux-kernel-owner+w=401wt.eu-S1761789AbXH3CL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761789AbXH3CL0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 22:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756187AbXH3CLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 22:11:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38024 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756046AbXH3CLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 22:11:19 -0400
Date: Wed, 29 Aug 2007 19:10:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Rusty Russell <rusty@rustcorp.com.au>, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org, mattilinnanvuori@yahoo.com
Subject: Re: [Bugme-new] [Bug 8957] New: Exported functions and variables
 should not be reachable by the outside of the module until module_init
 finishes
Message-Id: <20070829191043.91616ca7.akpm@linux-foundation.org>
In-Reply-To: <46D61E7C.20304@shaw.ca>
References: <fa.fGbKfAxvHbZD1OUm5bpknraMlkQ@ifi.uio.no>
	<fa.+esfGGdgETnuZiuGXcL9U8IpoNM@ifi.uio.no>
	<46D61E7C.20304@shaw.ca>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Aug 2007 19:33:48 -0600 Robert Hancock <hancockr@shaw.ca> wrote:

> Andrew Morton wrote:
> > On Wed, 29 Aug 2007 11:33:06 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:
> > 
> >> http://bugzilla.kernel.org/show_bug.cgi?id=8957
> >>
> >>            Summary: Exported functions and variables should not be reachable
> >>                     by the outside of the module until module_init finishes
> >>            Product: Other
> >>            Version: 2.5
> >>      KernelVersion: 2.6.23-rc4
> >>           Platform: All
> >>         OS/Version: Linux
> >>               Tree: Mainline
> >>             Status: NEW
> >>           Severity: normal
> >>           Priority: P1
> >>          Component: Modules
> >>         AssignedTo: other_modules@kernel-bugs.osdl.org
> >>         ReportedBy: mattilinnanvuori@yahoo.com
> >>
> >>
> >> Problem Description: a module's exported functions can be called before before
> >> they are properly initialized by the module_init function.
> >>
> >> Steps to reproduce: write a module that exports functions that require
> >> initialization by the module_init function to work correctly.
> >>
> >> E.g. spin lock variables are no longer allowed to be initialized by C
> >> initializers of the module but only by spin_lock_init that can be called by the
> >> module_init function. If an exported function calls spin_lock before it is
> >> initialized, it deadlocks.
> >>
> > 
> > ooh, nice bug ;)
> 
> Under what circumstances is this actually happening? What are these 
> functions that are being called?
> 
> Normally things are set up such that this isn't a problem, i.e. if 
> module A depends on module B, module A can't load until module B is 
> finished loading.
> 

Good point.

This thus-far-undescribed module could make its internals externally
visible via one of the kernel's many register_foo() interfaces, but it
would be a buggy module if it was doing register_foo(my_foo) before
my_foo() was ready to be called.
