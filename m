Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933474Ab0BPWXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 17:23:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933260Ab0BPWXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 17:23:05 -0500
Message-ID: <4B7B1AA9.9040609@redhat.com>
Date: Tue, 16 Feb 2010 17:22:33 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: tracking memory usage/leak in "inactive" field in /proc/meminfo?
References: <4B71927D.6030607@nortel.com>	 <20100210093140.12D9.A69D9226@jp.fujitsu.com>	 <4B72E74C.9040001@nortel.com>	 <28c262361002101645g3fd08cc7t6a72d27b1f94db62@mail.gmail.com>	 <4B74524D.8080804@nortel.com> <28c262361002111838q7db763feh851a9bea4fdd9096@mail.gmail.com> <4B7504D2.1040903@nortel.com> <4B796D31.7030006@nortel.com> <4B797D93.5090307@redhat.com> <4B7ACD4A.10101@nortel.com> <4B7AD207.20604@redhat.com> <4B7B0D75.50808@nortel.com>
In-Reply-To: <4B7B0D75.50808@nortel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2010 04:26 PM, Chris Friesen wrote:

> For the backtrace scenario I posted it seems like it might actually be
> release_pages().  There seems to be a plausible call chain:
>
> __ClearPageLRU
> release_pages
> free_pages_and_swap_cache
> tlb_flush_mmu
> tlb_remove_page
> zap_pte_range
>
> Does that seem right?  In this case, tlb_remove_page() is called right
> after page_remove_rmap() which ultimately results in clearing the
> PageAnon bit.

That is right - and pinpoints the fault for the memory leak
on some third party code that fails to release a refcount on
memory pages.

-- 
All rights reversed.
