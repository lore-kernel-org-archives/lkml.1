Return-Path: <linux-kernel-owner+w=401wt.eu-S932517AbZJLPEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517AbZJLPEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932470AbZJLPEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:04:34 -0400
Received: from mx06.lb01.inode.at ([62.99.145.6]:9600 "EHLO mx.inode.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932204AbZJLPEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:04:34 -0400
Message-ID: <4AD34554.3050701@sbg.ac.at>
Date: Mon, 12 Oct 2009 17:03:48 +0200
From: Alexander Huemer <alexander.huemer@sbg.ac.at>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       alexander.huemer@sbg.ac.at
Subject: Re: 2.6.{30,31} x86_64 ahci problem - irq 23: nobody cared
References: <4ABBB8C2.2080901@sbg.ac.at> <200910101513.51320.elendil@planet.nl> <4AD2DFA4.9000602@kernel.org> <200910121148.16439.elendil@planet.nl> <4AD2FC60.8080705@kernel.org> <4AD2FD10.2010800@sbg.ac.at> <4AD2FFC7.5010402@kernel.org> <4AD300B5.6080102@sbg.ac.at>
In-Reply-To: <4AD300B5.6080102@sbg.ac.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Huemer wrote:
> Tejun Heo wrote:
>> Alexander Huemer wrote:
>>  
>>> Tejun Heo wrote:
>>>    
>>>> Frans Pop wrote:
>>>>  
>>>>      
>>>>> On Monday 12 October 2009, Tejun Heo wrote:
>>>>>           
>>>>>> Alexander, can you please attach full boot log and the output of
>>>>>> "lspci -nn"?  Also, how reproducible is the problem?  You already
>>>>>> answered to Frans' question but can you be more specific?
>>>>>>                 
>>>>> Full dmesg was made available earlier at:
>>>>> http://xx.vu/~ahuemer/dmesg_ahuemer_20090923
>>>>>             
>>>> Does blacklisting i801_smbus make any difference?
>>>>
>>>>         
>>> lspci -nn:
>>> http://xx.vu/~ahuemer/lspci_nn_ahuemer_20091012
>>>
>>> what do you mean with "blacklisting i801_smbus" ?
>>>     
>>
>> [    3.872387] i2c /dev entries driver
>> [    3.873943] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 23 (level, 
>> low) -> IRQ 23
>> [    3.875580] w83627hf: Found W83627HF chip at 0x290
>>
>> IRQ23 is also used by i801_smbus and it would be nice to confirm
>> whether the problem can still be triggered with that driver not
>> loaded.  Adding "blacklist i2c_i801" to /etc/modprobe.d/blacklist
>> should probabaly do the trick.
>>
>> Thanks.
>>
>>   
> okay, i think you assume that i2c_i801 is a module.
> it is indeed built into the kernel.
> i'll rebuild the kernel without that component and run a test again.
>
> regards
> -alex
tejun, it seems you hit an interesting point.
i compiled kernel-2.6.31.3 with my ususal config _without_ i2c_i801.
my usual test (compilation of gcc-4.3.2) finished 5 times without the error.
i'll let it run some more times over night.
does anybody have an idea how i can trace what exactly causes the error 
during the compilation run so that i can create a short test program ?

regards
-alex
