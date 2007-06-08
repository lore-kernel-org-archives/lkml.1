Return-Path: <linux-kernel-owner+w=401wt.eu-S1032101AbXFHVMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032101AbXFHVMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 17:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756433AbXFHVMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 17:12:41 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:57507 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbXFHVMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 17:12:40 -0400
Subject: Re: [PATCH 1/3] [PATCH i386] during VM oom condition, kill all
	threads in process group
From: Will Schmidt <will_schmidt@vnet.ibm.com>
Reply-To: will_schmidt@vnet.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linuxppc-dev@ozlabs.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Anton Blanchard <anton@samba.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070608123230.520655f5.akpm@linux-foundation.org>
References: <20070605174831.21740.33119.stgit@farscape.rchland.ibm.com>
	 <20070607153459.2a1b3230.akpm@linux-foundation.org>
	 <20070607231621.GB32549@kryten>
	 <20070607171018.d51fc5da.akpm@linux-foundation.org>
	 <1181330358.21409.31.camel@farscape.rchland.ibm.com>
	 <20070608123230.520655f5.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: IBM
Date: Fri, 08 Jun 2007 16:12:26 -0500
Message-Id: <1181337147.21409.42.camel@farscape.rchland.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-08 at 12:32 -0700, Andrew Morton wrote:
> On Fri, 08 Jun 2007 14:19:18 -0500
> Will Schmidt <will_schmidt@vnet.ibm.com> wrote:
> 
> > > > > zap_other_threads() requires tasklist_lock.
> > 

> In fact, it's probably the case that rcu_read_lock() is now sufficient
> locking coverage for zap_other_threads() (cc's people).
> 
> It had better be, because do_group_exit() forgot to take tasklist_lock.  It
> is perhaps relying upon spin_lock()'s hidden rcu_read_lock() properties
> without so much as a code comment, which would be somewhat nasty of it.

> You could perhaps just call do_group_exit() from within the fault
> handler,
> btw.

Yup, so looks like I can actually replace the existing do_exit() call
with do_group_exit().   I'll sit on this for a bit to give other folks a
chance to comment on which lock call is sufficient, read_lock() or
rcu_read_lock(), etc;  and do_group_exit()'s issue with taking
tasklist_lock. 

Thanks,

-Will

