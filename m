Return-Path: <linux-kernel-owner+w=401wt.eu-S1752932AbZGWIlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbZGWIlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 04:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbZGWIlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 04:41:31 -0400
Received: from mail.atmel.fr ([81.80.104.162]:56069 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbZGWIla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 04:41:30 -0400
Message-ID: <4A682213.7060105@atmel.com>
Date: Thu, 23 Jul 2009 10:40:51 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: maciej.sosnowski@intel.com, avictor.za@gmail.com,
       linux-arm-kernel@lists.arm.linux.org.uk, haavard.skinnemoen@atmel.com,
       patrice.vilchez@atmel.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] dmaengine: dmatest: add a maximum number of test 	iterations
References: <1246642011-21749-1-git-send-email-nicolas.ferre@atmel.com> <e9c3a7c20907222157p6dfbbb4ewdbe1e2c05c09d841@mail.gmail.com>
In-Reply-To: <e9c3a7c20907222157p6dfbbb4ewdbe1e2c05c09d841@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams :
> On Fri, Jul 3, 2009 at 10:26 AM, Nicolas Ferre<nicolas.ferre@atmel.com> wrote:
>> The dmatest usually waits for the killing of its kthreads to stop
>> running tests.  This patch adds a parameter that sets a maximum
>> number of test iterations.
>>
>> This feature is quite interesting for debugging when you set a lot of
>> traces in your dmaengine controller driver.
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
>>  drivers/dma/dmatest.c |   15 ++++++++++++++-
>>  1 files changed, 14 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
>> index fb7da51..0131a1f 100644
>> --- a/drivers/dma/dmatest.c
>> +++ b/drivers/dma/dmatest.c
>> @@ -38,6 +38,11 @@ module_param(max_channels, uint, S_IRUGO);
>>  MODULE_PARM_DESC(max_channels,
>>                "Maximum number of channels to use (default: all)");
>>
>> +static unsigned int iteration_nbr = 0;
>> +module_param(iteration_nbr, uint, S_IRUGO);
>> +MODULE_PARM_DESC(iteration_nbr,
>> +               "Iteration number before stopping test (default: infinite)");
>> +
> 
> This is a minor nit, but for a user facing interface I don't think we
> should export abbreviated variable names.  I'll apply this with the
> following fixups:
> 
> s/iteration_nbr/iterations/
> s/Iteration number/Iterations/
> 
> ...as well as a fix for the checkpatch violation of initializing a static to 0.

Ok fine.
(initialization to 0 has also been corrected by Andrew Morton in his
patch series).

Thanks Dan, Bye,
-- 
Nicolas Ferre

