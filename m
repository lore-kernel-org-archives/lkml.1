Return-Path: <linux-kernel-owner+w=401wt.eu-S1753750AbZJ2JDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbZJ2JDg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 05:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZJ2JDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 05:03:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:37499 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbZJ2JDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 05:03:34 -0400
Message-ID: <4AE95A57.6050504@kernel.org>
Date: Thu, 29 Oct 2009 02:03:19 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Alex Chiang <achiang@hp.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH] pci: pciehp update the slot bridge res to get big range
 for pcie devices
References: <4ADEB601.8020200@kernel.org> <4AE52B68.3070501@jp.fujitsu.com>	<4AE53883.3070709@kernel.org> <4AE5545E.1020900@jp.fujitsu.com>	<4AE55D12.30403@kernel.org> <4AE57976.4060107@jp.fujitsu.com>	<4AE5E37F.8070707@kernel.org> <4AE5EFDB.2060908@kernel.org>	<4AE80170.6030402@jp.fujitsu.com> <4AE88305.8020207@kernel.org>	<m1ljivibrt.fsf@fess.ebiederm.org> <4AE897B4.9030206@kernel.org>	<m1eionia3y.fsf@fess.ebiederm.org> <4AE8A080.1040208@kernel.org>	<m1pr87cilf.fsf@fess.ebiederm.org> <4AE8BA1D.5030908@kernel.org>	<4AE8C4BF.8040306@kernel.org> <m1my3aboon.fsf@fess.ebiederm.org>
In-Reply-To: <m1my3aboon.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Yinghai Lu <yinghai@kernel.org> writes:
>> after closing look up the code, it looks it will not break your setup.
>>
>> 1. before the patches:
>> a. when master card is inserted, all bridge in that card will get assigned with min_size
>> b. when new cards is inserted to those slots in master card, will get assigned in the bridge size.
>>
>> 2. after the patches: v5
>> a. booted up, all leaf bridge mmio get clearred.
>> b. when master card is inserted, all bridge in that card will get assigned with min_size, and master bridge will be sum of them
>> c. when new cards is inserted to those slots in master card, will get assigned in the bridge size.
>>
>> can you check those two patches in your setup to verify it?
> 
> I have a much simpler case I will break, as I tried something similar by accident.
which kernel version?
> 
> AMD cpu MCP55 with one pcie port setup as hotplug.
> The system only has 2GB of RAM.  So plenty of space for pcie devices.

one or two ht chains?

do you still have lspci -tv with it?

> 
> If the firmware assigns nothing and linux at boot time assigns the pci mmio space:
> Reads from the bar of the hotplugged device work
> Writes to the bar of the hotplugged device, cause further writes to go to lala land.
> 
> So I had to have the firmware make the assignment, because only it knows the
> details of the hidden AMD bar registers for each hypertransport chain etc.

that mean kernel doesn't get peer root bus res probed properly


YH
