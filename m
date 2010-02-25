Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891Ab0BYDQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 22:16:52 -0500
Received: from tundra.namei.org ([65.99.196.166]:36935 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758780Ab0BYDQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 22:16:50 -0500
Date: Thu, 25 Feb 2010 14:15:58 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
cc: linux-security-module@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] TOMOYO: Protect find_task_by_vpid() with RCU.
In-Reply-To: <201002250013.o1P0DHml057484@www262.sakura.ne.jp>
Message-ID: <alpine.LRH.2.00.1002251413160.14411@tundra.namei.org>
References: <201002240034.o1O0YoMd068517@www262.sakura.ne.jp> <alpine.LRH.2.00.1002251056240.13762@tundra.namei.org> <201002250013.o1P0DHml057484@www262.sakura.ne.jp>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Feb 2010, Tetsuo Handa wrote:

> James Morris wrote:
> > On Wed, 24 Feb 2010, Tetsuo Handa wrote:
> > 
> > > Caller of find_task_by_vpid() must use rcu_read_lock().
> > 
> > The comment for the function says:
> > 
> >   Must be called under rcu_read_lock() or with tasklist_lock read-held.
> > 
> > In the cases below, you have taken tasklist_lock.
> 
> That comment will be updated to
> "Must be called under rcu_read_lock()." in 2.6.34 .
> Please see http://lkml.org/lkml/2009/12/10/180 and http://lkml.org/lkml/2009/12/9/472 .

Ok, please fix the comment as well.

Thomas: wasn't Tetsuo correct that we need both the rcu lock and 
tasklist_lock held to call this?

Also, I think the audit code needs fixing.


-- 
James Morris
<jmorris@namei.org>
