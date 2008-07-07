Return-Path: <linux-kernel-owner+w=401wt.eu-S1758773AbYGGXCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773AbYGGXCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 19:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754950AbYGGXC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 19:02:28 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:47690 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883AbYGGXC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 19:02:28 -0400
Subject: Re: [PATCH 0/4] Container Freezer: Reuse Suspend Freezer
From: Matt Helsley <matthltc@us.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Paul Menage <menage@google.com>, Pavel Machek <pavel@ucw.cz>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org,
       Linux Containers <containers@lists.linux-foundation.org>
In-Reply-To: <20080707225823.502032693@us.ibm.com>
References: <20080707225823.502032693@us.ibm.com>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Mon, 07 Jul 2008 16:02:24 -0700
Message-Id: <1215471744.9023.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-07-07 at 15:58 -0700, Matt Helsley wrote:
> This patchset reuses the container infrastructure and the swsusp freezer to
> freeze a group of tasks.
> 
> The freezer subsystem in the container filesystem defines a file named
> freezer.state. Writing "FROZEN" to the state file will freeze all tasks in the
> cgroup. Subsequently writing "RUNNING" will unfreeze the tasks in the cgroup. 
> Reading will return the current state. 
> 
> * Examples of usage :
> 
>    # mkdir /containers/freezer
>    # mount -t cgroup -ofreezer,signal freezer  /containers
>    # mkdir /containers/0
>    # echo $some_pid > /containers/0/tasks
> 
> to get status of the freezer subsystem :
> 
>    # cat /containers/0/freezer.state
>    RUNNING
> 
> to freeze all tasks in the container :
> 
>    # echo FROZEN > /containers/0/freezer.state
>    # cat /containers/0/freezer.state
>    FREEZING
>    # cat /containers/0/freezer.state
>    FROZEN
> 
> to unfreeze all tasks in the container :
> 
>    # echo RUNNING > /containers/0/freezer.state
>    # cat /containers/0/freezer.state
>    RUNNING
> 
> to kill all tasks in the container :
> 
>    # echo 9 > /containers/0/signal.kill
> 
> I've reworked Cedric's patches to use task_lock() to protect access to the
> task's cgroup.
> 
> Paul, Pavel asked me to send these to Rafael next. They are patches to make
> the freezer useful for checkpoint/restart using cgroups so it would be nice
> to get an explicit [N]Ack from you first.
> 
> Rafael, if Paul agrees, please consider applying these patches.
> 
> Changes since v3:
> v4 (Almost all of these changes are confined to patch 3):
> 	Reworked the series to use task_lock() instead of RCU.
> 	Reworked the series to use write_string() and read_seq_string()
> 		cgroup methods.

	FYI - This means these patches need Paul's patches introducing
write_string(). I can certainly restore the old code for .read
and .write, but I was anticipating write_string() making it into various
trees first. If that's not necessarily the case please let me know.

Cheers,
	-Matt

