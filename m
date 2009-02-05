Return-Path: <linux-kernel-owner+w=401wt.eu-S1758587AbZBEJVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587AbZBEJVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 04:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbZBEJV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 04:21:29 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44562
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752466AbZBEJV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 04:21:28 -0500
Date: Thu, 05 Feb 2009 01:21:23 -0800 (PST)
Message-Id: <20090205.012123.141238531.davem@davemloft.net>
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: mel@csn.ul.ie, heiko.carstens@de.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: HOLES_IN_ZONE...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090205180617.8ee3dfb5.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090204.222651.26527737.davem@davemloft.net>
	<20090205180617.8ee3dfb5.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 5 Feb 2009 18:06:17 +0900

> @@ -2632,7 +2633,8 @@ void __meminit memmap_init_zone(unsigned
>  		if (context == MEMMAP_EARLY) {
>  			if (!early_pfn_valid(pfn))
>  				continue;
> -			if (!early_pfn_in_nid(pfn, nid))
> +			tmp = early_pfn_in_nid(pfn, nid);
> +			if (tmp > -1 && tmp != nid)

early_pfn_in_nid() returns true or false, not the found nid

I think you meant to change this to call early_pfn_to_nid()

I'll make that correction and test your patch.

BTW, if you make that conversion there is no need for
early_pfn_in_nid() since there will be no other users.
