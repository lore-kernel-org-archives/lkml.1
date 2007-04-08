Return-Path: <linux-kernel-owner+w=401wt.eu-S966047AbXDHDmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966047AbXDHDmc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 23:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966045AbXDHDmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 23:42:31 -0400
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:53366 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966047AbXDHDma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 23:42:30 -0400
Message-ID: <461864D3.7050407@lwfinger.net>
Date: Sat, 07 Apr 2007 22:43:15 -0500
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: LKML <linux-kernel@vger.kernel.org>, rusty@rustcorp.com.au
Subject: Re: [PATCH] Re: kernel oops with badly formatted module option
References: <4618356D.70303@lwfinger.net> <20070407194700.38138108.randy.dunlap@oracle.com>
In-Reply-To: <20070407194700.38138108.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Sat, 07 Apr 2007 19:21:01 -0500 Larry Finger wrote:
> 
>> With the following line in /etc/modprobe.conf.local:
>>
>> options bcm43xx fwpostfix = ".fw3" locale=8
>>
>> the kernel oops below is generated. I realize that the line should have no whitespace around the 
>> "=", but I do not feel that an oops is the best way to report the syntax error. Could there be a more gentle failure?
> 
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Catch malformed kernel parameter usage of "param = value".
> Spaces are not supported, but don't cause a kernel fault on
> such usage, just report an error.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
It works here.  ACKed by: Larry Finger <Larry.Finger@lwfinger.net>

> ---
>  kernel/params.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> --- linux-2.6.21-rc6.orig/kernel/params.c
> +++ linux-2.6.21-rc6/kernel/params.c
> @@ -356,6 +356,10 @@ int param_set_copystring(const char *val
>  {
>  	struct kparam_string *kps = kp->arg;
>  
> +	if (!val) {
> +		printk(KERN_ERR "%s: missing param set value\n", kp->name);
> +		return -EINVAL;
> +	}
>  	if (strlen(val)+1 > kps->maxlen) {
>  		printk(KERN_ERR "%s: string doesn't fit in %u chars.\n",
>  		       kp->name, kps->maxlen-1);
> 

