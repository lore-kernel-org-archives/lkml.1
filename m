Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab0CEONo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 09:13:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456Ab0CEONn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 09:13:43 -0500
Date: Fri, 5 Mar 2010 09:13:33 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: jens.axboe@oracle.com, Chad Talbott <ctalbott@google.com>,
       linux-kernel@vger.kernel.org, Nauman Rafique <nauman@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 2/2 V3] io-controller: Document for blkio.weight_device
Message-ID: <20100305141333.GB3296@redhat.com>
References: <4B8DFFD7.2000908@cn.fujitsu.com> <20100303143311.GA2866@redhat.com> <20100303154748.GC2866@redhat.com> <e98e18941003031519v14d4f79cg33da5c3cf1f5ac03@mail.gmail.com> <1786ab031003031825m5467c86jf5c355df10001dd2@mail.gmail.com> <4B8F27BD.2020704@cn.fujitsu.com> <4B8F62B7.3080401@cn.fujitsu.com> <20100304152400.GB18786@redhat.com> <4B906BDF.3090308@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B906BDF.3090308@cn.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 10:26:39AM +0800, Gui Jianfeng wrote:
> Here is the document for blkio.weight_device
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>

Looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> ---
>  Documentation/cgroups/blkio-controller.txt |   35 +++++++++++++++++++++++++++-
>  1 files changed, 34 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/cgroups/blkio-controller.txt b/Documentation/cgroups/blkio-controller.txt
> index 630879c..e551c85 100644
> --- a/Documentation/cgroups/blkio-controller.txt
> +++ b/Documentation/cgroups/blkio-controller.txt
> @@ -76,7 +76,9 @@ CONFIG_DEBUG_BLK_CGROUP
>  Details of cgroup files
>  =======================
>  - blkio.weight
> -	- Specifies per cgroup weight.
> +	- Specifies per cgroup weight. This is default weight of the group
> +	  on all the devices until and unless overridden by per device rule.
> +	  (See blkio.weight_device).
>  
>  	  Currently allowed range of weights is from 100 to 1000.
>  
> @@ -99,6 +101,37 @@ Details of cgroup files
>  	  and minor number of the device and third field specifies the number
>  	  of times a group was dequeued from a particular device.
>  
> +- blkio.weight_device
> +	- One can specify per cgroup per device rules using this interface.
> +	  These rules override the default value of group weight as specified
> +	  by blkio.weight.
> +
> +	  Following is the format.
> +
> +	  #echo dev_maj:dev_minor weight > /pach/to/cgroup/blkio.weight_device
> +
> +	  weight=0 means removing weight on a given device.
> +
> +	  Examples:
> +	  Configure weight=300 on /dev/sdb (8:16) in this cgroup
> +	  # echo 8:16 300 > blkio.weight_device
> +	  # cat blkio.weight_device
> +	  dev     weight
> +	  8:16    300
> +
> +	  Configure weight=500 on /dev/sda (8:0) in this cgroup
> +	  # echo 8:0 500 > blkio.weight_device
> +	  # cat blkio.weight_device
> +	  dev     weight
> +	  8:0     500
> +	  8:16    300
> +
> +	  Remove specific weight for /dev/sda in this cgroup
> +	  # echo 8:0 0 > blkio.weight_device
> +	  # cat blkio.weight_device
> +	  dev     weight
> +	  8:16    300
> +
>  CFQ sysfs tunable
>  =================
>  /sys/block/<disk>/queue/iosched/group_isolation
> -- 
> 1.5.4.rc3
> 
> 
> 
