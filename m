Return-Path: <linux-kernel-owner+w=401wt.eu-S1756835AbYEAVrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbYEAVrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 17:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759478AbYEAVq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 17:46:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60876 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbYEAVq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 17:46:58 -0400
Date: Thu, 1 May 2008 17:46:57 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Daniel Walker <dwalker@mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, lucho@ionkov.net, ericvh@gmail.com,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] fix flags length in net 9p
In-Reply-To: <20080501223228.GA17060@martell.zuzino.mipt.ru>
Message-ID: <Pine.LNX.4.58.0805011743180.12785@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0805011706070.12785@gandalf.stny.rr.com>
 <20080501141919.78b7dc4f.akpm@linux-foundation.org>
 <1209677160.12461.267.camel@localhost.localdomain>
 <20080501223228.GA17060@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 May 2008, Alexey Dobriyan wrote:
> >
> > The check that's in -rt for this uses BUILD_BUG_ON(), and it's extremely
> > cryptic when there is a failure .. Most people will be baffled why the
> > build stopped. If a check went into mainline it should at least give you
> > some sort of idea what's happening ..
>
> One comment near BUILD_BUG_ON is enough (and everything we can do).

You might want to put a few comments by spinlock functions too, since I
hit this bug in the -rt patch and it confused my for about 10 minutes. Of
course I first blamed my own work on the spinlocks before I noticed that
the caller was using "int".

But actually, I like the idea of having a irqflags_t type that must be
used.

struct irqflags_s {
	unsigned long flags;
};
typedef struct irqflags_s irqflags_t;

This would force everyone to use this structure, and it would be an easy
script to create to do a the cross the board conversion. The only problems
would be where someone didn't use "flags" as the name, but that can be
fixed as well.

-- Steve

