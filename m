Return-Path: <linux-kernel-owner+w=401wt.eu-S1754315AbYHMF6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbYHMF6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 01:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbYHMF57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 01:57:59 -0400
Received: from gw.goop.org ([64.81.55.164]:57683 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281AbYHMF57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 01:57:59 -0400
Message-ID: <48A277CD.3060300@goop.org>
Date: Tue, 12 Aug 2008 22:57:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] stop_machine: wean Xen off stop_machine_run
References: <200808131552.18942.rusty@rustcorp.com.au>
In-Reply-To: <200808131552.18942.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> This is the last use of (the deprecated) stop_machine_run in the tree.
>   

OK, thanks.

> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>   
Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

> diff -r 332ec042cb4d drivers/xen/manage.c
> --- a/drivers/xen/manage.c	Wed Aug 13 10:48:27 2008 +1000
> +++ b/drivers/xen/manage.c	Wed Aug 13 15:50:02 2008 +1000
> @@ -102,7 +102,7 @@ static void do_suspend(void)
>  	/* XXX use normal device tree? */
>  	xenbus_suspend();
>  
> -	err = stop_machine_run(xen_suspend, &cancelled, 0);
> +	err = stop_machine(xen_suspend, &cancelled, &cpumask_of_cpu(0));
>  	if (err) {
>  		printk(KERN_ERR "failed to start xen_suspend: %d\n", err);
>  		goto out;
>   

