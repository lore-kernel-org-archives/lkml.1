Return-Path: <linux-kernel-owner+w=401wt.eu-S1757197AbXJTQq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbXJTQq1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 12:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756463AbXJTQqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 12:46:20 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:41027 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756025AbXJTQqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 12:46:19 -0400
Date: Sat, 20 Oct 2007 18:47:52 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: git/cscope with x86 merge
Message-ID: <20071020164752.GB6855@uranus.ravnborg.org>
References: <86802c440710151245s7d12a45fpfdaa041546d965e@mail.gmail.com> <alpine.LFD.0.999.0710151256260.6887@woody.linux-foundation.org> <86802c440710200240o7aae2760o5fa9c70e3b327097@mail.gmail.com> <alpine.LFD.0.999.0710200854550.3794@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710200854550.3794@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20, 2007 at 08:56:18AM -0700, Linus Torvalds wrote:
> 
> 
> On Sat, 20 Oct 2007, Yinghai Lu wrote:
> > 
> > git log -p --follow arch/x86/kernel/vmlinux_64.lds.S
> > 
> > can not trace to arch/x86_64/kernel/vmlinux.lds.S
> 
> Hmm. I get:
> 
> 	[torvalds@woody linux]$ git log --stat --follow arch/x86/kernel/vmlinux_64.lds.S
> 	commit 250c22777fe1ccd7ac588579a6c16db4c0161cc5
> 	Author: Thomas Gleixner <tglx@linutronix.de>
> 	Date:   Thu Oct 11 11:17:24 2007 +0200
> 	
> 	    x86_64: move kernel
> 	
> 	    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 	    Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 	
> 	 arch/{x86_64 => x86}/kernel/vmlinux_64.lds.S |    0
> 	 1 files changed, 0 insertions(+), 0 deletions(-)
> 	
> 	commit 13a9cd42466e12113859c4d7b41561e8bbcaf09d
> 	Author: Thomas Gleixner <tglx@linutronix.de>
> 	Date:   Thu Oct 11 11:14:21 2007 +0200
> 	
> 	    x86_64: prepare shared kernel/vmlinux.lds.S
> 	
> 	    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 	    Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 	
> 	 arch/x86_64/kernel/vmlinux_64.lds.S |  235 +++++++++++++++++++++++++++++++++++
> 	 1 files changed, 235 insertions(+), 0 deletions(-)
> 
> 
> so it definitely works for me.

But you do not see the rename arch/x86_64/kernel/{vmlinux.lds.S => vmlinux.lds.S}
And this is I thing the important step here.

For vmlinux.lds.S we have two renames.
First the vmlinux.lds.S => vmlinux_64.lds.S
But this may be a copy instead of a rename thus preventing us
to see the old history of vmlinux.lds.S?

	Sam
