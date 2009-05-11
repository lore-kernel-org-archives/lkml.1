Return-Path: <linux-kernel-owner+w=401wt.eu-S1757603AbZEKCsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603AbZEKCsI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 22:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbZEKCrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 22:47:55 -0400
Received: from mail.windriver.com ([147.11.1.11]:50916 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbZEKCrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 22:47:55 -0400
Message-ID: <4A0791D1.5040303@windriver.com>
Date: Mon, 11 May 2009 10:47:45 +0800
From: Harry Ciao <qingtao.cao@windriver.com>
Reply-To: qingtao.cao@windriver.com
Organization: Wind River, CDC
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: norsk5@yahoo.com, bluesmoke-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [v0 PATCH 1/1] Use dev_name() for AMD8111/AMD8131 EDAC driver
References: <1241660858-21105-1-git-send-email-qingtao.cao@windriver.com>	<1241660858-21105-2-git-send-email-qingtao.cao@windriver.com> <20090507145722.b2d89e11.akpm@linux-foundation.org>
In-Reply-To: <20090507145722.b2d89e11.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 May 2009 02:46:59.0234 (UTC) FILETIME=[C1488820:01C9D1E2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu,  7 May 2009 09:47:38 +0800
> Harry Ciao <qingtao.cao@windriver.com> wrote:
>
>   
>> The device structure no longer has bus_id member, dev_name() should
>> be used for AMD8111 & AMD8131 EDAC driver instead. Also, their Makefile 
>> entries are lost, add them.
>>
>> Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
>> ---
>>  drivers/edac/Makefile       |    2 ++
>>  drivers/edac/amd8111_edac.c |    4 ++--
>>  drivers/edac/amd8131_edac.c |    2 +-
>>  3 files changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
>> index a5fdcf0..5907681 100644
>> --- a/drivers/edac/Makefile
>> +++ b/drivers/edac/Makefile
>> @@ -35,3 +35,5 @@ obj-$(CONFIG_EDAC_MPC85XX)		+= mpc85xx_edac.o
>>  obj-$(CONFIG_EDAC_MV64X60)		+= mv64x60_edac.o
>>  obj-$(CONFIG_EDAC_CELL)			+= cell_edac.o
>>  obj-$(CONFIG_EDAC_PPC4XX)		+= ppc4xx_edac.o
>> +obj-$(CONFIG_EDAC_AMD8111)		+= amd8111_edac.o
>> +obj-$(CONFIG_EDAC_AMD8131)		+= amd8131_edac.o
>>     
>
> hm, I wonder how that happened.
>
> The drivers break x86-64 allmodconfig:
>
> drivers/edac/amd8111_edac.c: In function 'amd8111_lpc_bridge_init':
> drivers/edac/amd8111_edac.c:260: error: implicit declaration of function '__do_inb'
> drivers/edac/amd8111_edac.c:274: error: implicit declaration of function '__do_outb'
>
>
>   

Ah, this is because __do_inb so far only supported on PPC arch:

cao@cao-desktop:/work/community/linux-2.6/arch$ grep __do_inb * -r
powerpc/include/asm/io.h:#define __do_inb(port)        _rec_inb(port)
powerpc/include/asm/io.h:#define __do_inb(port)        
readb((PCI_IO_ADDR)_IO_BASE + port);
cao@cao-desktop:/work/community/linux-2.6/arch$

So far the only machine that hosts AMD8111 chip is Maple, however, 
AMD8111 is of Hypertransport device and not necessarily depends on Maple 
nor PPC, so its Kconfig option is only depended on EDAC && EDAC_MC_EDAC 
&& PCI.

I think I could put some words into its Kconfig help section that 
AMD8111 should be selected on Maple now.

What do you think? thanks!

Best regards,

Harry

