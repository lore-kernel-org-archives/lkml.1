Return-Path: <linux-kernel-owner+w=401wt.eu-S1758319AbZKZHao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319AbZKZHao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 02:30:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbZKZHan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 02:30:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:46008 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947AbZKZHan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 02:30:43 -0500
References: <4ADEB601.8020200@kernel.org>	<4AE55D12.30403@kernel.org>	<4AE57976.4060107@jp.fujitsu.com>	<4AE5E37F.8070707@kernel.org>	<4AE5EFDB.2060908@kernel.org>	<4AE80170.6030402@jp.fujitsu.com>	<4AE88305.8020207@kernel.org>	<m1ljivibrt.fsf@fess.ebiederm.org>	<4AE899A0.3020006@kernel.org>	<4AE95247.8080401@jp.fujitsu.com>	<4AE952B9.1010603@kernel.org>	<4AE9588E.90708@jp.fujitsu.com>	<4AE9657F.7010302@kernel.org>	<4AE965D9.9040702@kernel.org> <20091104093044.17ab628a@jbarnes-piketon> <4AF1CD79.4010602@kernel.org> <4AF22CF1.1020508@kernel.org> <4AF22D26.4070500@kernel.org> <4AF508F0.9060105@kernel.org> <4AF91F54.10507@jp.fujitsu.com> <4AF936DB.1030309@kernel.org> <4AFCF7D8.1090207@jp.fujitsu.com> <4AFCFC0D.4030002@kernel.org> <4AFD19DA.7010602@jp.fujitsu.com> <4AFE6F39.5080505@kernel.org> <4B0B321E.4010103@jp.fujitsu.com> <4B0B335E.1070809@kernel.org> <4B0B3C13.9030502@jp.fujit! su.com> <4B0C69AD.3030106@kernel. org> <4B0D13EB.9010403@jp.fujitsu.com> <4B0D6CFE.4070804@kerne!
 l .org> <4B0E2388.50302@jp.fujitsu.com>
Message-Id: <A2C249D4-FC31-40D9-ACEA-807C336F8514@kernel.org>
From: Yinghai <yinghai@kernel.org>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
In-Reply-To: <4B0E2388.50302@jp.fujitsu.com>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7D11)
Mime-Version: 1.0 (iPhone Mail 7D11)
Subject: Re: [PATCH 1/2] pci: release that leaf bridge' resource that is not big -v11
Date: Wed, 25 Nov 2009 23:30:13 -0800
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





On Nov 25, 2009, at 10:43 PM, Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com 
 > wrote:

> Yinghai Lu wrote:
>> Kenji Kaneshige wrote:
>>> Hi Yinghai,
>>>
>>> I would like to reconfirm what is the problem you're trying to solve
>>> before reviewing and testing the additional patch. To be honest,  
>>> your
>>> patch looks more and more complicated and it is becoming difficult
>>> for me to review and test it.
>> the real problem:
>> 1. boot time:
>> BIOS separate IO range between several IOHs, and on some slots,  
>> BIOS assign the resource to the bridge, but stop
>> assigning resource to the device under that bridge, because the  
>> device need big resource.
>> so patch1 is trying to a. pci assign unassign and record the failed  
>> device resource.
>> b. clear the BIOS assigned resource of the parent bridge of fail  
>> device
>> c. go back and call pci assign unsigned
>> d. if it still fail, will go up more bridges. and clear and try  
>> again.
>> 2. hotplug:
>> BIOS separate IO range between several IOHs, and on some slots,  
>> BIOS assign the resource to every bridge. (8M)
>> but when insert one card that big resource, the card can not get  
>> resource. because kernel will not touch the bridge resource.
>> so patch2 is trying to
>> a. assign resource to devices with that slot. and record fail devices
>> b. if there is some failed, will clear sepcifically io port of  
>> bridge, or mmio of bridge, or mmio pref of bridge.
>> c. try to assign the parent bridge of the slot.
>> so it will keep original assigned resource by BIOS if possible.
>> and you have tested patch1 and patch2 in V11, but said patch1 may  
>> have shrinking resource problem.
>> the patch3 is addressing the patch1 that could shrinking resource  
>> for non-pcie hotplug bridge...
>>
>
> Thank you for the explanation. The patch3 seems to solve my concern.
>
> Your patch only touch the leaf bridge at the 2nd try of resource
> assignment. IIRC, this behavior is to prevent from shrinking bridge
> resources. Am I correct? I'm not sure but I think we don't need this
> behavior because now that we have another mechanism to prevent
> from shrinking bridge resource.
>>>

Third patch will only try to increase the bridge res

Try num still default to 5 , it could help other case

Can you send me whole bootlog  ?

Thanks

Yinghai
