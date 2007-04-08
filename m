Return-Path: <linux-kernel-owner+w=401wt.eu-S1751121AbXDHD7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121AbXDHD7Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 23:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbXDHD7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 23:59:24 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:64622 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbXDHD7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 23:59:23 -0400
Date: Sat, 7 Apr 2007 21:01:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Cc: aeb@cwi.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] partitions: Add conditionals and static inline
 stubs to helpers in headers
Message-Id: <20070407210108.66cdb32f.randy.dunlap@oracle.com>
In-Reply-To: <alpine.DEB.0.83.0704072340100.27057@sigma.j-a-k-j.com>
References: <alpine.DEB.0.83.0704072235180.27057@sigma.j-a-k-j.com>
	<alpine.DEB.0.83.0704072340100.27057@sigma.j-a-k-j.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Apr 2007 23:40:50 -0400 (EDT) John Anthony Kazos Jr. wrote:

> From: John Anthony Kazos Jr. <jakj@j-a-k-j.com>
> 
> Functions of the form adfspart_check_FOO and foo_partition defined in 
> fs/partitions/*.h are helper functions called in a deliberate order by 
> check_partition in check.c. Add conditional-compilation directives and 
> static inline no-op functions to allow code to indiscriminately call these 
> functions irrespective of whether they do anything, removing the necessity 
> of oodles of #ifdef/#endif in function bodies.
> 
> Signed-off-by: John Anthony Kazos Jr. <jakj@j-a-k-j.com>
> 
> ---
> 
> The next patch changes the check.c code to use these function definitions 
> in a nicer way.
> 
> --- linux-2.6.20.6-orig/fs/partitions/acorn.h	2007-04-06 16:02:48.000000000 -0400
> +++ linux-2.6.20.6-mod/fs/partitions/acorn.h	2007-04-07 20:02:51.000000000 -0400

Send patches against the latest Linus-tree unless the patches are
specifically for the -stable branch (where 2.6.20.y is -stable
and 2.6.21-rc6 or -git is Linus).  (Maybe it won't matter for
these patches....)

See Andrew's The Perfect Patch for more info:
  http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt


> @@ -7,8 +7,47 @@
>   *  format, and everyone stick to it?
>   */
>  
> -int adfspart_check_CUMANA(struct parsed_partitions *state, struct block_device *bdev);
> -int adfspart_check_ADFS(struct parsed_partitions *state, struct block_device *bdev);
> -int adfspart_check_ICS(struct parsed_partitions *state, struct block_device *bdev);
> -int adfspart_check_POWERTEC(struct parsed_partitions *state, struct block_device *bdev);
> -int adfspart_check_EESOX(struct parsed_partitions *state, struct block_device *bdev);
> +#ifdef CONFIG_ACORN_PARTITION_ICS
> +	int adfspart_check_ICS(struct parsed_partitions *state, struct block_device *bdev);
> +#else
> +	static inline int adfspart_check_ICS(struct parsed_partitions *state, struct block_device *bdev)
> +	{
> +		return 0;
> +	}
> +#endif
> +
> +#ifdef CONFIG_ACORN_PARTITION_POWERTEC
> +	int adfspart_check_POWERTEC(struct parsed_partitions *state, struct block_device *bdev);
> +#else
> +	static inline int adfspart_check_POWERTEC(struct parsed_partitions *state, struct block_device *bdev)
> +	{
> +		return 0;
> +	}
> +#endif

We don't indent functions inside ifdef/else/endif blocks.
Just act as though the preprocessor lines are not there.
(That's our current common practice; I don't see that documented
anywhere.)


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
