Return-Path: <linux-kernel-owner+w=401wt.eu-S1752690AbZKDSxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbZKDSxc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 13:53:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbZKDSxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 13:53:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:48563 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbZKDSxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 13:53:30 -0500
Message-ID: <4AF1CD79.4010602@kernel.org>
Date: Wed, 04 Nov 2009 10:52:41 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH 2/2] pci: pciehp update the slot bridge res to get big
 range for pcie devices - v5
References: <4ADEB601.8020200@kernel.org>	<4AE52B68.3070501@jp.fujitsu.com>	<4AE53883.3070709@kernel.org>	<4AE5545E.1020900@jp.fujitsu.com>	<4AE55D12.30403@kernel.org>	<4AE57976.4060107@jp.fujitsu.com>	<4AE5E37F.8070707@kernel.org>	<4AE5EFDB.2060908@kernel.org>	<4AE80170.6030402@jp.fujitsu.com>	<4AE88305.8020207@kernel.org>	<m1ljivibrt.fsf@fess.ebiederm.org>	<4AE899A0.3020006@kernel.org>	<4AE95247.8080401@jp.fujitsu.com>	<4AE952B9.1010603@kernel.org>	<4AE9588E.90708@jp.fujitsu.com>	<4AE9657F.7010302@kernel.org>	<4AE965D9.9040702@kernel.org> <20091104093044.17ab628a@jbarnes-piketon>
In-Reply-To: <20091104093044.17ab628a@jbarnes-piketon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Thu, 29 Oct 2009 02:52:25 -0700
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> move out bus_size_bridges and assign resources out of
>> pciehp_add_bridge() and at last do them all together one time
>> including slot bridge, to avoid to call assign resources several
>> times, when there are several bridges under the slot bridge.
>>
>> need to introduce pci_bridge_assign_resources there.
>>
>> handle the case the slot bridge that doesn't get pre-allocated big
>> enough res from FW.
>> for example pcie devices need 256M, but the bridge only get
>> preallocated 2M...
>>
>> pci_setup_bridge() will take extra check_enabled for the slot bridge,
>> otherwise update res is not updated to bridge BAR. that is bridge is
>> enabled already for port service.
>>
>> -v2: address Alex's concern about pci remove/rescan feature about
>> pci_setup_bridge changes. -v3: Kenji pointed out that pci_config_slot
>> need to be called before pci_bus_add_devices() -v4: move out
>> pci_is_enabled checkout of pci_setup_bridge() -v5: change the
>> applying sequence.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> Where are we with this patchset?  Given the nature of the changes I'll
> definitely want to get a few Tested-bys in addition to acks from people
> involved in this thread.

already have -v8.

but will refresh them after you push out your tree with several patches from Bjorn.

YH
