Return-Path: <linux-kernel-owner+w=401wt.eu-S933537AbYB2UIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933537AbYB2UIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 15:08:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755743AbYB2UIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 15:08:35 -0500
Received: from c60.cesmail.net ([216.154.195.49]:34391 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755091AbYB2UIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 15:08:34 -0500
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to use GPL-only
	symbols
From: Pavel Roskin <proski@gnu.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Zan Lynx <zlynx@acm.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <alpine.LFD.1.00.0802291151460.17889@woody.linux-foundation.org>
References: <1204236662.3612.6.camel@dv>
	 <alpine.LFD.1.00.0802281525170.5780@woody.linux-foundation.org>
	 <20080229012012.ajlsk4pow8wkkgss@webmail.spamcop.net>
	 <alpine.LFD.1.00.0802290807110.17889@woody.linux-foundation.org>
	 <1204304352.6767.21.camel@localhost>
	 <alpine.LFD.1.00.0802290906520.17889@woody.linux-foundation.org>
	 <1204305609.21719.16.camel@dv>
	 <alpine.LFD.1.00.0802290929590.17889@woody.linux-foundation.org>
	 <1204313978.2316.8.camel@dv>
	 <alpine.LFD.1.00.0802291151460.17889@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 15:08:33 -0500
Message-Id: <1204315713.2316.15.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-29 at 11:53 -0800, Linus Torvalds wrote:
> 
> On Fri, 29 Feb 2008, Pavel Roskin wrote:
> > 
> > I already know what USB folks will say.  They want proprietary drivers
> > to be in the userspace.  I doubt ndiswrapper will ever be ported to the
> > userspace.  It's much more likely that some other approach will be used.
> 
> If that's the case, then talk to the USB people. Maybe they are ok with 
> wrapping them in GPL wrappers. But it sounds like they would prefer the 
> stricter GPLONLY meaning (ie no ndiswrapper), and it's their code.

This still leaves us with the workqueue interface:

__create_workqueue_key
destroy_workqueue
flush_workqueue
queue_work

ndiswrapper has its own workqueue implementation, but it would be great
to avoid code duplication.

As for task_nice(), it's strange that task_nice() is GPLONLY, but
set_user_nice() is not.  Anyway, it can probably be worked around.

-- 
Regards,
Pavel Roskin
