Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbZFZPgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbZFZPgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 11:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbZFZPgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 11:36:43 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:17410 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbZFZPgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 11:36:42 -0400
Message-ID: <4A44EAFC.2050507@oracle.com>
Date: Fri, 26 Jun 2009 08:36:28 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: mmotm 2009-06-25-15-49 uploaded
References: <200906252249.n5PMnaPt016847@imap1.linux-foundation.org> <4A440D59.50400@oracle.com> <20090626030228.GA9279@cmpxchg.org>
In-Reply-To: <20090626030228.GA9279@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt002.oracle.com [141.146.116.11]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4A44EAFE.029E:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
> On Thu, Jun 25, 2009 at 04:50:49PM -0700, Randy Dunlap wrote:
>> akpm@linux-foundation.org wrote:
>>> The mm-of-the-moment snapshot 2009-06-25-15-49 has been uploaded to
>>>
>>>    http://userweb.kernel.org/~akpm/mmotm/
>>>
>>> and will soon be available at
>>>
>>>    git://git.zen-sources.org/zen/mmotm.git
>>
>> shrink_slab-handle-bad-shrinkers.patch:
>>
>> mm/vmscan.c: In function 'do_try_to_free_pages':
>> mm/vmscan.c:1697: error: too few arguments to function 'disable_swap_token'
>> mm/vmscan.c: In function 'balance_pgdat':
>> mm/vmscan.c:1869: error: too few arguments to function 'disable_swap_token'
>> mm/vmscan.c: In function '__zone_reclaim':
>> mm/vmscan.c:2425: error: too few arguments to function 'disable_swap_token'
> 
> Sorry, my fault - `make CONFIG_SWAP=n` didn't work as I assumed.  The
> patch Randy pointed out seems unrelated to this, though...?

Sorry, I just referred to the only patch file that touched mm/vmscan.c.

Patch is good.  Thanks.
Acked-by: Randy Dunlap <randy.dunlap@oracle.com> # and Tested-by:

> ---
> From: Johannes Weiner <hannes@cmpxchg.org>
> Subject: mm: make swap token dummies static inlines fix
> 
> disable_swap_token() doesn't take an argument.  This fixes the
> !CONFIG_SWAP dummy.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 9b02f33..6c990e6 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -432,7 +432,7 @@ static inline int has_swap_token(struct mm_struct *mm)
>  	return 0;
>  }
>  
> -static inline void disable_swap_token(struct mm_struct *mm)
> +static inline void disable_swap_token(void)
>  {
>  }
>  


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
