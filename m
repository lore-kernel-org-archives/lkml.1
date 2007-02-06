Return-Path: <linux-kernel-owner+w=401wt.eu-S932852AbXBFQsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852AbXBFQsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 11:48:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932622AbXBFQsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 11:48:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:43375 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932588AbXBFQsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 11:48:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,291,1167638400"; 
   d="scan'208"; a="43531049:sNHT23452677"
Message-ID: <45C8B145.7030604@intel.com>
Date: Tue, 06 Feb 2007 08:48:05 -0800
From: Auke Kok <auke-jan.h.kok@intel.com>
User-Agent: Mail/News 1.5.0.9 (X11/20061228)
MIME-Version: 1.0
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>, jeffrey.t.kirsher@intel.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.20] ixgb: Use ARRAY_SIZE macro when appropriate
References: <20070205165429.GD3896@Ahmed> <20070205165933.GL3896@Ahmed> <20070205201804.GC11055@martell.zuzino.mipt.ru> <45C7941E.2050305@intel.com> <20070206100025.GA14903@Ahmed>
In-Reply-To: <20070206100025.GA14903@Ahmed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Feb 2007 16:48:06.0181 (UTC) FILETIME=[9321C550:01C74A0E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ahmed S. Darwish wrote:
> On Mon, Feb 05, 2007 at 12:31:26PM -0800, Auke Kok wrote:
>> Alexey Dobriyan wrote:
>>> On Mon, Feb 05, 2007 at 06:59:33PM +0200, Ahmed S. Darwish wrote:
>>>> A patch to use ARRAY_SIZE macro already defined in kernel.h.
>>> Remove it and use ARRAY_SIZE instead.
>>>
>>>> --- a/drivers/net/ixgb/ixgb_param.c
>>>> +++ b/drivers/net/ixgb/ixgb_param.c
>>>> @@ -245,7 +245,7 @@ ixgb_validate_option(int *value, struct ixgb_option 
>>>> *opt)
>>>> 	return -1;
>>>> }
>>>>
>>>> -#define LIST_LEN(l) (sizeof(l) / sizeof(l[0]))
>>>> +#define LIST_LEN(l) ARRAY_SIZE(l)
>> yes, well spotted. Please change line 338 in this file to read:
>>
>>      .arg  = { .l = { .nr = ARRAY_SIZE(fc_list),
>>
>> instead, so you can remove the LIST_LEN macro completely.
>  
> Thanks, Here's the new patch.
> 
> Use ARRAY_SIZE macro when appropriate.
> 
> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>

Acked-by: Auke Kok <auke-jan.h.kok@intel.com>

Cheers,

Auke

> ---
> diff --git a/drivers/net/ixgb/ixgb_param.c b/drivers/net/ixgb/ixgb_param.c
> index b27442a..c38ce73 100644
> --- a/drivers/net/ixgb/ixgb_param.c
> +++ b/drivers/net/ixgb/ixgb_param.c
> @@ -245,8 +245,6 @@ ixgb_validate_option(int *value, struct ixgb_option *opt)
>  	return -1;
>  }
>  
> -#define LIST_LEN(l) (sizeof(l) / sizeof(l[0]))
> -
>  /**
>   * ixgb_check_options - Range Checking for Command Line Parameters
>   * @adapter: board private structure
> @@ -335,7 +333,7 @@ ixgb_check_options(struct ixgb_adapter *adapter)
>  			.name = "Flow Control",
>  			.err  = "reading default settings from EEPROM",
>  			.def  = ixgb_fc_tx_pause,
> -			.arg  = { .l = { .nr = LIST_LEN(fc_list),
> +			.arg  = { .l = { .nr = ARRAY_SIZE(fc_list),
>  					 .p = fc_list }}
>  		};
> 
> 
