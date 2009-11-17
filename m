Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116AbZKQSIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbZKQSIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 13:08:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756097AbZKQSIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 13:08:04 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:27635 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971AbZKQSIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 13:08:01 -0500
Subject: Re: [PATCH 16/16] blkio: Documentation
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com, czoccolo@gmail.com
In-Reply-To: <1258134015-21632-17-git-send-email-vgoyal@redhat.com>
References: <1258134015-21632-1-git-send-email-vgoyal@redhat.com>
	 <1258134015-21632-17-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Nov 2009 13:07:59 -0500
Message-ID: <1258481279.6084.295.camel@cail>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-13 at 12:40 -0500, Vivek Goyal wrote:
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  Documentation/cgroups/blkio-controller.txt |  100 ++++++++++++++++++++++++++++
>  1 files changed, 100 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/cgroups/blkio-controller.txt
> 
> diff --git a/Documentation/cgroups/blkio-controller.txt b/Documentation/cgroups/blkio-controller.txt
> new file mode 100644
> index 0000000..6fb772f
> --- /dev/null
> +++ b/Documentation/cgroups/blkio-controller.txt
> @@ -0,0 +1,100 @@
> +				Block IO Controller
> +				===================
> +Overview
> +========
> +cgroup subsys "blkio" implements the block io controller. There seems to be
> +a need of various kind of IO control policies (like proportional BW, max BW)

Change to: "a need for various kinds"

> +both at leaf nodes as well as at intermediate nodes in storage hierarchy. Plan

Change to: "in a storage hierarchy"

> +is to use same cgroup based management interface for blkio controller and

Change to: "use the same cgroup"

> +based on user options switch IO policies in the background.
> +
> +In the first phase, this patchset implements proportional weight time based
> +division of disk policy. It is implemented in CFQ. Hence this policy takes
> +effect only on leaf nodes when CFQ is being used.
> +
> +HOWTO
> +=====
> +You can do a very simple testing of running two dd threads in two different
> +cgroups. Here is what you can do.
> +
> +- Enable group scheduling in CFQ
> +	CONFIG_CFQ_GROUP_IOSCHED=y
> +
> +- Compile and boot into kernel and mount IO controller (blkio).
> +
> +	mount -t cgroup -o blkio none /cgroup
> +
> +- Create two cgroups
> +	mkdir -p /cgroup/test1/ /cgroup/test2
> +
> +- Set weights of group test1 and test2
> +	echo 1000 > /cgroup/test1/blkio.weight
> +	echo 500 > /cgroup/test2/blkio.weight
> +
> +- Create two same size files (say 512MB each) on same disk (file1, file2) and
> +  launch two dd threads in different cgroup to read those files.
> +
> +	sync
> +	echo 3 > /proc/sys/vm/drop_caches
> +
> +	dd if=/mnt/sdb/zerofile1 of=/dev/null &
> +	echo $! > /cgroup/test1/tasks
> +	cat /cgroup/test1/tasks
> +
> +	dd if=/mnt/sdb/zerofile2 of=/dev/null &
> +	echo $! > /cgroup/test2/tasks
> +	cat /cgroup/test2/tasks
> +
> +- At macro level, first dd should finish first. To get more precise data, keep
> +  on looking at (with the help of script), at blkio.disk_time and

Change to: "on looking at blkio.disk_time and"

> +  blkio.disk_sectors files of both test1 and test2 groups. This will tell how
> +  much disk time (in milli seconds), each group got and how many secotors each

Change to: "much disk time (in milliseconds) each group got and how many
sectors each"

> +  group dispatched to the disk. We provide fairness in terms of disk time, so
> +  ideally io.disk_time of cgroups should be in proportion to the weight.

Change to: "ideally the io.disk_time of each cgroup should be in
proportion to its weight."

