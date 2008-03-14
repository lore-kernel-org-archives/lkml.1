Return-Path: <linux-kernel-owner+w=401wt.eu-S1757625AbYCNBg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625AbYCNBg1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 21:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757127AbYCNBgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 21:36:17 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59807 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756949AbYCNBgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 21:36:16 -0400
Date: Fri, 14 Mar 2008 10:39:53 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, mingo@elte.hu,
       clameter@sgi.com, linux-kernel@vger.kernel.org,
       "Andi Kleen" <ak@suse.de>, "Yasunori Goto" <y-goto@jp.fujitsu.com>
Subject: Re: [PATCH] mm: make free_bootmem to loop bdata_list
Message-Id: <20080314103953.70be95b1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <86802c440803131153m325c9e04h43bfd25b667a5c04@mail.gmail.com>
References: <86802c440803131153m325c9e04h43bfd25b667a5c04@mail.gmail.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 11:53:31 -0700
"Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
> ===================================================================
> --- linux-2.6.orig/mm/bootmem.c
> +++ linux-2.6/mm/bootmem.c
> @@ -427,7 +438,9 @@ int __init reserve_bootmem(unsigned long
>  
>  void __init free_bootmem(unsigned long addr, unsigned long size)
>  {
> -	free_bootmem_core(NODE_DATA(0)->bdata, addr, size);
> +	bootmem_data_t *bdata;
> +	list_for_each_entry(bdata, &bdata_list, list)
> +		free_bootmem_core(bdata, addr, size);
>  }


Just a confirmation.
In above loop, boundary check in free_bootmem_core() hits two or more times ?
If yes, it's ok.
If no, please exit loop at hit.

Thanks,
-Kame
 

