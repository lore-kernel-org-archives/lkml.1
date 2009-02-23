Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbZBWC10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbZBWC10 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 21:27:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbZBWC1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 21:27:17 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62702 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbZBWC1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 21:27:16 -0500
Message-ID: <49A20976.2050301@cn.fujitsu.com>
Date: Mon, 23 Feb 2009 10:27:02 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       menage@google.com, containers@lists.linux-foundation.org
Subject: Re: Question for remount
References: <20090220190223.e8b4f6a8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090220190223.e8b4f6a8.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1. Documentation/cgroups/cgroup.txt says
>    #mount -oremount,cpuset,ns /dev/cgroup
>    But this should be
>    #mount -tcgroup none /dev/cgroup -oremount,cpuset,ns
> 

I agree. Actually I noticed this long ago.

Doing this won't remove cpuacct from the cgroup hierarchy:
# mount -t cgroup -o cpu,cpuacct xxx /mnt
# mount -o remount,cpu /mnt
This will get you right:
# mount [-t cgroup] -o remount,cpu xxx /mnt

