Return-Path: <linux-kernel-owner+w=401wt.eu-S1751371AbZHXDL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371AbZHXDL3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 23:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbZHXDL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 23:11:29 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:56007 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbZHXDL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 23:11:28 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Message-id: <4A9204B4.2030800@acm.org>
Date: Sun, 23 Aug 2009 22:10:44 -0500
From: Corey Minyard <minyard@acm.org>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
To: =?ISO-8859-1?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>
Cc: Jiri Kosina <trivial@kernel.org>, openipmi-developer@lists.sourceforge.net,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Openipmi-developer] [PATCH] char/impi: adding __init macro/ fix
 of	__exit macro location in ipmi_poweroff.c
References: <200908230146.56283.PeterHuewe@gmx.de>
In-reply-to: <200908230146.56283.PeterHuewe@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is correct, I'm fine with it going through the trivial tree.  Thanks.

Acked-by: Corey Minyard <minyard@acm.org>

Peter Hüwe wrote:
> From: Peter Huewe <peterhuewe@gmx.de>
>
> Trivial patch which adds the __init to the module_init function of
> drivers/char/ipmi/ipmy_poweroff.c and corrects the location of __exit for the
> cleanup function.
>
> According to ldd3, page 31 the __exit token hast to be after the return type.
> Or am I getting something wrong here?
>
> Corey, please have a look at the small patch and either pull it through
> your tree, or please ack' it so Jiri can pull it through the trivial tree.
>
> linux version 2.6.31-rc6 - linus git tree, So 23. Aug 01:38:43 CEST 2009
>
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
> diff --git a/drivers/char/ipmi/ipmi_poweroff.c b/drivers/char/ipmi/ipmi_poweroff.c
> index a261bd7..2e66b5f 100644
> --- a/drivers/char/ipmi/ipmi_poweroff.c
> +++ b/drivers/char/ipmi/ipmi_poweroff.c
> @@ -691,7 +691,7 @@ static struct ctl_table_header *ipmi_table_header;
>  /*
>   * Startup and shutdown functions.
>   */
> -static int ipmi_poweroff_init(void)
> +static int __init ipmi_poweroff_init(void)
>  {
>  	int rv;
>  
> @@ -725,7 +725,7 @@ static int ipmi_poweroff_init(void)
>  }
>  
>  #ifdef MODULE
> -static __exit void ipmi_poweroff_cleanup(void)
> +static void __exit ipmi_poweroff_cleanup(void)
>  {
>  	int rv;
>  
>
> ------------------------------------------------------------------------------
> Let Crystal Reports handle the reporting - Free Crystal Reports 2008 30-Day 
> trial. Simplify your report design, integration and deployment - and focus on 
> what you do best, core application coding. Discover what's new with 
> Crystal Reports now.  http://p.sf.net/sfu/bobj-july
> _______________________________________________
> Openipmi-developer mailing list
> Openipmi-developer@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/openipmi-developer
>
>   

