Return-Path: <linux-kernel-owner+w=401wt.eu-S1753137AbZFCAEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137AbZFCAEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 20:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbZFCAEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 20:04:16 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34508 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbZFCAEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 20:04:15 -0400
Date: Wed, 3 Jun 2009 09:02:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>, menage@google.com,
       lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, bharata@linux.vnet.ibm.com,
       libcg-devel@lists.sourceforge.net
Subject: Re: +
 cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem. patch
 added to -mm tree
Message-Id: <20090603090243.5a2f566c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090602133534.d2e453f6.akpm@linux-foundation.org>
References: <200906020602.n5262wcu008560@imap1.linux-foundation.org>
	<20090602090944.GB16753@linux.vnet.ibm.com>
	<6599ad830906020908s7cb6afe6pd83ca35b82d148a4@mail.gmail.com>
	<20090602174042.GD16753@linux.vnet.ibm.com>
	<20090602133534.d2e453f6.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Jun 2009 13:35:34 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 2 Jun 2009 23:10:42 +0530
> Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> 
> > On Tue, Jun 02, 2009 at 09:08:04AM -0700, Paul Menage wrote:
> > > On Tue, Jun 2, 2009 at 2:09 AM, Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> > > >
> > > > I am not sure if this is a good idea. For libcgroup, we would then be
> > > > adding a special case for just cpuset. I would rather that we allow it
> > > > either for all the subsystems or none of them.
> > > >
> > > 
> > > libcgroup shouldn't be using the noprefix option. Its only intentded
> > > use is to allow the legacy "cpuset" filesystem type to be mounted and
> > > to see the same fileset as it had before the cgroups transition.
> > > 
> > 
> > It does not. But if some user is using that option, we need to be in a
> > position to handle it.
> > 
> > I am quite happy not supporting the noprefix option in the library if it
> > is fine.
> > 
> 
> fyi, the above discussion transitions akpm into the "confused" state. 
> I'll keep the patch on hold until akpm transitions back out of that
> state.
> 
Traffic control...

[What "noprefix" is]
 - When "noprefix" is used, the name of file under cgroup is..
  [Without noprefix]  ... (dir)/subsysname.filename
  [With noprefix]     ... (dir)/filename

Then, cpuset's files will be
  [Without noprefix]  ... (dir)/cpuset.xxx
  [With noprefix]     ... (dir)/xxx

This is for _backward compatibility_.

[Problem]
 cpustat subsys has "stat" file.
 memory  subsys has "stat" file.

 So, these cannot be mounted at the same mount point with "noprefix".

Considering arbitrary subsys can be mounted at the same point, allowing "noprefix"
other than cpuset just makes user-land complex, and "noprefix" itself is
troublesome, it breaks naming rule for cgroup files.

Then, I vote for that this patch should go.

Thanks,
-Kame


 













> 

