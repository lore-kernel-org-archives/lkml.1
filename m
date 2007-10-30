Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbXJ3REL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbXJ3REL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 13:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbXJ3RD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 13:03:56 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:40792 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbXJ3RDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 13:03:55 -0400
Message-ID: <47275EB5.1070704@student.ltu.se>
Date: Tue, 30 Oct 2007 17:41:25 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: James.Bottomley@steeleye.com, James.Smart@emulex.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] drivers/scsi/lpfc/lpfc_hw.h: Some minor cleanup.
References: <20071030104816.30937.77821.sendpatchset@thinktank.campus.ltu.se> <200710301544.02765.vda.linux@googlemail.com>
In-Reply-To: <200710301544.02765.vda.linux@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko wrote:
> On Tuesday 30 October 2007 10:54, Richard Knutsson wrote:
>   
>> Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
>> ---
>> Diffed against linus-git
>> Checked with script/checkpatch.pl
>>
>>
>> diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
>> index 451accd..6f56528 100644
>> --- a/drivers/scsi/lpfc/lpfc_hw.h
>> +++ b/drivers/scsi/lpfc/lpfc_hw.h
>> @@ -3158,31 +3158,30 @@ struct lpfc_sli2_slim {
>>   *
>>   * Parameters:
>>   * device : struct pci_dev 's device field
>> - *
>> - * return 1 => TRUE
>> - *        0 => FALSE
>>   */
>> -static inline int
>> +static inline bool
>>  lpfc_is_LC_HBA(unsigned short device)
>>  {
>> -	if ((device == PCI_DEVICE_ID_TFLY) ||
>> -	    (device == PCI_DEVICE_ID_PFLY) ||
>> -	    (device == PCI_DEVICE_ID_LP101) ||
>> -	    (device == PCI_DEVICE_ID_BMID) ||
>> -	    (device == PCI_DEVICE_ID_BSMB) ||
>> -	    (device == PCI_DEVICE_ID_ZMID) ||
>> -	    (device == PCI_DEVICE_ID_ZSMB) ||
>> -	    (device == PCI_DEVICE_ID_RFLY))
>> -		return 1;
>> -	else
>> -		return 0;
>> +	switch (device) {
>> +	case PCI_DEVICE_ID_TFLY:
>> +	case PCI_DEVICE_ID_PFLY:
>> +	case PCI_DEVICE_ID_LP101:
>> +	case PCI_DEVICE_ID_BMID:
>> +	case PCI_DEVICE_ID_BSMB:
>> +	case PCI_DEVICE_ID_ZMID:
>> +	case PCI_DEVICE_ID_ZSMB:
>> +	case PCI_DEVICE_ID_RFLY:
>> +		return true;
>> +	}
>> +
>> +	return false;
>>  }
>>     
>
> Why is this patch useful? 
Just simpler to read, no?
> I'd rather do this instead:
>
> -static inline int
> +static int
>
> (this function has three callsites, thus de-inlining will
> make code smaller)
>   
It is returning (and the results are used as) a boolean so why should it 
be an integer? But I have no objection to de-inline it.
Alright with:
-static inline int
+static bool
?

Richard Knutsson

