Return-Path: <linux-kernel-owner+w=401wt.eu-S1760356AbYFBMe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760356AbYFBMe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 08:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760168AbYFBMem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 08:34:42 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57006 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760212AbYFBMel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 08:34:41 -0400
Date: Mon, 02 Jun 2008 21:34:02 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Johannes Weiner <hannes@saeurebad.de>
Subject: Re: [PATCH -mm 08/14] bootmem: clean up alloc_bootmem_core
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20080530194738.789921715@saeurebad.de>
References: <20080530194220.286976884@saeurebad.de> <20080530194738.789921715@saeurebad.de>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080602210058.B2E2.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

> +		/*
> +		 * Reserve the area now:
> +		 */
> +		for (i = PFN_DOWN(new_start) + merge; i < PFN_UP(new_end); i++)
> +			if (test_and_set_bit(i, bdata->node_bootmem_map))
> +				BUG();
> +
> +		region = phys_to_virt(bdata->node_boot_start + new_start);
> +		memset(region, 0, size);
> +		return region;

bdata->last_success doesn't seem to be updated in alloc_bootmem_core(),
it is updated in only __free().
Is it intended? If not, it should be updated, I suppose....

Bye.

-- 
Yasunori Goto 


