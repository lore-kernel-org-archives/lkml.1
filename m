Return-Path: <linux-kernel-owner+w=401wt.eu-S1760019AbXEIXZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760019AbXEIXZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 19:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757580AbXEIXYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 19:24:54 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54887 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755889AbXEIXYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 19:24:52 -0400
Date: Wed, 9 May 2007 16:24:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Scott Murray <scottm@somanetworks.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kristen.c.accardi@intel.com
Subject: Re: [PATCH] cpci_hotplug: Convert to use the kthread API
Message-Id: <20070509162430.772ae536.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705071412030.3671@rancor.yyz.somanetworks.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	<11769657702107-git-send-email-ebiederm@xmission.com>
	<20070422120534.GA20763@infradead.org>
	<Pine.LNX.4.64.0704271802390.3671@rancor.yyz.somanetworks.com>
	<20070504111215.GA3191@infradead.org>
	<Pine.LNX.4.64.0705071412030.3671@rancor.yyz.somanetworks.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 May 2007 14:18:29 -0400 (EDT)
Scott Murray <scottm@somanetworks.com> wrote:

> On Fri, 4 May 2007, Christoph Hellwig wrote:
> 
> > On Fri, Apr 27, 2007 at 06:07:49PM -0400, Scott Murray wrote:
> > > Sorry, it took me a few days to get to testing this out.  It looks good,    
> > > but I had to make a couple of tweaks to avoid a hang when rmmod'ing a
> > > board driver.  The board drivers do:
> > > 
> > > cpci_hp_stop()
> > > cpci_hp_unregister_controller(controller)
> > > 
> > > to shutdown, and the check in cpci_hp_unregister_controller if the thread
> > > is running wasn't working due to a bit too much code being excised.  The
> > > result was kthread_stop being called twice, which hangs.  I've indicated 
> > > my changes to avoid this inline below.
> > 
> > Can you forward the patches with your fix to Andrew to make sure he
> > picks it up?
> 
> Andrew, here is my updated version of Christoph's kthread conversion 
> patch for cpci_hotplug.  I've CC'ed Kristen so she won't be surprised
> when this eventually goes to mainline.

A patch in this area would normally go

	you->kristen->mainline
                |
                v
               -mm

or

	you->kristen->greg->mainline
                        |
                        v
                       -mm

or

	you->me->greg->mainline		(gets an Acked-by somewhere)
                   |
                   v
                  -mm

or

	you->kristen->Len->mainline
                       |
                       v
                      -mm

or something else.

Kristen, how do you want to play this?

Do you run a tree?  If so, lemmeatit ;)
