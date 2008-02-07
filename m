Return-Path: <linux-kernel-owner+w=401wt.eu-S1757488AbYBGGux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488AbYBGGux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 01:50:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbYBGGup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 01:50:45 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58676 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbYBGGuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 01:50:44 -0500
Date: Wed, 6 Feb 2008 22:55:00 -0800
From: Greg KH <greg@kroah.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Gerd Hoffmann <kraxel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stable Team <stable@kernel.org>
Subject: Re: [stable] The SMP alternatives code breaks exception fixup?
Message-ID: <20080207065500.GA23212@kroah.com>
References: <479504F6.4080005@redhat.com> <p73zluymnx0.fsf@crumb.suse.de> <alpine.LFD.1.00.0801221312200.3199@apollo.tec.linutronix.de> <47964FD5.6020801@redhat.com> <20080206231020.GB12395@kroah.com> <alpine.LFD.1.00.0802061534470.2883@woody.linux-foundation.org> <20080206234309.GA13758@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080206234309.GA13758@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 12:43:09AM +0100, Ingo Molnar wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > > I don't see this in Linus's tree, am I just missing it?  Do you have 
> > > a git commit id?
> > 
> > Isn't this 9d55b9923a1b7ea8193b8875c57ec940dc2ff027 (possibly with 
> > 2532ec6d178abc55681d049097d3dc577eaa266c on top)?
> 
> yeah.
> 
> Greg: note that this is against post-unification asm-x86/futex.h so it 
> wont apply to .24.
> 
> I've backported the fix to .24 - find it below. (untested but obvious)

unfortunatly it doesn't even compile:

distcc[30740] ERROR: compile (null) on localhost failed
In file included from include/asm/futex.h:2,
                 from kernel/futex.c:59:
include/asm/futex_32.h:72:29: error: macro "__futex_atomic_op1" passed 6 arguments, but takes just 5
In file included from include/asm/futex.h:2,
                 from kernel/futex.c:59:
include/asm/futex_32.h: In function 'futex_atomic_op_inuser':
include/asm/futex_32.h:71: error: '__futex_atomic_op1' undeclared (first use in this function)
include/asm/futex_32.h:71: error: (Each undeclared identifier is reported only once
include/asm/futex_32.h:71: error: for each function it appears in.)
distcc[30739] ERROR: compile kernel/futex.c on localhost failed
make[1]: *** [kernel/futex.o] Error 1


Care to try again?  :)

thanks,

greg k-h
