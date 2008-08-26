Return-Path: <linux-kernel-owner+w=401wt.eu-S1753330AbYHZXzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbYHZXzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 19:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbYHZXzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 19:55:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37036 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751887AbYHZXzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 19:55:42 -0400
Date: Tue, 26 Aug 2008 16:55:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bruce Leonard <brucle@earthlink.net>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       linux-mtd@lists.infradead.org
Subject: Re: [PATCH 2/2][MTD] Add support for > 2GiB MTD devices
Message-Id: <20080826165536.61c25a67.akpm@linux-foundation.org>
In-Reply-To: <25387440.1219370455174.JavaMail.root@elwamui-cypress.atl.sa.earthlink.net>
References: <25387440.1219370455174.JavaMail.root@elwamui-cypress.atl.sa.earthlink.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2008 19:00:55 -0700 (GMT-07:00)
Bruce Leonard <brucle@earthlink.net> wrote:

> --- a/include/mtd/mtd-abi.h
> +++ b/include/mtd/mtd-abi.h
> @@ -6,7 +6,7 @@
>  #define __MTD_ABI_H__
>  
>  struct erase_info_user {
> -	uint32_t start;
> +	uint64_t start;
>  	uint32_t length;
>  };
>  
> @@ -50,7 +50,7 @@ struct mtd_oob_buf {
>  struct mtd_info_user {
>  	uint8_t type;
>  	uint32_t flags;
> -	uint32_t size;	 // Total size of the MTD
> +	uint64_t size;	 // Total size of the MTD
>  	uint32_t erasesize;
>  	uint32_t writesize;
>  	uint32_t oobsize;   // Amount of OOB data per block (e.g. 16)

This changes the kernel<->userspace ABI and is hence a big no-no.  I
assume that this change will cause old userspace to malfunction on new
kernels, and vice versa.

Supporting >2Gb MTD devices sounds useful (I'm surprised that we don't
already do so).

Please cc linux-mtd@lists.infradead.org (at least) on MTD-related
patches, thanks.

