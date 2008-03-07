Return-Path: <linux-kernel-owner+w=401wt.eu-S1762087AbYCGQll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762087AbYCGQll (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 11:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757754AbYCGQlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 11:41:32 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:15117 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756466AbYCGQlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 11:41:31 -0500
Date: Fri, 7 Mar 2008 08:34:52 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][v2] Modify loop device to be able to manage partitions
 of the disk image
Message-Id: <20080307083452.b403fedf.randy.dunlap@oracle.com>
In-Reply-To: <12048928601734-git-send-email-Laurent.Vivier@bull.net>
References: <12048928601734-git-send-email-Laurent.Vivier@bull.net>
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

On Fri,  7 Mar 2008 13:27:40 +0100 Laurent Vivier wrote:

> This patch allows to use loop device with partitionned disk image.
> 
> Original behavior of loop is not modified.
> 
> A new parameter is introduced to define how many partition we want to be
> able to manage per loop device. This parameter is "loop_max_part".
> 
>  __setup("max_loop=", max_loop_setup);
> +
> +static int __init max_part_setup(char *str)
> +{
> +	loop_max_part = simple_strtol(str, NULL, 0);
> +	if (loop_max_part > (1UL << (MINORBITS - 1))) {
> +		/* we must keep at least one bit for loop device number */
> +		printk(KERN_ERR
> +			"loop: loop_max_part cannot be greater than %d\n",

That %d should be %lu, otherwise gcc says:

drivers/block/loop.c:1594: warning: format '%d' expects type 'int', but ar
gument 2 has type 'long unsigned int

> +			1UL << (MINORBITS - 1));
> +		return 0;
> +	}
> +	return 1;
> +}
> +
> +__setup("loop_max_part=", max_part_setup);
>  #endif

---
~Randy
