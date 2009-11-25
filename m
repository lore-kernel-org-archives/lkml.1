Return-Path: <linux-kernel-owner+w=401wt.eu-S1758050AbZKYPaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbZKYPaJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 10:30:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757899AbZKYPaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 10:30:08 -0500
Received: from www.tglx.de ([62.245.132.106]:35562 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755655AbZKYPaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 10:30:07 -0500
Date: Wed, 25 Nov 2009 16:29:04 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jakub Jelinek <jakub@redhat.com>
cc: Andrew Haley <aph@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>,
       rostedt@goodmis.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       Richard Guenther <richard.guenther@gmail.com>, gcc <gcc@gcc.gnu.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][GIT PULL][v2.6.32] tracing/x86: Add check to detect GCC
 messing with mcount prologue
In-Reply-To: <20091124150604.GJ22813@hs20-bc2-1.build.redhat.com>
Message-ID: <alpine.LFD.2.00.0911251604280.24119@localhost.localdomain>
References: <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain> <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain> <1258694593.22249.1012.camel@gandalf.stny.rr.com> <1258736456.22249.1032.camel@gandalf.stny.rr.com> <4B06EF6F.2050507@redhat.com>
 <6dc9ffc80911220138y15bfa91agccf5c29f1c30e09a@mail.gmail.com> <4B0972C9.302@redhat.com> <6dc9ffc80911221530t38d83cf6je739743c8d756667@mail.gmail.com> <4B0BF119.4070704@redhat.com> <alpine.LFD.2.00.0911241555170.24119@localhost.localdomain>
 <20091124150604.GJ22813@hs20-bc2-1.build.redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009, Jakub Jelinek wrote:

> On Tue, Nov 24, 2009 at 03:55:49PM +0100, Thomas Gleixner wrote:
> > > you should compile your code with -maccumulate-outgoing-args, and there's
> > > no need to use -mtune=generic.  Is that right?
> > 
> > Seems to work. What other side effects has that ?
> 
> Faster code, significant increase in code size though.  Note that on many
> architectures it is the only supported model.

Just checked on the affected -marchs. The increase in code size is
about 3% which is not that bad and definitely acceptable for the
tracing case. Will zap the -mtune=generic patch and use
-maccumulate-outgoing-args instead.

Thanks,

	tglx
