Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbZHFIeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbZHFIeb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 04:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbZHFIea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 04:34:30 -0400
Received: from compulab.co.il ([67.18.134.219]:54731 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807AbZHFIe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 04:34:29 -0400
Message-ID: <4A7A9589.1090106@compulab.co.il>
Date: Thu, 06 Aug 2009 11:34:17 +0300
From: Denis Turischev <denis@compulab.co.il>
User-Agent: Thunderbird 2.0.0.19 (X11/20090114)
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
CC: Mike Rapoport <mike@compulab.co.il>, Joe Perches <joe@perches.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrey Panin <pazke@centrinvest.ru>, akpm@linux-foundation.org
Subject: Re: [PATCH v2] add SBC-FITPC2 watchdog driver
References: <4A6594C9.4010403@compulab.co.il> <20090804153331.GA30892@infomag.iguana.be>
In-Reply-To: <20090804153331.GA30892@infomag.iguana.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Wim,

Tested, seems ok.

Denis

Wim Van Sebroeck wrote:
> Hi Mike, Denis,
>
>   
>>> From: Denis Turischev <denis@compulab.co.il>
>>>       
>> This patch adds support for watchdog found on SBC-FITPC2 board.
>>
>> --
>> v2 changes:
>> - reorder fitpc2_wdt_write to reduce the indent
>> - change printk levels
>> - use pr_fmt
>> - add release_region in the _init error path
>>
>> Signed-off-by: Denis Turischev <denis@compulab.co.il>
>> Signed-off-by: Mike Rapoport <mike@compulab.co.il>
>>     
>
> Some remarks:
> 1) If you dou request_regions in the init section then you need to do release_regions also in the exit section.
> 2) we prefer:
>  static long wdt_ioctl(parameters
> 			rest_of_parameters)
> instead of
>  static long
>  wdt_ioctl(parameters)
> 3) misc_deregister can return with an error. If it does you need to do the release_regions also.
> 4) as Andrew allready pointed out spinlock needs to be initialized.
> 5) if you don't use the reboot_notifier then you don't need to include linux/notifier.h and linux/reboot.h .
>
> I adapted the code.
> Can you test the attached diff?
>
> Thanks in advance,
> Wim.
>
>   

