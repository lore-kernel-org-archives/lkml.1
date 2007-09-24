Return-Path: <linux-kernel-owner+w=401wt.eu-S1757318AbXIXIWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318AbXIXIWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 04:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbXIXIWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 04:22:31 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:6810
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751558AbXIXIWb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 04:22:31 -0400
Message-Id: <46F79021.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 24 Sep 2007 09:23:29 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <patches@x86-64.org>
Subject: Re: [patches] [PATCH] [13/50] x86: Fix and reenable CLFLUSH
	support inchange_page_attr()
References: <200709221231.836138000@suse.de>
 <20070921223211.BB50413DCD@wotan.suse.de>
In-Reply-To: <20070921223211.BB50413DCD@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>@@ -162,7 +198,7 @@ __change_page_attr(unsigned long address
> 	/* on x86-64 the direct mapping set at boot is not using 4k pages */
>  	BUG_ON(PageReserved(kpte_page));
> 
>-	save_page(kpte_page);
>+	save_page(kpte_page, 0);
> 	if (page_private(kpte_page) == 0)
> 		revert_page(address, ref_prot);
> 	return 0;

What is the point of continuing to launder kpte_page here? Page table pages
never get their caching attributes changed, nor would their direct mapping
ever change. (Same for i386, obviously.)

Jan

