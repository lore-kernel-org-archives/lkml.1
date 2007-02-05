Return-Path: <linux-kernel-owner+w=401wt.eu-S933306AbXBEUbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306AbXBEUbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 15:31:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933366AbXBEUbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 15:31:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:46191 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933306AbXBEUbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 15:31:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,284,1167638400"; 
   d="scan'208"; a="193018273:sNHT43816528"
Message-ID: <45C7941E.2050305@intel.com>
Date: Mon, 05 Feb 2007 12:31:26 -0800
From: Auke Kok <auke-jan.h.kok@intel.com>
User-Agent: Mail/News 1.5.0.9 (X11/20061228)
MIME-Version: 1.0
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>, jeffrey.t.kirsher@intel.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.20] ixgb: Use ARRAY_SIZE macro when appropriate
References: <20070205165429.GD3896@Ahmed> <20070205165933.GL3896@Ahmed> <20070205201804.GC11055@martell.zuzino.mipt.ru>
In-Reply-To: <20070205201804.GC11055@martell.zuzino.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Feb 2007 20:31:26.0974 (UTC) FILETIME=[9C36C1E0:01C74964]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On Mon, Feb 05, 2007 at 06:59:33PM +0200, Ahmed S. Darwish wrote:
>> A patch to use ARRAY_SIZE macro already defined in kernel.h.
> 
> Remove it and use ARRAY_SIZE instead.
> 
>> --- a/drivers/net/ixgb/ixgb_param.c
>> +++ b/drivers/net/ixgb/ixgb_param.c
>> @@ -245,7 +245,7 @@ ixgb_validate_option(int *value, struct ixgb_option *opt)
>>  	return -1;
>>  }
>>  
>> -#define LIST_LEN(l) (sizeof(l) / sizeof(l[0]))
>> +#define LIST_LEN(l) ARRAY_SIZE(l)

yes, well spotted. Please change line 338 in this file to read:

      .arg  = { .l = { .nr = ARRAY_SIZE(fc_list),

instead, so you can remove the LIST_LEN macro completely.

Thanks,

Auke
