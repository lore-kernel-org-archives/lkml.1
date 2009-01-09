Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbZAIGQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbZAIGQH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 01:16:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbZAIGPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 01:15:55 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51753 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752101AbZAIGPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 01:15:54 -0500
Message-ID: <4966EB5F.4010506@cn.fujitsu.com>
Date: Fri, 09 Jan 2009 14:14:55 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "menage@google.com" <menage@google.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] NOOP cgroup subsystem
References: <20090109143226.b79d21b4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090109143226.b79d21b4.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> How about this idea ? Any comments are welcome.
> 
> -Kame
> 
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Add an NO OPERATION cgroup subsystem.
> 
> Cgroup itself is providing a feature to attach a task(PID) to some class.
> This feature itself is very useful but "no operation" cgroup is not supported
> now other than debug cgroup. (But debug cgroup should be for DEBUG. distro
> may not configure it.)
> 

Then how can we make sure distro will configure this noop subsys. :)

Or we can make the debug subsys always configured if CONFIG_CGROUP=y ?
The debug system adds no runtime overhead, and it's about 100 lines
of code only.

> Motivation: Simply classify Applications by cgroup
>   When using cgroup for classifying applications, some kind of "control" or
>   "account" subsys must be used. For flexible use of cgroup's nature of
>   classifying applications, NOOP is useful. It can be used regardless of
>   resource accounting unit or name spaces or some controls.
>   IOW, NOOP cgroup allows users to tie PIDs with some nickname.
> 
> After this, application can be checked whether it's still alive or not by
> 
> 	mount -t cgroup none /var/apps noop
> 	mkdir /var/apps/mydaemon
> 	echo 0 > /var/apps/mydaemon
> 	/etc/init.d/mydaemon start
> 	exit
> 
> This can be used as the same technique of "recording pid into /var/run/xxx.pid"
> and not necessary to remove stale files. If mydaemon dies, tasks file will
> be empty and notify_on_release handler can be used.
> 
> I myself want to use this for replacement of "ps -elf | grep" if libcgroup supports
> ps under cgroup.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
