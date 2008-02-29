Return-Path: <linux-kernel-owner+w=401wt.eu-S932878AbYB2Tjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878AbYB2Tjz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 14:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757102AbYB2Tjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 14:39:44 -0500
Received: from c60.cesmail.net ([216.154.195.49]:21169 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756930AbYB2Tjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 14:39:43 -0500
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to use GPL-only
	symbols
From: Pavel Roskin <proski@gnu.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Zan Lynx <zlynx@acm.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <alpine.LFD.1.00.0802290929590.17889@woody.linux-foundation.org>
References: <1204236662.3612.6.camel@dv>
	 <alpine.LFD.1.00.0802281525170.5780@woody.linux-foundation.org>
	 <20080229012012.ajlsk4pow8wkkgss@webmail.spamcop.net>
	 <alpine.LFD.1.00.0802290807110.17889@woody.linux-foundation.org>
	 <1204304352.6767.21.camel@localhost>
	 <alpine.LFD.1.00.0802290906520.17889@woody.linux-foundation.org>
	 <1204305609.21719.16.camel@dv>
	 <alpine.LFD.1.00.0802290929590.17889@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 14:39:38 -0500
Message-Id: <1204313978.2316.8.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-29 at 09:33 -0800, Linus Torvalds wrote:
> 
> On Fri, 29 Feb 2008, Pavel Roskin wrote:
> > 
> > Actually, it's a flawed comparison.  The only thing ndiswrapper exports
> > to NDIS modules is NDIS API.  GPLONLY symbols are only used to implement
> > that API in the code that's under GPL.  That's the code you can fork,
> > change and redistribute.
> 
> .. and it's stuill just a wrapper.
> 
> A fairly thick one, but still...

So it the Linux syscall interface.  It's a wrapper around the kernel
internals, including GPLONLY symbols.  Yet some userspace programs are
proprietary.

> More importantly, none of the people arguing against this at all even 
> reacted to my suggestion for how to fix things *properly* in my original 
> email. Which just means that you're apparently not interested in actually 
> fixing this, you're just trying to disagree about some interpretation of 
> GPLONLY.

I'm actually interested in fixing this, or I would not have sent a
patch.

> In other words: the next person who can't even be bothered to tell what 
> symbols are involved and why they haven't asked whether those symbols 
> could instead be relaxed, automaticaly will go into my "flamers" filter, 
> and just stay there. Then you can complain as much as you like, and I'll 
> never see it.

Well, here's the list

__create_workqueue_key
destroy_workqueue
flush_workqueue
queue_work
task_nice
usb_alloc_urb
usb_buffer_alloc
usb_buffer_free
usb_clear_halt
usb_control_msg
usb_deregister
usb_free_urb
usb_get_current_frame_number
usb_get_descriptor
usb_get_status
usb_ifnum_to_if
usb_init_urb
usb_kill_urb
usb_lock_device_for_reset
usb_register_driver
usb_reset_configuration
usb_reset_device
usb_set_interface
usb_submit_urb
usb_unlink_urb

I already know what USB folks will say.  They want proprietary drivers
to be in the userspace.  I doubt ndiswrapper will ever be ported to the
userspace.  It's much more likely that some other approach will be used.

-- 
Regards,
Pavel Roskin
