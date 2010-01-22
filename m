Return-Path: <linux-kernel-owner+w=401wt.eu-S1753075Ab0AVQhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab0AVQhH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 11:37:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554Ab0AVQhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 11:37:05 -0500
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:50939 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab0AVQhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 11:37:03 -0500
Date: Fri, 22 Jan 2010 17:37:00 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] ftrace: unify arch_syscall_addr() implementations
Message-ID: <20100122163700.GD6412@osiris.boeblingen.de.ibm.com>
References: <1264167826-20913-1-git-send-email-vapier@gentoo.org>
 <1264170977.31321.382.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264170977.31321.382.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 22, 2010 at 09:36:17AM -0500, Steven Rostedt wrote:
> [ Added Heiko Carstens and Paul Mundt to Cc ]
> 
> On Fri, 2010-01-22 at 08:43 -0500, Mike Frysinger wrote:
> > Every arch_syscall_addr() implementation thus far is the same, so unify
> > them as a default weak in common code so more arches don't have to waste
> > time copying & pasting this simple function.  The Blackfin version is
> > going to be exactly the same.
> > 
> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> > ---
> > note: only thing that needs double checking is s390 and sparc where they
> > declared the sys_call_table as an array of ints.  considering this table
> > is supposed to be an array of function pointers, this seems like more of
> > a typo to me ...
> 
> I would not be too sure. s390 is very strange, and I would definitely
> want to get an Ack from the arch maintainers first.

It's not a typo. The syscall table on s390 contains always 32 bit pointers
since we know that the address of the function to be called is (way) below
4GB. So this saves us a few bytes.
In addition this makes syscall patching done by some security modules a
bit more difficult, since they would need to store a 64 bit pointer.
That's because we make sure that module addresses are always above 4GB.
