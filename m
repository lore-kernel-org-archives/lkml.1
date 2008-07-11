Return-Path: <linux-kernel-owner+w=401wt.eu-S1758417AbYGKAyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417AbYGKAyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 20:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755508AbYGKAyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 20:54:10 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38715 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363AbYGKAyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 20:54:09 -0400
Date: Fri, 11 Jul 2008 09:55:01 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, Paul Menage <menage@google.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Libcg Devel Mailing List <libcg-devel@lists.sourceforge.net>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Peter Zijlstra <pzijlstr@redhat.com>,
       Kazunaga Ikeno <k-ikeno@ak.jp.nec.com>,
       Morton Andrew Morton <akpm@linux-foundation.org>,
       Thomas Graf <tgraf@redhat.com>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [RFC] How to handle the rules engine for cgroups
Message-Id: <20080711095501.cefff6df.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080710154035.GA12043@redhat.com>
References: <20080701191126.GA17376@redhat.com>
	<20080703101957.b3856904.kamezawa.hiroyu@jp.fujitsu.com>
	<20080703155446.GB9275@redhat.com>
	<6599ad830807100223m2453963cwcfbe6eb1ad54d517@mail.gmail.com>
	<20080710104852.797fe79c@cuia.bos.redhat.com>
	<20080710154035.GA12043@redhat.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2008 11:40:35 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Thu, Jul 10, 2008 at 10:48:52AM -0400, Rik van Riel wrote:
> > On Thu, 10 Jul 2008 02:23:52 -0700
> > "Paul Menage" <menage@google.com> wrote:
> > 
> > > I don't see the rule-based approach being all that useful for our needs.
> > 
> > Agreed, there really is no need for a rule-based approach in kernel space.
> > 
> > There are basically three different cases:
> > 
> > 1) daemons get started up in their own process groups, this can
> >    be handled by the initscripts
> > 
> > 2) user sessions (ssh, etc) start in their own process groups,
> >    this can be handled by PAM
> > 
> > 3) users fork processes that should go into special process
> >    groups - this could be handled by having a small ruleset
> >    in userspace handle things, right before calling exec(),
> 
> That means application launcher (ex, shell) is aware of the right cgroup
> targeted application should go in and then move forked pid to right
> cgroup and call exec? Or you had something else in mind?
>  
> >    it can even be hidden from the application by hooking into
> >    the exec() call
> > 
> 
> This means hooking into libc. So libc will parse rules file, determine
> the right cgroup, place application there and then call exec?
> 

Hmm, as I wrote, the rule that the child inherits its own parent't is very
strong rule. (Most of case can be handle by this.) So, what I think of is

1. support a new command (in libcg.)
  - /bin/change_group_exec ..... read to /etc/cgroup/config and move cgroup
                                 and call exec.
2. and libc function
  - if necessary.

1. is enough because admin/user can write a wrapper script for their
applications if "child inherits parent's" isn't suitable.

no ?

Thanks,
-Kame











