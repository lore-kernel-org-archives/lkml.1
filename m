Return-Path: <linux-kernel-owner+w=401wt.eu-S1750982AbXCNRwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750982AbXCNRwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 13:52:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbXCNRwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 13:52:12 -0400
Received: from smtp.osdl.org ([65.172.181.24]:47674 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbXCNRwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 13:52:11 -0400
Date: Wed, 14 Mar 2007 10:51:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
 Take 2
In-Reply-To: <1173893944.31159.60.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0703141046150.9690@woody.linux-foundation.org>
References: <20070314050819.536207642@goodmis.org>  <p73slc8863r.fsf@bingen.suse.de>
 <20070314125330.GA13168@elte.hu>  <1173879210.31159.30.camel@localhost.localdomain>
  <20070314134112.GB13486@elte.hu>  <1173883577.31159.50.camel@localhost.localdomain>
  <Pine.LNX.4.61.0703141732540.1199@yvahk01.tjqt.qr>
 <1173893944.31159.60.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Mar 2007, Steven Rostedt wrote:
> 
> That's created at build time.  But I don't see anywhere in a freshly
> cloned repo or fresh untar of the linux tarball, where there exists any
> symbolic links.

There are none.

Symlinks embedded in the source tree tend to be hard to maintain: you can 
traditionally not send patches to add/change/move/remove them, and not 
everybody can even import them at all (ie some people have been so damaged 
by CVS that they maintain their kernels in it - I'm trying my best to be a 
humanitarian and rid the world of the scourge that is CVS, but I'm not 
sure I can undo the untold mental damage wrought by it over decades of 
quiet suffering).

With git, you can track symlinks and send them as patches, but we've not 
really had a huge reason to do so. They are easy enough to generate from 
Makefiles if required, and quite often you don't really need to anyway (ie 
the "symlink" is often just a make rule, like the 

	SRCDIR := ../../../i386/kernel/cpu/cpufreq

line I quoted earlier).

So I'd rather not even start using symlinks unless there is some really 
good reason. We can continue to just use Makefiles.

		Linus
