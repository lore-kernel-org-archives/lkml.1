Return-Path: <linux-kernel-owner+w=401wt.eu-S1755867AbZGMNmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbZGMNmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 09:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755829AbZGMNmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 09:42:03 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60415 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755822AbZGMNmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 09:42:02 -0400
Date: Mon, 13 Jul 2009 19:11:58 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] taskstats: Fix CGROUPSTATS_TYPE_CGROUP_STATS
	having same value as TASKSTATS_TYPE_PID
Message-ID: <20090713134158.GD5051@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <200907131831.12994.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <200907131831.12994.knikanth@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nikanth Karthikesan <knikanth@suse.de> [2009-07-13 18:31:12]:

> Hi
> 
> Currently we never get message from kernel to userspace of type 
> TASKSTATS_TYPE_PID. Otherwise this could have been spotted earlier.
> 
> I was trying to add a new taskstat command that would return response of type 
> TASKSTATS_TYPE_PID.
> 
> Having the same values would restrict one not to use the same netlink socket 
> for a command that would return response of type TASKSTATS_TYPE_PID and the 
> CGROUPSTATS_CMD_GET command.
> 
> Should we fix it by using values after __TASKSTATS_TYPE_MAX.
> 
> Changing this now might break pre-built binaries. Or is this intended, and the 
> application is not supposed to use CGROUPSTATS and TASKSTATS on the same 
> socket? 
>

Ideally they are supposed to be on different sockets, but nothing
really is hard and fast in terms of rules.
 
> Thanks
> Nikanth
> 
> Currently we never get message from kernel to userspace of type 
> TASKSTATS_TYPE_PID. Otherwise this could have been spotted earlier. Having the 
> values in the same range would restrict one not to use the same netlink socket 
> for a command that would return response of type TASKSTATS_TYPE_PID and the 
> CGROUPSTATS_CMD_GET command. Fix it by using values after 
> __TASKSTATS_TYPE_MAX.
> 
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> 
> ---
> 
> 
> diff --git a/include/linux/cgroupstats.h b/include/linux/cgroupstats.h
> index 3753c33..87b31f0 100644
> --- a/include/linux/cgroupstats.h
> +++ b/include/linux/cgroupstats.h
> @@ -53,7 +53,7 @@ enum {
>  #define CGROUPSTATS_CMD_MAX (__CGROUPSTATS_CMD_MAX - 1)
> 
>  enum {
> -	CGROUPSTATS_TYPE_UNSPEC = 0,	/* Reserved */
> +	CGROUPSTATS_TYPE_UNSPEC = __TASKSTATS_TYPE_MAX,	/* Reserved */
>  	CGROUPSTATS_TYPE_CGROUP_STATS,	/* contains name + stats */
>  	__CGROUPSTATS_TYPE_MAX,
>  };
> 

This seems like the correct fix

Reviewed-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 


-- 
	Balbir
