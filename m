Return-Path: <linux-kernel-owner+w=401wt.eu-S1764220AbXLUDPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764220AbXLUDPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 22:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754761AbXLUDPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 22:15:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37139
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753324AbXLUDPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 22:15:06 -0500
Date: Thu, 20 Dec 2007 19:15:05 -0800 (PST)
Message-Id: <20071220.191505.122863242.davem@davemloft.net>
To: mpm@selenic.com
Cc: m.kozlowski@tuxland.pl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: 2.6.24-rc5-mm1: problems with cat /proc/kpageflags
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071221010653.GA19691@waste.org>
References: <200712202047.56745.m.kozlowski@tuxland.pl>
	<20071220.161726.68534356.davem@davemloft.net>
	<20071221010653.GA19691@waste.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Mackall <mpm@selenic.com>
Date: Thu, 20 Dec 2007 19:06:55 -0600

> @@ -707,7 +707,10 @@ static ssize_t kpagecount_read(struct fi
>  		return -EIO;
>  
>  	while (count > 0) {
> -		ppage = pfn_to_page(pfn++);
> +		ppage = 0;
> +		if (pfn_valid(pfn))
> +			ppage = pfn_to_page(pfn);
> +		pfn++;
>  		if (!ppage)
>  			pcount = 0;
>  		else

Yes that should work, please use "NULL" in the final
version of the patch instead of "0" so that sparse is
happy.

Thanks.
