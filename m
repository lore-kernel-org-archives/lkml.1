Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbYABCJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbYABCJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 21:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbYABCJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 21:09:04 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:46840 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbYABCJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 21:09:03 -0500
Date: Tue, 1 Jan 2008 18:07:51 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] the scheduled 'time' option removal
Message-Id: <20080101180751.9d31262b.randy.dunlap@oracle.com>
In-Reply-To: <20080101134656.GG2360@does.not.exist>
References: <20080101134656.GG2360@does.not.exist>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jan 2008 15:46:56 +0200 Adrian Bunk wrote:

> This patch contains the scheduled removal of the 'time' option.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Thanks.  Looks good except that Documentation/kernel-parameters.txt
needs a patch also:  delete these 3 lines:

	time		Show timing data prefixed to each printk message line
			[deprecated, see 'printk.time']

then I will Ack it.

> ---
> 
>  Documentation/feature-removal-schedule.txt |    8 --------
>  kernel/printk.c                            |   13 -------------
>  2 files changed, 21 deletions(-)
> 
> c0ea16c447460698c0e85963310c38fa051f0e23 
> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> index 20c4c8b..93aac19 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -233,10 +233,2 @@ Who:	Jean Delvare <khali@linux-fr.org>
>  ---------------------------
> -
> -What:	'time' kernel boot parameter
> -When:	January 2008
> -Why:	replaced by 'printk.time=<value>' so that printk timestamps can be
> -	enabled or disabled as needed
> -Who:	Randy Dunlap <randy.dunlap@oracle.com>
> -
> ----------------------------
>  
> diff --git a/kernel/printk.c b/kernel/printk.c
> index a30fe33..296c4ea 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -560,15 +560,2 @@ static int printk_time = 0;
>  module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
> -
> -static int __init printk_time_setup(char *str)
> -{
> -	if (*str)
> -		return 0;
> -	printk_time = 1;
> -	printk(KERN_NOTICE "The 'time' option is deprecated and "
> -		"is scheduled for removal in early 2008\n");
> -	printk(KERN_NOTICE "Use 'printk.time=<value>' instead\n");
> -	return 1;
> -}
> -
> -__setup("time", printk_time_setup);


---
~Randy
desserts:  http://www.xenotime.net/linux/recipes/
