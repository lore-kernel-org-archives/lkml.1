Return-Path: <linux-kernel-owner+w=401wt.eu-S1752948Ab0ADAP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab0ADAP1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 19:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219Ab0ADAP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 19:15:26 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:33405 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab0ADAP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 19:15:26 -0500
Date: Mon, 4 Jan 2010 05:45:16 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: containers@lists.linux-foundation.org, linux-mm@kvack.org,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Malek <dan@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Alexander Shishkin <virtuoso@slind.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/4] cgroup notifications API and memory thresholds
Message-ID: <20100104001516.GE16187@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <cover.1261858972.git.kirill@shutemov.name>
 <20091227124732.GA3601@balbir.in.ibm.com>
 <cc557aab0912271037scb29fe1xcebe9adfaea97b24@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cc557aab0912271037scb29fe1xcebe9adfaea97b24@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kirill A. Shutemov <kirill@shutemov.name> [2009-12-27 20:37:57]:

> On Sun, Dec 27, 2009 at 2:47 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > * Kirill A. Shutemov <kirill@shutemov.name> [2009-12-27 04:08:58]:
> >
> >> This patchset introduces eventfd-based API for notifications in cgroups and
> >> implements memory notifications on top of it.
> >>
> >> It uses statistics in memory controler to track memory usage.
> >>
> >> Output of time(1) on building kernel on tmpfs:
> >>
> >> Root cgroup before changes:
> >>       make -j2  506.37 user 60.93s system 193% cpu 4:52.77 total
> >> Non-root cgroup before changes:
> >>       make -j2  507.14 user 62.66s system 193% cpu 4:54.74 total
> >> Root cgroup after changes (0 thresholds):
> >>       make -j2  507.13 user 62.20s system 193% cpu 4:53.55 total
> >> Non-root cgroup after changes (0 thresholds):
> >>       make -j2  507.70 user 64.20s system 193% cpu 4:55.70 total
> >> Root cgroup after changes (1 thresholds, never crossed):
> >>       make -j2  506.97 user 62.20s system 193% cpu 4:53.90 total
> >> Non-root cgroup after changes (1 thresholds, never crossed):
> >>       make -j2  507.55 user 64.08s system 193% cpu 4:55.63 total
> >>
> >> Any comments?
> >
> > Thanks for adding the documentation, now on to more critical questions
> >
> > 1. Any reasons for not using cgroupstats?
> 
> Could you explain the idea? I don't see how cgroupstats applicable for
> the task.

cgroupstats allows you to notify task statistics or send
notifications, hence the applicability.

> 
> > 2. Is there a user space test application to test this code.
> 
> Attached. It's not very clean, but good enough for testing propose.
> Example of usage:
> 
> $ echo '/cgroups/memory.usage_in_bytes 1G' | ./cgroup_event_monitor
> 

Thanks, I'll test it right now.

> >  IIUC,
> > I need to write a program that uses eventfd(2) and then passes
> > the eventfd descriptor and thresold to cgroup.*event* file and
> > then the program will get notified when the threshold is reached?
> 
> You need to pass eventfd descriptor, descriptor of control file to be
> monitored (memory.usage_in_bytes or memory.memsw.usage_in_bytes) and
> threshold.
> 
> Do you want to rename cgroup.event_control to cgroup.event?

No, event_control seems like a good name ATM.


-- 
	Balbir
