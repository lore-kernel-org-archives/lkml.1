Return-Path: <linux-kernel-owner+w=401wt.eu-S1759515AbXGDDrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759515AbXGDDrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 23:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755302AbXGDDrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 23:47:09 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:60690 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755215AbXGDDrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 23:47:08 -0400
Date: Tue, 3 Jul 2007 23:47:06 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Tom Zanussi <zanussi@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com, dwilder@us.ibm.com,
       hunt@redhat.com
Subject: Re: [RFC PATCH 2/3] Generic Trace Setup and Control (GTSC) code
Message-ID: <20070704034706.GA26381@Krystal>
References: <1183173872.24291.144.camel@ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1183173872.24291.144.camel@ubuntu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:43:54 up 2 days, 22:26,  2 users,  load average: 0.54, 0.57, 0.38
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Tom Zanussi (zanussi@us.ibm.com) wrote:
> The Generic Tracing and Control Interface (GTSC) code.
> 
> Signed-off-by: Tom Zanussi <zanussi@us.ibm.com>
> Signed-off-by: David Wilder <dwilder@us.ibm.com>
> ---
>  include/linux/gtsc.h |  104 +++++++++
>  lib/Kconfig          |   10 
>  lib/Makefile         |    2 
>  lib/gtsc.c           |  558 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 674 insertions(+)
> 
....
> +static ssize_t reset_consumed_write(struct file *filp,
> +				    const char __user *buffer,
> +				    size_t count,
> +				    loff_t *ppos)
> +{
> +	struct trace_info *trace = filp->private_data;
> +
> +	relay_reset_consumed(trace->rchan);
> +
> +	return count;
> +}
> +
> +struct file_operations reset_consumed_fops = {
> +	.owner	= THIS_MODULE,
> +	.open	= reset_consumed_open,
> +	.write	= reset_consumed_write
> +};
> +

Quoting the header of relay_reset_consumed:

+ *     NOTE: Care should be taken that the channel isn't actually
+ *     being used by anything when this call is made.

I can imagine relay saying "locking is not my problem", while GTSC
whistle and looks away... ;)


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
