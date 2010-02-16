Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776Ab0BPRM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 12:12:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756014Ab0BPRM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 12:12:58 -0500
Message-ID: <4B7AD207.20604@redhat.com>
Date: Tue, 16 Feb 2010 12:12:39 -0500
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
References: <4B71927D.6030607@nortel.com>	 <20100210093140.12D9.A69D9226@jp.fujitsu.com>	 <4B72E74C.9040001@nortel.com>	 <28c262361002101645g3fd08cc7t6a72d27b1f94db62@mail.gmail.com>	 <4B74524D.8080804@nortel.com> <28c262361002111838q7db763feh851a9bea4fdd9096@mail.gmail.com> <4B7504D2.1040903@nortel.com> <4B796D31.7030006@nortel.com> <4B797D93.5090307@redhat.com> <4B7ACD4A.10101@nortel.com>
In-Reply-To: <4B7ACD4A.10101@nortel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2010 11:52 AM, Chris Friesen wrote:
> On 02/15/2010 11:00 AM, Rik van Riel wrote:

>> Removal from the LRU is done from the page freeing code, on
>> the final free of the page.

> There are a bunch of inline functions involved, but I think the chain
> from page_remove_rmap() back up to unmap_vmas() looks like this:
>
> page_remove_rmap
> zap_pte_range
> zap_pmd_range
> zap_pud_range
> unmap_page_range
> unmap_vmas
>
> So in this scenario, where do the pages actually get removed from the
> LRU list (assuming that they're not in use by anyone else)?

__page_cache_release

-- 
All rights reversed.
