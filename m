Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbZBXElq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbZBXElq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 23:41:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753921AbZBXEl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 23:41:27 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49570 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbZBXEl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 23:41:26 -0500
Date: Tue, 24 Feb 2009 13:39:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] cgroups: more documentation for remount and
 release_agent
Message-Id: <20090224133958.597e7788.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <49A35C91.6000904@cn.fujitsu.com>
References: <49A35C91.6000904@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Feb 2009 10:33:53 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> This won't remove cpuacct from the mounted hierachy:
>  # mount -t cgroup -o cpu,cpuacct xxx /mnt
>  # mount -o remount,cpu /mnt
> 
> Because for this usage mount(8) will append the new options to the original
> options.
> 
> And this will get you right:
>  # mount [-t cgroup] -o remount,cpu xxx /mnt
> 
> Also document how to specify or change release_agent.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Seems nice!
Thank you.
Reviewd-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ---
>  Documentation/cgroups/cgroups.txt |   20 ++++++++++++++++++--
>  1 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
> index 93feb84..df295c6 100644
> --- a/Documentation/cgroups/cgroups.txt
> +++ b/Documentation/cgroups/cgroups.txt
> @@ -333,12 +333,23 @@ The "xxx" is not interpreted by the cgroup code, but will appear in
>  
>  To mount a cgroup hierarchy with just the cpuset and numtasks
>  subsystems, type:
> -# mount -t cgroup -o cpuset,numtasks hier1 /dev/cgroup
> +# mount -t cgroup -o cpuset,memory hier1 /dev/cgroup
>  
>  To change the set of subsystems bound to a mounted hierarchy, just
>  remount with different options:
> +# mount -o remount,cpuset,ns hier1 /dev/cgroup
>  
> -# mount -o remount,cpuset,ns  /dev/cgroup
> +Now memory is removed from the hierarchy and ns is added.
> +
> +Note this will add ns to the hierarchy but won't remove memory or
> +cpuset, because the new options are appended to the old ones:
> +# mount -o remount,ns /dev/cgroup
> +
> +To Specify a hierarchy's release_agent:
> +# mount -t cgroup -o cpuset,release_agent="/sbin/cpuset_release_agent" \
> +  xxx /dev/cgroup
> +
> +Note that specifying 'release_agent' more than once will return failure.
>  
>  Note that changing the set of subsystems is currently only supported
>  when the hierarchy consists of a single (root) cgroup. Supporting
> @@ -349,6 +360,11 @@ Then under /dev/cgroup you can find a tree that corresponds to the
>  tree of the cgroups in the system. For instance, /dev/cgroup
>  is the cgroup that holds the whole system.
>  
> +If you want to change the value of release_agent:
> +# echo "/sbin/new_release_agent" > /dev/cgroup/release_agent
> +
> +It can also be changed via remount.
> +
>  If you want to create a new cgroup under /dev/cgroup:
>  # cd /dev/cgroup
>  # mkdir my_cgroup
> -- 
> 1.5.4.rc3
> 
> 

