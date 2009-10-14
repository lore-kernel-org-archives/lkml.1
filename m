Return-Path: <linux-kernel-owner+w=401wt.eu-S1761010AbZJNDf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761010AbZJNDf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 23:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759725AbZJNDf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 23:35:56 -0400
Received: from nsp.dat.demokritos.gr ([143.233.247.10]:32777 "EHLO
	nsp.dat.demokritos.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182AbZJNDfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 23:35:55 -0400
X-Greylist: delayed 1252 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Oct 2009 23:35:52 EDT
MIME-Version: 1.0
Date: Wed, 14 Oct 2009 06:07:09 +0300
From: "Alexandros C. Couloumbis" <alex@ozo.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@linux.intel.com>, <jeff@garzik.org>,
       <linux-kernel@vger.kernel.org>, <stable@kernel.org>,
       <linux-ide@vger.kernel.org>
Subject: Re: [PATCH] =?UTF-8?Q?pata=5Fsc=31=32=30=30=3A=20Fix=20crash=20on=20boot?=
Organization: OZO Networks
In-Reply-To: <20091013185637.870369c8.akpm@linux-foundation.org>
References: <20091006150737.9610.81541.stgit@localhost.localdomain> <20091013185637.870369c8.akpm@linux-foundation.org>
Message-ID: <546b82ff577223765f15eb26f2f6b300@localhost>
User-Agent: RoundCube Webmail
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009 18:56:37 -0700, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 06 Oct 2009 16:07:51 +0100 Alan Cox <alan@linux.intel.com>
wrote:
> 
>> The SC1200 needs a NULL terminator or it may cause a crash on boot.
>> 
>> Bug #14227
>> 
>> Also correct a bogus comment as the driver had serializing added so can
>> run
>> dual port.
>> 
>> Signed-off-by: Alan Cox <alan@linux.intel.com>
>> ---
>> 
>>  drivers/ata/pata_sc1200.c |    3 +--
>>  1 files changed, 1 insertions(+), 2 deletions(-)
>> 
>> 
>> diff --git a/drivers/ata/pata_sc1200.c b/drivers/ata/pata_sc1200.c
>> index f49814d..3bbed83 100644
>> --- a/drivers/ata/pata_sc1200.c
>> +++ b/drivers/ata/pata_sc1200.c
>> @@ -235,8 +235,7 @@ static int sc1200_init_one(struct pci_dev *dev,
>> const struct pci_device_id *id)
>>  		.udma_mask = ATA_UDMA2,
>>  		.port_ops = &sc1200_port_ops
>>  	};
>> -	/* Can't enable port 2 yet, see top comments */
>> -	const struct ata_port_info *ppi[] = { &info, };
>> +	const struct ata_port_info *ppi[] = { &info, NULL };
>>  
>>  	return ata_pci_sff_init_one(dev, ppi, &sc1200_sht, NULL);
>>  }
> 
> This patch applies to 2.6.31 and 2.6.30 (at least).  How far back
> should it be ported?
> 
> There was no Cc:stable in the changelog.
> 
> There was no Cc:stable in the mail headers.  Nor cc:linux-ide.
> 
> Adding a Reported-by: is nice.
> 
> Please use the form
> 
> Addresses http://bugzilla.kernel.org/show_bug.cgi?id=14227
> 
> when mentioning bugzilla reports within changelogs.  To provide a nice
> greppable pattern for those people who might close off old reports for
us.

According to the git-tree this feature was introduced on linux kernel
2.6.30:
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.30.y.git;a=commitdiff;h=c0f2ee34a5a0b79fd98d965ad8ae765d4639bfa5

2.6.29 and older kernels do not have this change/feature
