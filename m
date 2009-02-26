Return-Path: <linux-kernel-owner+w=401wt.eu-S1757580AbZBZBqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580AbZBZBqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 20:46:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbZBZBqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 20:46:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42643 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbZBZBqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 20:46:14 -0500
Date: Wed, 25 Feb 2009 20:46:11 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       fweisbec@gmail.com, srostedt@redhat.com
Subject: Re: [PATCH 1/4] uaccess: add copy_word_from_user
In-Reply-To: <20090225155648.acb93cff.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0902252042510.12697@gandalf.stny.rr.com>
References: <20090225203007.582030664@goodmis.org> <20090225203427.382137706@goodmis.org> <20090225155648.acb93cff.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Feb 2009, Andrew Morton wrote:

> btw,
> 
> On Wed, 25 Feb 2009 15:30:08 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > +int copy_word_from_user(void *to, const void __user *from,
> > +			unsigned int copy, unsigned int read,
> > +			unsigned int *copied, int skip)
> 
> You presently have this not-exported-to-modules.  Was that deliberate?

Nope, I didn't even think about it. I usually do the EXPORT_SYMBOL when
I have a need to export to a module. Not saying I left it out on purpose.
I left it out simply because I did not think about using it in a module 
:-/

> 
> There are arguments either way.  Lately we've tended to take the
> position that a whole interface either is or is not wholly exported. 
> The uaccess functions are exported, so this one should be as well.
> 
> We can of course do that later on, when there's a user - I have no
> particular preference personally.
> 
> <looks at probe_kernel_read and probe_kernel_write>
> 
> These are really part of the uaccess interface too.  I don't see a need
> for both lib/uaccess.c and mm/maccess.c?

Ah, I didn't notice that file. I could move this to that file, or move the 
maccess to this file. I just thought lib would be a better location.
What would you suggest?

> 
> probe_kernel_read() and probe_kernel_write() are EXPORT_SYMBOL_GPL,
> whereas the rest of the uaccess interface is EXPORT_SYMBOL.  Ho hum.

Looks like another clean up. I guess probe_kernel is because it is more 
kernel internals and should not be used by binary modules? Although 
nothing prevents a kernel module from using the uaccess code for the 
kernel. Or even make a fault section themselves.

-- Steve

