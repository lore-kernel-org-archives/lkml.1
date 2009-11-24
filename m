Return-Path: <linux-kernel-owner+w=401wt.eu-S932106AbZKXBvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106AbZKXBvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 20:51:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757503AbZKXBvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 20:51:39 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44507 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbZKXBvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 20:51:38 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B0B3C13.9030502@jp.fujitsu.com>
Date: Tue, 24 Nov 2009 10:51:15 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH 1/2] pci: release that leaf bridge' resource that is not
 big -v11
References: <4ADEB601.8020200@kernel.org>	<4AE52B68.3070501@jp.fujitsu.com>	<4AE53883.3070709@kernel.org>	<4AE5545E.1020900@jp.fujitsu.com>	<4AE55D12.30403@kernel.org>	<4AE57976.4060107@jp.fujitsu.com>	<4AE5E37F.8070707@kernel.org>	<4AE5EFDB.2060908@kernel.org>	<4AE80170.6030402@jp.fujitsu.com>	<4AE88305.8020207@kernel.org>	<m1ljivibrt.fsf@fess.ebiederm.org>	<4AE899A0.3020006@kernel.org>	<4AE95247.8080401@jp.fujitsu.com>	<4AE952B9.1010603@kernel.org>	<4AE9588E.90708@jp.fujitsu.com>	<4AE9657F.7010302@kernel.org>	<4AE965D9.9040702@kernel.org> <20091104093044.17ab628a@jbarnes-piketon> <4AF1CD79.4010602@kernel.org> <4AF22CF1.1020508@kernel.org> <4AF22D26.4070500@kernel.org> <4AF508F0.9060105@kernel.org> <4AF91F54.10507@jp.fujitsu.com> <4AF936DB.1030309@kernel.org> <4AFCF7D8.1090207@jp.fujitsu.com> <4AFCFC0D.4030002@kernel.org> <4AFD19DA.7010602@jp.fujitsu.com> <4AFE6F39.5080505@kernel.org> <4B0B321E.4010103@jp.fujitsu.com> <4B0B335E.1070809@kernel.org>
In-Reply-To: <4B0B335E.1070809@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> Kenji Kaneshige wrote:
>> Hi,
>>
>> I tried v11 patches. This version seems to fix the problem I
>> reported against previous version.
>>
>> I have no objection against the idea of resource allocation
>> changes for PCI express hotplug slots.
> 
> thanks
> 
>> But I still have concern about changing resource allocation for
>> other than PCI express hotplug slots. For example, some hotplug
>> controller other than PCI express can have multiple slots under
>> the same bus. If some hotplug slots are occupied and the others
>> are empty at the boot time, I think your code try to shrink the
>> bus resources for hotplug slots allocated by BIOS. It would break
>> the hot-add on the empty slots due to the resource allocation
>> failure.
> 
> no,
> it will not touch bridge resources that already assigned by BIOS except
> some bridge resource is not big enough. and get big one for them.
> 

Ok, I understood that if the BIOS assigns enough resources to the
bridge, it has no impact.

One question. I thought your patch shrinks the bridge resource to
allocate enough resource for sibling bridge. But it actually doesn't.
Right?

It would be appreciated if you update the patch description about
the problem and how to fix/improbe it.

Thanks,
Kenji Kaneshige

