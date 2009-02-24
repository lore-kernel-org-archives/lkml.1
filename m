Return-Path: <linux-kernel-owner+w=401wt.eu-S1758148AbZBXBin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148AbZBXBin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 20:38:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757925AbZBXBiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 20:38:20 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53533 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904AbZBXBiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 20:38:19 -0500
Date: Tue, 24 Feb 2009 10:36:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       menage@google.com, containers@lists.linux-foundation.org
Subject: Re: Question for remount
Message-Id: <20090224103659.069e6b33.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <49A21044.40402@cn.fujitsu.com>
References: <20090220190223.e8b4f6a8.kamezawa.hiroyu@jp.fujitsu.com>
	<49A20976.2050301@cn.fujitsu.com>
	<49A21044.40402@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Feb 2009 10:56:04 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> Li Zefan wrote:
> >> 1. Documentation/cgroups/cgroup.txt says
> >>    #mount -oremount,cpuset,ns /dev/cgroup
> >>    But this should be
> >>    #mount -tcgroup none /dev/cgroup -oremount,cpuset,ns
> >>
> > 
> > I agree. Actually I noticed this long ago.
> > 
> > Doing this won't remove cpuacct from the cgroup hierarchy:
> > # mount -t cgroup -o cpu,cpuacct xxx /mnt
> > # mount -o remount,cpu /mnt
> > This will get you right:
> > # mount [-t cgroup] -o remount,cpu xxx /mnt
> > 
> 
> How about this patch:
> 
> [PATCH] cgroups: fix documentation about remount
> 
> This won't remove cpuacct from the mounted hierachy:
>  # mount -t cgroup -o cpu,cpuacct xxx /mnt
>  # mount -o remount,cpu /mnt
> 
> Because for this usage mount(8) will append the new options to the current
> options.
> 
> And this will get you right:
>  # mount [-t cgroup] -o remount,cpu xxx /mnt
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  Documentation/cgroups/cgroups.txt |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
> index 93feb84..5cbeab2 100644
> --- a/Documentation/cgroups/cgroups.txt
> +++ b/Documentation/cgroups/cgroups.txt
> @@ -337,8 +337,13 @@ subsystems, type:
>  
>  To change the set of subsystems bound to a mounted hierarchy, just
>  remount with different options:
> +# mount -o remount,cpuset,ns hier1 /dev/cgroup
>  
> -# mount -o remount,cpuset,ns  /dev/cgroup
> +Now numtasks is removed from the hierarchy and ns is added.
> +
> +Note this will add ns to the hierarchy but won't remove numtasks or
> +cpuset:
> +# mount -o remount,ns /dev/cgroup
>  

Just a question. What is "numtasks" here ? We have numtasks cgroup ?

Thanks,
-Kame




>  Note that changing the set of subsystems is currently only supported
>  when the hierarchy consists of a single (root) cgroup. Supporting
> -- 
> 1.5.4.rc3
> 

