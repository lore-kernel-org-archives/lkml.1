Return-Path: <linux-kernel-owner+w=401wt.eu-S1757702AbYJVTQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702AbYJVTQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 15:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbYJVTQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 15:16:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57205 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbYJVTQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 15:16:35 -0400
Date: Wed, 22 Oct 2008 15:16:33 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       sagar.abhishek@gmail.com, davem@davemloft.net, tglx@linutronix.de,
       peterz@infradead.org, torvalds@linux-foundation.org,
       srostedt@redhat.com
Subject: Re: [PATCH 04/11] ftrace: comment arch ftrace code
In-Reply-To: <20081022120951.11665534.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0810221513490.25759@gandalf.stny.rr.com>
References: <20081022184313.179487464@goodmis.org> <20081022185136.134729572@goodmis.org> <20081022120951.11665534.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 22 Oct 2008, Andrew Morton wrote:
> 
> I dunno.
> 
> __copy_to_user_inatomic() is for "copying memory from userspace while
> in an atomic context".
> 
> But what you're doing here is "modifying some kernel text which might
> generate a fault".  It seems somewhat interface-abusive to use a
> userspace access function for that just because it happens right now to
> do the right thing.
> 
> I'd suggest that for clarity and for future-safety, you create some new
> interface function which does that thing.  Right now it can be a simple
> wrapper around __copy_from_user_inatomic().
> 
> <looks>
> 
> oh, someone added one - probe_kernel_write().  Why not use that?

I didn't know about that code. That is what I want.

-- Steve

> 
> <wonders why he doesn't know what's going on any more>
> 
> 
> Also, I hope that the above code is called from within a
> pagefault_disable()d region?  Or are relying upon some magical
> side-effect of something which happens to do the same thing as
> pagefault_disable()?  IOW: by what means does the above code ensure
> that do_page_fault() will see in_atomic()==true?

This code is called from kstop_machine, or simply has interrupts disabled.

-- Steve

