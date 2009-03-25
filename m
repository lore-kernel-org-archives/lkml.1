Return-Path: <linux-kernel-owner+w=401wt.eu-S1761705AbZCYPEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761705AbZCYPEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 11:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbZCYPEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 11:04:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57504 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbZCYPEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 11:04:09 -0400
Date: Wed, 25 Mar 2009 11:04:06 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Hua Zhong <hzhong@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Steven Rostedt <srostedt@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 2/5] mm: remove unlikly NULL from kfree
In-Reply-To: <1237993145.30175.34.camel@penberg-laptop>
Message-ID: <alpine.DEB.2.00.0903251103070.5675@gandalf.stny.rr.com>
References: <20090325051920.406564281@goodmis.org>  <20090325052023.071564146@goodmis.org>  <84144f020903250034j24e1782bt5f73809b9349346c@mail.gmail.com>  <009101c9ad20$1ae231c0$50a69540$@com>  <1237968394.30175.12.camel@penberg-laptop> 
 <84144f020903250651o13c723cgf64643091459a5ac@mail.gmail.com>  <alpine.DEB.2.00.0903251039590.5675@gandalf.stny.rr.com> <1237993145.30175.34.camel@penberg-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 25 Mar 2009, Pekka Enberg wrote:

> Hi Steven,
> 
> On Wed, 25 Mar 2009, Pekka Enberg wrote:
> > > OK, so according to Steven, audit_syscall_exit() is one such call-site
> > > that shows up in the traces. I don't really understand what's going on
> > > there but if it is sane, maybe that warrants the removal of unlikely()
> > > from kfree(). Hmm?
> 
> On Wed, 2009-03-25 at 10:47 -0400, Steven Rostedt wrote:
> > After disabling AUDIT_SYSCALLS I have this:
> > 
> >  # cat /debug/tracing/trace | sort -u
> > 
> > record_nulls: ptr=(null) (ext3_get_acl+0x1e0/0x3f0 [ext3])
> > record_nulls: ptr=(null) (free_bitmap+0x29/0x70)
> > record_nulls: ptr=(null) (free_tty_struct+0x1d/0x40)
> > record_nulls: ptr=(null) (ftrace_graph_exit_task+0x1e/0x20)
> > record_nulls: ptr=(null) (inet_sock_destruct+0x1cb/0x2a0)
> > record_nulls: ptr=(null) (ip_cork_release+0x24/0x50)
> > record_nulls: ptr=(null) (keyctl_join_session_keyring+0x5a/0x70)
> > record_nulls: ptr=(null) (key_user_lookup+0x183/0x220)
> > record_nulls: ptr=(null) (kobject_set_name_vargs+0x43/0x50)
> > record_nulls: ptr=(null) (netlink_release+0x1a4/0x2f0)
> > record_nulls: ptr=(null) (release_sysfs_dirent+0x20/0xc0)
> > record_nulls: ptr=(null) (sysfs_open_file+0x1c8/0x3e0)
> > record_nulls: ptr=(null) (tty_write+0x16a/0x290)
> > 
> > I added a hook to only record when NULL is passed into kfree.
> > 
> > Also note, that after disabling AUDIT_SYSCALLS I now only have roughly 7% 
> > NULL hit rate. Still, unlikely is probably not a benefit here.
> 
> Thanks for doing this. Do you mean that 93% hit ratio is not enough to
> be a performance gain?

I think it was Christoph Lameter (good you Cc'd him) told me that anything 
less that 99% is not worthy of a (un)likely macro.

I honestly don't know.

-- Steve

