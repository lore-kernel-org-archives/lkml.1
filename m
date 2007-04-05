Return-Path: <linux-kernel-owner+w=401wt.eu-S932067AbXDECyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067AbXDECyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 22:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932409AbXDECyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 22:54:15 -0400
Received: from ozlabs.org ([203.10.76.45]:45831 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932067AbXDECyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 22:54:14 -0400
Subject: Re: [PATCH] lguest32 kallsyms backtrace of guest.
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: virtualization@lists.osdl.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>
In-Reply-To: <1175711023.9371.21.camel@localhost.localdomain>
References: <1175711023.9371.21.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 05 Apr 2007 12:54:12 +1000
Message-Id: <1175741652.12230.620.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 14:23 -0400, Steven Rostedt wrote:
> This is taken from the work I did on lguest64.
> 
> When killing a guest, we read the guest stack to do a nice back trace of
> the guest and send it via printk to the host.
> 
> So instead of just getting an error message from the lguest launcher of:
> 
> lguest: bad read address 537012178 len 1
> 
> I also get in my dmesg:
> 
> called from  [<c0405f30>] show_trace_log_lvl+0x1a/0x2f

Hi Steven,

	This is a cool idea, but there are two issues with this patch.  The
first is that it's 500 lines of code: that's around +10% on lguest's
total code size!  The second is that it conflicts with the medium-term
plan to allow any user to run up lguests: this is why lg.ko never
printk()s about problems with the guest.

While it is useful for cases where a guest dies mysteriously before it
brings up the console, three alternatives come to mind:

1) Modify early_printk so Guests can use it.
2) Have a separate tool(-set?) for this kind of post-mortem.  Then you
just have to implement guest suspend! 8)
3) Put this in a CONFIG_LGUEST_DEBUG.

Note that options 1 or 2 make you do more work, but are probably better
in the long term.  I'm happy for #3 to sit as a patch in the tree for
the duration, tho!

Cheers,
Rusty.


