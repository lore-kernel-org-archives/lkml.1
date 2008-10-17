Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbYJQPdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbYJQPdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 11:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754860AbYJQPdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 11:33:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754353AbYJQPdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 11:33:09 -0400
Date: Fri, 17 Oct 2008 11:31:51 -0400
From: Jason Baron <jbaron@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@elte.hu, yhlu.kernel@gmail.com, tglx@linutronix.de
Subject: Re: [GIT PATCH] driver core patches for your 2.6-git tree
Message-ID: <20081017153151.GB3167@redhat.com>
References: <20081016170954.GA11824@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081016170954.GA11824@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 10:09:55AM -0700, Greg KH wrote:
> Here is the driver core patchset for your 2.6-git tree.
> 
> Highlights include:

> 	- dynamic dev_printk() patch, allows debugging to be turned on
> 	  the fly, instead of at build time.  This is very good and has
> 	  been in the opensuse beta releases already with much success.

while I think this is a good feature b/c it allows dynamically turning debug
information on/off at runtime, and it creates a standard framework for
all the DEBUGP, dprintk, DEBUG, calls that each subsystems defines for
itself, there was some resistance to this approach in another thread,
see: http://marc.info/?l=linux-kernel&m=122164181331567&w=2
I am adding the relevant parties to the 'cc here in the interest of making sure
interested parties are aware of this patch proposal.

One concern, raised in the other thread was that subsystems might want
to use their own defined tags, as opposed to KBUILD_MODNAME, which is
used by default to group together debugging control. Layering this tag
ability on top of this patchset is not hard, and I already have patches
which begin to do that...Also, this patch allows passing one command
line argument to enable all debugging which can later be turn on/off
as desired. This patch already stands on its own in enabling all pr_debug and 
dev_dbg calls to be dynamically enabled.

thanks,

-Jason
