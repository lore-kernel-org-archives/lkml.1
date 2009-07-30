Return-Path: <linux-kernel-owner+w=401wt.eu-S1751550AbZG3NOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550AbZG3NOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 09:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbZG3NOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 09:14:24 -0400
Received: from compulab.co.il ([67.18.134.219]:57652 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbZG3NOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 09:14:24 -0400
Message-ID: <4A719CAD.3030508@compulab.co.il>
Date: Thu, 30 Jul 2009 16:14:21 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.21 (X11/20090712)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: hpa@zytor.com, linux-kernel@vger.kernel.org, denis@compulab.co.il
Subject: Re: [PATCH] Add reboot fixup for SBC-fitPC2
References: <4A6491C1.5060909@compulab.co.il> <20090722173854.fdbcee7f.akpm@linux-foundation.org>
In-Reply-To: <20090722173854.fdbcee7f.akpm@linux-foundation.org>
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

Hi Andrew,

Andrew Morton wrote:
> On Mon, 20 Jul 2009 18:48:17 +0300
> Mike Rapoport <mike@compulab.co.il> wrote:
> 
>>> From: Denis Turischev <denis@compulab.co.il>
>> This patch adds reboot fixup for CompuLab SBC-fitPC2 board.
>>
>> Singned-off-by: Denis Turischev <denis@compulab.co.il>
>> Signedd-off-by: Mike Rapoport <mike@compulab.co.il
>>
>> diff -Nru linux-2.6.31-rc3.orig/arch/x86/kernel/reboot.c
>> linux-2.6.31-rc3/arch/x86/kernel/reboot.c
>> --- linux-2.6.31-rc3.orig/arch/x86/kernel/reboot.c	2009-07-14 04:18:52.000000000
>> +0300
>> +++ linux-2.6.31-rc3/arch/x86/kernel/reboot.c	2009-07-16 14:39:48.000000000 +0300
>> @@ -249,6 +249,15 @@
>>  			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-Z540N"),
>>  		},
>>  	},
>> +	{	/* Handle problems with rebooting on
>> +				CompuLab SBC-FITPC2 board */
>> +		.callback = set_bios_reboot,
>> +		.ident = "CompuLab SBC-FITPC2",
>> +		.matches = {
>> +			DMI_MATCH(DMI_SYS_VENDOR, "CompuLab"),
>> +			DMI_MATCH(DMI_PRODUCT_NAME, "SBC-FITPC2"),
>> +		},
>> +	},
>>  	{ }
>>  };
>>
> 
> Neither this patch nor Denis's earlier version contained an adequate
> decription.  We aren't told what these "problems" are, so we're unable
> to judge the appropriateness of patch.
> 
> Both patches were wordwrapped.

Sorry, my bad. Somehow I though my mail client can send patches without wrapping
them :(

> Both patches use an atypical layout style for the comments.


> I fixed up some of these things and merged the patch into my tree, for
> sending to Ingo for 2.6.32.
> 
> Please send a description of the problem which the patch fixes and I
> shall add that to my copy of the changelog.

sbc-fitpc2 board hangs on reboot without this patch. We saw fixups for Dell and
others that set BIOS reboot and that worked for us as well. So, I'd say that
changelog entry should be

--
x86: DMI match for CompuLab SBC-FITPC2 as it needs BIOS reboot.
-- 

Thanks a lot.

> Thanks.
> 

-- 
Sincerely yours,
Mike.

