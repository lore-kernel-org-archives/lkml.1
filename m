Return-Path: <linux-kernel-owner+w=401wt.eu-S1761177AbZFOOIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761177AbZFOOIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 10:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758728AbZFOOIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 10:08:35 -0400
Received: from legaljet.webserversystems.com ([67.18.134.218]:58934 "EHLO
	compulab.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbZFOOIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 10:08:35 -0400
Message-ID: <4A3655DC.9090407@compulab.co.il>
Date: Mon, 15 Jun 2009 17:08:28 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.16 (X11/20080907)
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: eric miao <eric.y.miao@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd/da903x: initialize PMIC core early
References: <4A363841.5090406@compulab.co.il> <20090615135117.GC4094@sortiz.org>
In-Reply-To: <20090615135117.GC4094@sortiz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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



Samuel Ortiz wrote:
> Hi Mike,
> 
> On Mon, Jun 15, 2009 at 03:02:09PM +0300, Mike Rapoport wrote:
>> Samuel,
>> It'd be great if this can go to 2.6.31
> Sure. Care to explain why this needs to be called earlier ?

We want to have da903x regulators available early during boot, and since they
are subdevices of mfd/da903x they cannot be enabled until the da903x core is
initialized.
I just saw Liam Girdwood pull request with "regulator: Move regulator drivers to
subsys_initcall()" commit and jumped in :)


> Cheers,
> Samuel.
> 
>> Signed-off-by: Mike Rapoport <mike@compulab.co.il>
>> ---
>>  drivers/mfd/da903x.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/mfd/da903x.c b/drivers/mfd/da903x.c
>> index 7283d88..e5ffe56 100644
>> --- a/drivers/mfd/da903x.c
>> +++ b/drivers/mfd/da903x.c
>> @@ -561,7 +561,7 @@ static int __init da903x_init(void)
>>  {
>>  	return i2c_add_driver(&da903x_driver);
>>  }
>> -module_init(da903x_init);
>> +subsys_initcall(da903x_init);
>>
>>  static void __exit da903x_exit(void)
>>  {
>> -- 
>> 1.6.0.6
>>
>>
>> -- 
>> Sincerely yours,
>> Mike.
>>
> 

-- 
Sincerely yours,
Mike.

