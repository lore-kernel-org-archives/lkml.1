Return-Path: <linux-kernel-owner+w=401wt.eu-S1756352AbZFNDzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbZFNDzt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 23:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbZFNDzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 23:55:41 -0400
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:56249 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbZFNDzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 23:55:40 -0400
Message-ID: <4A3474BD.4000804@linux.vnet.ibm.com>
Date: Sun, 14 Jun 2009 00:55:41 -0300
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090208)
MIME-Version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
CC: Shahbaz Khan <shaz.linux@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Debora Velarde <debora@linux.vnet.ibm.com>,
       tpmdd-devel@lists.sourceforge.net
Subject: Re: TPM drivers support and Linux Integrity Module for 2.6.30
References: <20cbb9450906112259m176153c9ucfa7a4d14642949f@mail.gmail.com> <1244817141.3401.7.camel@dyn9002018117.watson.ibm.com>
In-Reply-To: <1244817141.3401.7.camel@dyn9002018117.watson.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mimi, thanks for copying us.

Shaz,

If this is the same chip we find in the GM45 boards, iTPM, the upstream 
driver won't work properly with it.
Mainly because this iTPM returns the wrong status code when the driver 
didn't finish sending all bytes required for a specific command.
As suggested by Seiji Munetoh in the tpmdd-devel sf mailing list, you 
can modify line 263 of tpm_tis.c as below:

-		if ((status & TPM_STS_DATA_EXPECT) == 0) {
+		if ((status & TPM_STS_VALID) == 0) {


Then, after compiling it, since it also seems to not support PNP, load 
it with force option on:

modprobe tpm_tis force=1

If modprobe fails the first time, try the second and then it will work.

I'm going to submit a patch to make the upstream driver work with it, 
making this line depend on a module param too..

Thanks,
Rajiv

Mimi Zohar wrote:
> On Fri, 2009-06-12 at 11:59 +0600, Shahbaz Khan wrote:
>   
>> Hi,
>>
>> I am using Intel Q45 Express chipset with TPM version 1.2 specs of
>> TCG. The kernel version is 2.6.30. Problem is that the TPM drivers
>> cannot provide functionality to the TCG TSS giving error message:
>>
>> "TCSD TDDL ERROR: Could not find a device to open!"
>>
>> The device node in /dev is also not being created which should be
>> "/dev/tpm". If created manually then still it does not work.
>>
>> What should be done?
>>
>> Thanks.
>>
>> --
>> Shaz
>>     
>
> This is a device driver issue. Copying the TPM maintainers and the
> forum.
>
> Mimi
>
>   

