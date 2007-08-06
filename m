Return-Path: <linux-kernel-owner+w=401wt.eu-S1763642AbXHFLDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763642AbXHFLDh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 07:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbXHFLDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 07:03:30 -0400
Received: from cluster-g.mailcontrol.com ([85.115.41.190]:53791 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbXHFLD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 07:03:29 -0400
Message-ID: <46B6F46B.8050707@csr.com>
Date: Mon, 06 Aug 2007 11:14:03 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: linux-kernel@vger.kernel.org
Subject: Re: sdio: parameterize SDIO FBR register defines
References: <11858961933491-git-send-email-david.vrabel@csr.com>	<11858961931710-git-send-email-david.vrabel@csr.com> <20070804152613.1f190abc@poseidon.drzeus.cx>
In-Reply-To: <20070804152613.1f190abc@poseidon.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Aug 2007 10:14:04.0203 (UTC) FILETIME=[842EF7B0:01C7D812]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> On Tue, 31 Jul 2007 16:36:31 +0100
> David Vrabel <david.vrabel@csr.com> wrote:
> 
>> Signed-off-by: David Vrabel <david.vrabel@csr.com>
>>
>> ---
>> commit 51755c3d59be1ba778bef45888f9f5e341dc4af4
>> tree c7bbb562b2d801197eefb619a17c94467c1299cd
>> parent 1cf0b6019aa3916197eecafe058bd2f3d700d24a
>> author David Vrabel <david.vrabel@csr.com> Mon, 30 Jul 2007 19:20:59
>> +0100 committer David Vrabel <dvrabel@cantab.net> Mon, 30 Jul 2007
>> 19:28:30 +0100
>>
>>  drivers/mmc/core/sdio.c     |    4 ++--
>>  drivers/mmc/core/sdio_cis.c |    2 +-
>>  include/linux/mmc/sdio.h    |   16 +++++++++-------
>>  3 files changed, 12 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
>> index 6589fd6..08f579c 100644
>> --- a/drivers/mmc/core/sdio.c
>> +++ b/drivers/mmc/core/sdio.c
>> @@ -30,7 +30,7 @@ static int sdio_read_fbr(struct sdio_func *func)
>>  	unsigned char data;
>>  
>>  	ret = mmc_io_rw_direct(func->card, 0, 0,
>> -		func->num * 0x100 + SDIO_FBR_STD_IF, 0, &data);
>> +		SDIO_FBR_STD_IF(func->num), 0, &data);
>>  	if (ret != MMC_ERR_NONE)
>>  		goto out;
>>  
> 
> I am a bit sceptical about these macros. Most i/o code in the kernel is
> in the form of "<base address> + <register offset>". For one thing,
> that model keeps the register defines clean and means people don't have
> to go reaching for specs all the time.

I really don't follow you objection to this.  If one is maintaining the
SDIO core then I would expect some familiarity with the spec and an
understanding the FBRs are per-function but contained in the same
CCCR/F0 register space.

Also, I would consider the start of the CCCR as the "base address".

> Would you be content with replacing "func->num * 0x100" with a macro so
> that the code becomes something like:
> 
> 	SDIO_FBR_BASE(func->num) + SDIO_FBR_STD_IF

I think this is less readable than SDIO_FBR_STD_IF(func->num).

David
-- 
David Vrabel, Software Engineer, Drivers group  Tel: +44 (0)1223 692562
CSR plc, Churchill House, Cambridge Business Park, Cowley Road, CB4 0WZ


.
