Return-Path: <linux-kernel-owner+w=401wt.eu-S1755590AbZCEUPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbZCEUPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 15:15:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbZCEUPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 15:15:23 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:43381 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbZCEUPW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 15:15:22 -0500
MIME-Version: 1.0
In-Reply-To: <1236283546.5626.45.camel@localhost.localdomain>
References: <20090305190954.30062.44759.stgit@f10box.hanneseder.net>
	 <20090305191602.30062.71301.stgit@f10box.hanneseder.net>
	 <1236283546.5626.45.camel@localhost.localdomain>
Date: Thu, 5 Mar 2009 21:15:18 +0100
Message-ID: <154e089b0903051215q1216aa53icd41556e2af8b234@mail.gmail.com>
Subject: Re: [PATCH v2 09/15] NULL noise: drivers/scsi/FlashPoint.c
From: Hannes Eder <hannes@hanneseder.net>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 5, 2009 at 9:05 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Thu, 2009-03-05 at 20:16 +0100, Hannes Eder wrote:
>> Fix this sparse warnings:
>>   drivers/scsi/FlashPoint.c:906:9: warning: Using plain integer as NULL pointer
>>   drivers/scsi/FlashPoint.c:907:53: warning: Using plain integer as NULL pointer
>>   drivers/scsi/FlashPoint.c:922:1: warning: Using plain integer as NULL pointer
>>
>> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
>> ---
>> v2: fix checkpatch.pl issue.
>> v2.1: other subject, as suggested by Al Viro
>>
>>  drivers/scsi/FlashPoint.c |    7 +++----
>>  1 files changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/scsi/FlashPoint.c b/drivers/scsi/FlashPoint.c
>> index b898d38..9eb2e86 100644
>> --- a/drivers/scsi/FlashPoint.c
>> +++ b/drivers/scsi/FlashPoint.c
>> @@ -903,8 +903,8 @@ static void FPT_autoCmdCmplt(unsigned long p_port, unsigned char p_card);
>>  static void FPT_autoLoadDefaultMap(unsigned long p_port);
>>
>>  static struct sccb_mgr_tar_info FPT_sccbMgrTbl[MAX_CARDS][MAX_SCSI_TAR] =
>> L-    { {{0}} };
>> -static struct sccb_card FPT_BL_Card[MAX_CARDS] = { {0} };
>> +    { { {NULL} } };
>> +static struct sccb_card FPT_BL_Card[MAX_CARDS] = { {NULL} };
>>  static SCCBSCAM_INFO FPT_scamInfo[MAX_SCSI_TAR] = { {{0}} };
>>  static struct nvram_info FPT_nvRamInfo[MAX_MB_CARDS] = { {0} };
>
> This doesn't look right:  {0} as a structure initialiser is a C
> convention for zero fill this structure; sparse should recognise this.
> Of course, since these structures are static, they should be in BSS
> anyway ...

So a proper fix is just not to initialize the variables.

... and report this issue to the sparse mailing list.

>
>> @@ -918,8 +918,7 @@ static unsigned char FPT_scamHAString[] =
>>
>>  static unsigned short FPT_default_intena = 0;
>>
>> -static void (*FPT_s_PhaseTbl[8]) (unsigned long, unsigned char) = {
>> -0};
>> +static void (*FPT_s_PhaseTbl[8]) (unsigned long, unsigned char) = {NULL};
>>
>>  /*---------------------------------------------------------------------
>>   *

Same her, right?
