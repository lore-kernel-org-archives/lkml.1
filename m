Return-Path: <linux-kernel-owner+w=401wt.eu-S933667AbXHVUu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933667AbXHVUu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 16:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933398AbXHVUus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 16:50:48 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54308 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932990AbXHVUur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 16:50:47 -0400
Date: Wed, 22 Aug 2007 13:50:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Christoph Lameter <clameter@sgi.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-mm@kvack.org
Subject: Re: [BUG] 2.6.23-rc3-mm1 kernel BUG at mm/page_alloc.c:2876!
Message-Id: <20070822135024.dde8ef5a.akpm@linux-foundation.org>
In-Reply-To: <20070822134800.ce5a5a69.akpm@linux-foundation.org>
References: <46CC9A7A.2030404@linux.vnet.ibm.com>
	<20070822134800.ce5a5a69.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007 13:48:00 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> This:
> 
> --- a/mm/page_alloc.c~a
> +++ a/mm/page_alloc.c
> @@ -2814,6 +2814,8 @@ static int __cpuinit process_zones(int c
>  	return 0;
>  bad:
>  	for_each_zone(dzone) {
> +		if (!populated_zone(zone))
> +			continue;		
>  		if (dzone == zone)
>  			break;
>  		kfree(zone_pcp(dzone, cpu));
> _
> 
> might help avoid the crash

err, make that

--- a/mm/page_alloc.c~a
+++ a/mm/page_alloc.c
@@ -2814,6 +2814,8 @@ static int __cpuinit process_zones(int c
 	return 0;
 bad:
 	for_each_zone(dzone) {
+		if (!populated_zone(dzone))
+			continue;
 		if (dzone == zone)
 			break;
 		kfree(zone_pcp(dzone, cpu));
_


