Return-Path: <linux-kernel-owner+w=401wt.eu-S1755971AbZBTKDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbZBTKDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 05:03:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbZBTKDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 05:03:40 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48806 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbZBTKDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 05:03:39 -0500
Date: Fri, 20 Feb 2009 19:02:23 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: menage@google.com, lizf@cn.fujitsu.com,
       containers@lists.linux-foundation.org
Subject: Question for remount
Message-Id: <20090220190223.e8b4f6a8.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Followings are 3 stories of remount cgroup,

1. remount with devices.

 # mount -t cgroup none /cgroups -ocpuacct,release_agent=xxx
 # echo > /cgroups/release_agent #clear release agent by hand
 # mount -t cgroup none /cgroups -oremount,cpuacct
 # cat /cgroups/release_agent
   => release_agent is ""

2. remount without devices, mount command will read /proc/mounts and
   copies option.

 # mount -t cgroup none /cgroups -ocpuacct,release_agent=xxx
 # echo > /cgroups/release_agent      #clear release agent by hand
 # mount /cgroups -oremount,cpuacct   #don't specify device
 # cat /cgroups/release_agent
   => xxx

Hmm, release_agent is copied from /proc/mounts and release_agent revives.

3. remount without devices, mount command will read /proc/mounts
 # mount -t cgroup none /cgroups -ocpuacct,release_agent=xxx
 # mount /cgroups -oremount,cpuacct,release_agent=xxx
 => error
 "release_agent=" will be found twice and this returns -INVAL

maybe case "2" is not ideal, I think. (but it may not be bug.)

My point is following.

1. Documentation/cgroups/cgroup.txt says
   #mount -oremount,cpuset,ns /dev/cgroup
   But this should be
   #mount -tcgroup none /dev/cgroup -oremount,cpuset,ns

2. /proc/mounts information of release_agent should be updated....
   when it's overwritten directly.

3. If "2" is impossible, changing release_agent at remount should not be allowed.

How do you think ?

Thanks,
-Kame

