Return-Path: <linux-kernel-owner+w=401wt.eu-S1758800AbYDJTro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800AbYDJTro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 15:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756104AbYDJTrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 15:47:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:57267 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471AbYDJTrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 15:47:35 -0400
Cc: Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org, gregkh@suse.de,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       jgarzik@pobox.com, alan@lxorguk.ukuu.org.uk
Message-Id: <A567023C-17FC-402D-9394-29DFFA816891@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
In-Reply-To: <47FE5B76.40409@ru.mvista.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH 6/13] devres: implement managed iomap interface
Date: Thu, 10 Apr 2008 14:40:52 -0500
References: <11684073371547-git-send-email-htejun@gmail.com>	<47FA4FD2.8060808@ru.mvista.com> <47FB85CB.2070506@gmail.com> <47FB8751.3040301@ru.mvista.com> <47FE46AC.5000901@ru.mvista.com> <59A939C7-75AF-4C0F-8199-4C31D174AEA9@kernel.crashing.org> <47FE5B76.40409@ru.mvista.com>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 10, 2008, at 1:24 PM, Sergei Shtylyov wrote:
> Kumar Gala wrote:
>
>>>>>>  Those functions are going to break on 32-bit platforms with   
>>>>>> extended physical address (well, that's starting with Pentiums   
>>>>>> which had 36-bit PAE :-) AND devices mapped beyond 4 GB (e.g.   
>>>>>> PowerPC 44x).  You should have used resource_size_t for the   
>>>>>> 'offset' parameter. As this most probably means that libata is   
>>>>>> broken on such platforms, I'm going to submit a patch...
>
>>>>  It's broken with drivers using MMIO, I meant to say.
>
>>>  Oops, I meant PCI drivers here, at least for the time being. And   
>>> it looks like that was a false alarm. :-]
>
>>>>> Yeah, right please go ahead.  But I wonder whether any BIOS was   
>>>>> actually crazy enough to map mmio region above 4G on 32bit  
>>>>> machine.
>
>>>>  This is a *hardware* mapping on some non-x86 platforms (like  
>>>> PPC  44x or MIPS Alchemy). The arch/ppc/ and arch/mips/ kernels  
>>>> have  special hooks called from ioremap() which help create an  
>>>> illusion  that the PCI memory space on such platforms (not only  
>>>> it) is mapped  below 4 GB; arch/powerpc/ kernel doesn't do this  
>>>> anymore -- hence  this newly encountered issue.
>
>>>  I thought that pcim_iomap() used devm_ioremap() or something --   
>>> which of course turned to be wrong. devm_ioremap() alone is yet  
>>> safe  since there are no users for it amongst PPC 44x platform  
>>> device  drivers...
>
>> but there is no reason not to make it work properly.  For example  
>> I  believe libata uses devm_* and the fsl SATA driver (non-PCI)  
>> will need  to work in cases similar to the 44x.
>
>   Well, as for sata_fsl, it calls of_iomap() which does The Right  
> Thing.

Fair, but I don't see why we should introduce new APIs that are  
already "broken".  We went through a lot of effort to clean up and  
introduce resource_t (and clearly still have some bugs) for the >32- 
bit physical address problem.

- k
