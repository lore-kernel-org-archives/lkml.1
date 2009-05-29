Return-Path: <linux-kernel-owner+w=401wt.eu-S1752696AbZE2EQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbZE2EQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 00:16:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbZE2EP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 00:15:59 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:40472 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbZE2EP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 00:15:58 -0400
X-AuditID: b753bd60-a7cf8ba00000617e-4f-4a1f617d549a
Message-ID: <4A1F6166.4020006@hitachi.com>
Date: Fri, 29 May 2009 13:15:34 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
       Taketoshi Sakuraba <taketoshi.sakuraba.hc@hitachi.com>
Subject: Re: [PATCH] [6/16] HWPOISON: Add basic support for poisoned pages in
    fault handler v2
References: <200905271012.668777061@firstfloor.org> 
    <20090527201232.555281D0290@basil.firstfloor.org>
In-Reply-To: <20090527201232.555281D0290@basil.firstfloor.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:

> - Add a new VM_FAULT_HWPOISON error code to handle_mm_fault. Right now
> architectures have to explicitely enable poison page support, so
> this is forward compatible to all architectures. They only need
> to add it when they enable poison page support.
> - Add poison page handling in swap in fault code
> 
> v2: Add missing delayacct_clear_flag (Hidehiro Kawai)

[snip]

>  		goto out;
>  	}
>  	delayacct_set_flag(DELAYACCT_PF_SWAPIN);
> @@ -2484,6 +2492,10 @@
>  		/* Had to read the page from swap area: Major fault */
>  		ret = VM_FAULT_MAJOR;
>  		count_vm_event(PGMAJFAULT);
> +	} else if (PageHWPoison(page)) {
> +		ret = VM_FAULT_HWPOISON;
> +		delayacct_set_flag(DELAYACCT_PF_SWAPIN);
> +		goto out;

Is this delayacct_clear_flag()? :-p

Regards,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center

