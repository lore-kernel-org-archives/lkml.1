Return-Path: <linux-kernel-owner+w=401wt.eu-S1755429AbYCNBaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbYCNBaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 21:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbYCNBao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 21:30:44 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57633 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbYCNBan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 21:30:43 -0400
Date: Fri, 14 Mar 2008 10:34:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Andi Kleen" <ak@suse.de>, "Christoph Lameter" <clameter@sgi.com>,
       linux-kernel@vger.kernel.org, "Yasunori Goto" <y-goto@jp.fujitsu.com>
Subject: Re: [PATCH] mm: make reserve_bootmem can crossed the nodes
Message-Id: <20080314103431.ff07070c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <86802c440803131645q1eb31cb7jb0774d9cf67c767@mail.gmail.com>
References: <86802c440803131645q1eb31cb7jb0774d9cf67c767@mail.gmail.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 16:45:42 -0700
"Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
> int __init reserve_bootmem(unsigned long addr, unsigned long size,
>  			    int flags)
>  {
> -	return reserve_bootmem_core(NODE_DATA(0)->bdata, addr, size, flags);
> +	int ret;
> +	bootmem_data_t *bdata;
> +	list_for_each_entry(bdata, &bdata_list, list) {
> +		ret = can_reserve_bootmem_core(bdata, addr, size, flags);
> +		if (ret < 0)
> +			return ret;
> +	}
> +	list_for_each_entry(bdata, &bdata_list, list)
> +		reserve_bootmem_core(bdata, addr, size, flags);
> +	return 0;
>  }

why list_for_each twice ?

Thanks,
-Kame

