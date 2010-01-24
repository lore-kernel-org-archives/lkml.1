Return-Path: <linux-kernel-owner+w=401wt.eu-S1753467Ab0AXKZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab0AXKZm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 05:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391Ab0AXKZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 05:25:40 -0500
Received: from THUNK.ORG ([69.25.196.29]:51083 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab0AXKZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 05:25:39 -0500
Date: Sun, 24 Jan 2010 05:25:13 -0500
From: tytso@mit.edu
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kyle Moffett <kyle@moffetthome.net>, "Frank Ch. Eigler" <fche@redhat.com>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100124102513.GB4382@thunk.org>
Mail-Followup-To: tytso@mit.edu,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Kyle Moffett <kyle@moffetthome.net>,
	"Frank Ch. Eigler" <fche@redhat.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Peter Zijlstra <peterz@infradead.org>,
	Fr??d??ric Weisbecker <fweisbec@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	linux-next@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	utrace-devel@redhat.com, Thomas Gleixner <tglx@linutronix.de>
References: <20100121170541.7425ff10.akpm@linux-foundation.org>
 <alpine.LFD.2.00.1001211724500.13231@localhost.localdomain>
 <20100122182827.GA13185@redhat.com>
 <20100122200129.GG22003@redhat.com>
 <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain>
 <20100122221348.GA4263@redhat.com>
 <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain>
 <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain>
 <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com>
 <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 23, 2010 at 09:04:56PM -0800, Linus Torvalds wrote:
> > The killer app for this will be the ability to delete thousands of
> > lines of code from GDB, strace, and all the various other tools that
> > have to painfully work around the major interface gotchas of ptrace(),
> > while at the same time making their handling of complex processes much
> > more robust.
> 
> No. There is absolutely _no_ reason to believe that gdb et al would ever 
> delete the ptrace interfaces anyway. 

More to the point, gdb *couldn't* use utrace, because utrace only
exports a kernel API; not a syscall interface.  And if the Red Hat
Toolchain folks are thinking about encouraging gdb to start creating
out-of-tree kernel modules, so that (a) gdb requires root privs, and
(b) gdb is as (un)stable as SystemTap with respect to development
kernels by making it dependent on internal kernel API's, the Red Hat
Toolchain group needs to be smacked upside the head...

	  	      	    	    	   - Ted
