Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbYHSNAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbYHSNAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 09:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbYHSNAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 09:00:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291AbYHSM77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 08:59:59 -0400
Date: Tue, 19 Aug 2008 08:57:10 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Paul Menage <menage@google.com>
Cc: righi.andrea@gmail.com, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Kazunaga Ikeno <k-ikeno@ak.jp.nec.com>,
       Morton Andrew Morton <akpm@linux-foundation.org>,
       Thomas Graf <tgraf@redhat.com>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [RFC] [PATCH -mm] cgroup: uid-based rules to add processes
	efficiently in the right cgroup
Message-ID: <20080819125710.GA18972@redhat.com>
References: <20080703155446.GB9275@redhat.com> <6599ad830807100223m2453963cwcfbe6eb1ad54d517@mail.gmail.com> <20080710104852.797fe79c@cuia.bos.redhat.com> <20080710154035.GA12043@redhat.com> <20080711095501.cefff6df.kamezawa.hiroyu@jp.fujitsu.com> <20080714135719.GE16673@redhat.com> <487B665B.9080205@sun.com> <20080714152142.GJ16673@redhat.com> <48A7FE7B.3060309@gmail.com> <6599ad830808181405i3ec1f9fdp4d8ca7ab675b2c5f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830808181405i3ec1f9fdp4d8ca7ab675b2c5f@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 02:05:36PM -0700, Paul Menage wrote:
> On Sun, Aug 17, 2008 at 3:33 AM, Andrea Righi <righi.andrea@gmail.com> wrote:
> >
> > [ I wrote this patch for a "special purpose" environment, where a lot of
> > short-lived processes belonging to different users are spawned by
> > different daemons,
> 
> What kinds of daemons are these? Is it not possible to add some
> libcgroup calls to these daemons?
> 
> I'm reluctant to add features like this to the kernel side of cgroups
> due to their "magical" nature - any task that does a setuid() now
> risks being swept off into a different cgroup.
> 
> Having the cgroup attachment done explicitly e.g. by a PAM library at
> login time is much less likely to cause unexpected behaviour.
> 
> Maybe if we had a way to control which tasks the magical setuid
> switching occurs for, it might be more acceptable. (Perhaps base it on
> the cgroup of the task that's doing the setuid as well?

Hi Paul,

Same thing will happen if we implement the daemon in user space. A task
who does seteuid(), can be swept away to a different cgroup based on 
rules specified in /etc/cgrules.conf. 

What do you mean by risk? This is the policy set up by system admin and
behaviour would seem consistent as per the policy. If an admin decides
that tasks of user "apache" should run into /container/cpu/apache cgroup and
if a "root" tasks does seteuid(apache), then it manes sense to move task
to /container/cpu/apache.

Exactly what kind of scenario do you have in mind when you want the policy
to be enforced selectively based on task (tid)?

Thanks
Vivek
