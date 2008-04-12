Return-Path: <linux-kernel-owner+w=401wt.eu-S1760870AbYDLKCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760870AbYDLKCs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 06:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757051AbYDLKCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 06:02:39 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:34061 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756457AbYDLKCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 06:02:37 -0400
Message-ID: <480088AD.1040904@garzik.org>
Date: Sat, 12 Apr 2008 06:02:21 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Alexey Dobriyan <adobriyan@gmail.com>, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jgarzik@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: 2.6.25-rc8-mm2: CONFIG_ATA_SFF: panic involving	mount_block_root
 and down the road
References: <20080410203354.f0a6f464.akpm@linux-foundation.org> <20080411234345.GA4742@martell.zuzino.mipt.ru> <20080412005917.GA4742@martell.zuzino.mipt.ru> <20080412065248.GA8849@cs181133002.pp.htv.fi>
In-Reply-To: <20080412065248.GA8849@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sat, Apr 12, 2008 at 04:59:17AM +0400, Alexey Dobriyan wrote:
>> On Sat, Apr 12, 2008 at 03:43:45AM +0400, Alexey Dobriyan wrote:
>>> Pekka fixed SLUB for me, and now core2 box survives up and including to
>>> not finding / :
>>>
>>> Setup is SATA disk with plain old partitions, nothing lvmancy:
>>>
>>> 	/dev/sda2 on / type ext3 (rw,noatime)
>>>
>>> CONFIG_ATA=y
>>> CONFIG_ATA_ACPI=y
>>> CONFIG_SATA_AHCI=y
>>> CONFIG_ATA_PIIX=y
>>> CONFIG_PATA_JMICRON=y
>>>
>>> sda1 is for swap.
>>>
>>>
>>> [    3.920000] NET: Registered protocol family 1
>>> [    3.920000] VFS: Cannot open root device "sda2" or unknown-block(0,0)
>> The winner is partly me, partly git-libata-all.
>>
>> The latter introduced CONFIG_ATA_SFF option and put more or less every
>> SATA and PATA driver under it. The former honestly answered N to when
>> ATA_SFF popped up and failed to check existence of ATA_PIIX and
>> PATA_JMICRON in failing .config .
>>
>> Now raise hands those who knew that your ATA controller is SFF
>> compliant.
> 
> Is there any technical reason why we have to bother users with the 
> ATA_SFF option at all?
> 
> It sounds like a perfect canndidate for being select'ed.

'default y' is appropriate, but option that is used to disable a major 
swath of legacy code unneeded on modern FIS-based SATA platforms like AHCI.

	Jeff



