Return-Path: <linux-kernel-owner+w=401wt.eu-S1752702AbZGWFrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbZGWFrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 01:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbZGWFrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 01:47:08 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45217 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbZGWFrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 01:47:07 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 23 Jul 2009 14:45:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: akpm@linux-foundation.org, lizf@cn.fujitsu.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] CGroup: Support for named and empty hierarchies
Message-Id: <20090723144520.ced5f8f1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6599ad830907222237jcdac287tf4243e24024f8055@mail.gmail.com>
References: <20090722194644.7481.47805.stgit@menage.mtv.corp.google.com>
	<20090723141301.05401a5c.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830907222237jcdac287tf4243e24024f8055@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009 22:37:53 -0700
Paul Menage <menage@google.com> wrote:

> On Wed, Jul 22, 2009 at 10:13 PM, KAMEZAWA
> Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >
> > Thank you. I'd like to look into procps package to allow
> >
> >  #ps -lf -cgroup=/xxxx/yyy
> > or
> >  #top -cgroup=/xxx/yyy
> >
> 
> Wouldn't it be less invasive to change procps so that doing
> 
> ps <pid1> <pid2> ...
> 
> only actually looks at /proc/<pid1>, /proc/<pid2>, etc, rather than
> looking at all of them and then throwing away any that aren't in the
> supplied list?
> 
> Then you could do what you want with ps $(cat /dev/cgroup/xxxx/yyy/tasks)
> 
Good point. When you try strace

#strace ps -ef --pid XXXX

you'll see ps scan all pids. The same behavior for pkill, pgrep etc...
AFAIK, this is a behavior from Linux 2.4 ages.
By this, ps -ef --pid=XXX can take 1ms if 2000 procs are on system.
# I think this is because ps uses an unified filter routine.

So, I have to rewrite filter routine or add cgroup support.

Abyway, adding a new toggle switch to "top", "pgrep" is worth to do, I think.

Thanks,
-Kame

