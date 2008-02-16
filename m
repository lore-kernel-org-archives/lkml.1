Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbYBPIr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbYBPIr4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 03:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbYBPIrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 03:47:47 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:36086 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbYBPIrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 03:47:46 -0500
Date: Sat, 16 Feb 2008 10:47:23 +0200
From: Adrian Bunk <bunk@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, dipankar@in.ibm.com
Subject: Re: [PATCH] Add list_for_each_rcu to features-removal list
Message-ID: <20080216084723.GD9962@cs181133002.pp.htv.fi>
References: <20080128122500.GA32723@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080128122500.GA32723@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 04:25:00AM -0800, Paul E. McKenney wrote:
> Hello!
> 
> The list_for_each_entry_rcu() primitive should be used instead of
> list_for_each_rcu(), as the former is easier to use and provides
> better type safety.  This patch therefore adds list_for_each_rcu()
> to the Documentation/feature-removal-schedule.txt file (for mid-2008)
> and marks its comment header deprecated.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
> 
>  Documentation/feature-removal-schedule.txt |   10 ++++++++++
>  include/linux/list.h                       |    5 ++++-
>  2 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff -urpNa -X dontdiff linux-2.6.24/Documentation/feature-removal-schedule.txt linux-2.6.24-dep-lfeRCU/Documentation/feature-removal-schedule.txt
> --- linux-2.6.24/Documentation/feature-removal-schedule.txt	2008-01-24 14:58:37.000000000 -0800
> +++ linux-2.6.24-dep-lfeRCU/Documentation/feature-removal-schedule.txt	2008-01-28 04:00:49.000000000 -0800
> @@ -333,3 +333,13 @@ Why:	This driver has been marked obsolet
>  Who:	Stephen Hemminger <shemminger@linux-foundation.org>
>  
>  ---------------------------
> +
> +What:	list_for_each_rcu() primitive
> +When:	July 2008
> +Files:	include/linux/list.h
> +Why:	The list_for_each_entry_rcu() primitive should be used instead,
> +	as it is less error-prone and provides better type safety.
> +Who:	Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>...

Declaring something as deprecated doesn't automatically convert the 
in-kernel users.

And once there are no in-kernel users left you can kill it immediately.

The only working way for getting rid of list_for_each_rcu() is:
- send patches for all in-kernel usages to the maintainers of the code
  in question now
- once all of these patches have entered Linus' tree (which might not
  be before the 2.6.26 merge window) you can remove list_for_each_rcu()

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

