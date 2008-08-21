Return-Path: <linux-kernel-owner+w=401wt.eu-S1759435AbYHUUy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435AbYHUUy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 16:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758394AbYHUUyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 16:54:06 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:48455 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758352AbYHUUyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 16:54:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andrew Vasquez <andrew.vasquez@qlogic.com>
References: <1218854205-2375-1-git-send-email-yhlu.kernel@gmail.com>
	<200808211333.00887.jbarnes@virtuousgeek.org>
Date: Thu, 21 Aug 2008 13:47:08 -0700
In-Reply-To: <200808211333.00887.jbarnes@virtuousgeek.org> (Jesse Barnes's
	message of "Thu, 21 Aug 2008 13:33:00 -0700")
Message-ID: <m13akyqenn.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jesse Barnes <jbarnes@virtuousgeek.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0004]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] pci: change msi-x vector to 32bit
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes <jbarnes@virtuousgeek.org> writes:

> On Friday, August 15, 2008 7:36 pm Yinghai Lu wrote:
>> we are using 28bit pci (bus/dev/fn + 12 bits) as irq number, so the
>> cache for irq number should be 32 bit too.
>>
>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>> Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
>>
>> ---
>>  drivers/scsi/qla2xxx/qla_def.h |    2 +-
>>  include/linux/pci.h            |    2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> Index: linux-2.6/drivers/scsi/qla2xxx/qla_def.h
>> ===================================================================
>> --- linux-2.6.orig/drivers/scsi/qla2xxx/qla_def.h
>> +++ linux-2.6/drivers/scsi/qla2xxx/qla_def.h
>> @@ -2109,7 +2109,7 @@ struct scsi_qla_host;
>>
>>  struct qla_msix_entry {
>>  	int have_irq;
>> -	uint16_t msix_vector;
>> +	uint32_t msix_vector;
>>  	uint16_t msix_entry;
>>  };
>>
>> Index: linux-2.6/include/linux/pci.h
>> ===================================================================
>> --- linux-2.6.orig/include/linux/pci.h
>> +++ linux-2.6/include/linux/pci.h
>> @@ -730,7 +730,7 @@ enum pci_dma_burst_strategy {
>>  };
>>
>>  struct msix_entry {
>> -	u16 	vector;	/* kernel uses to write allocated vector */
>> +	u32	vector;	/* kernel uses to write allocated vector */
>>  	u16	entry;	/* driver uses to specify entry, OS writes */
>>  };
>
> I see a lot of smoke about this, but not a clear consensus.  It sounds like no 
> one objects to making the MSI vector field 32 bits, but there were a lot of 
> concerns about IRQ vector naming/numbering in general?  And I assume this 
> particular patch isn't 2.6.27 material...

There is no need for this particular patch in 2.6.27.
It is a trivial bug fix so it can go in whenever.

Mostly this is a discussion about code that should land in the 2.6.28
timeframe assuming all is well.

Eric
