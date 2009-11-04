Return-Path: <linux-kernel-owner+w=401wt.eu-S1754346AbZKDRao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbZKDRao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:30:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbZKDRan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:30:43 -0500
Received: from outbound-mail-39.bluehost.com ([69.89.20.193]:49608 "HELO
	outbound-mail-39.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752842AbZKDRam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:30:42 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ga0TsFFfEOz/DaWYhdJ4xD79kfZYGDAt3tUIZyZKL/yxJHzxkhxPl4tzM7QtlWDDuXuFTqWwvrNVvtXLy3bv3sjuSeSx4XrEh9wrpaVkj1gxMlOXq+et4y//F9WlNxta;
Date: Wed, 4 Nov 2009 09:30:44 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH 2/2] pci: pciehp update the slot bridge res to get big
 range for pcie devices - v5
Message-ID: <20091104093044.17ab628a@jbarnes-piketon>
In-Reply-To: <4AE965D9.9040702@kernel.org>
References: <4ADEB601.8020200@kernel.org>
	<4AE52B68.3070501@jp.fujitsu.com>
	<4AE53883.3070709@kernel.org>
	<4AE5545E.1020900@jp.fujitsu.com>
	<4AE55D12.30403@kernel.org>
	<4AE57976.4060107@jp.fujitsu.com>
	<4AE5E37F.8070707@kernel.org>
	<4AE5EFDB.2060908@kernel.org>
	<4AE80170.6030402@jp.fujitsu.com>
	<4AE88305.8020207@kernel.org>
	<m1ljivibrt.fsf@fess.ebiederm.org>
	<4AE899A0.3020006@kernel.org>
	<4AE95247.8080401@jp.fujitsu.com>
	<4AE952B9.1010603@kernel.org>
	<4AE9588E.90708@jp.fujitsu.com>
	<4AE9657F.7010302@kernel.org>
	<4AE965D9.9040702@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Oct 2009 02:52:25 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> 
> move out bus_size_bridges and assign resources out of
> pciehp_add_bridge() and at last do them all together one time
> including slot bridge, to avoid to call assign resources several
> times, when there are several bridges under the slot bridge.
> 
> need to introduce pci_bridge_assign_resources there.
> 
> handle the case the slot bridge that doesn't get pre-allocated big
> enough res from FW.
> for example pcie devices need 256M, but the bridge only get
> preallocated 2M...
> 
> pci_setup_bridge() will take extra check_enabled for the slot bridge,
> otherwise update res is not updated to bridge BAR. that is bridge is
> enabled already for port service.
> 
> -v2: address Alex's concern about pci remove/rescan feature about
> pci_setup_bridge changes. -v3: Kenji pointed out that pci_config_slot
> need to be called before pci_bus_add_devices() -v4: move out
> pci_is_enabled checkout of pci_setup_bridge() -v5: change the
> applying sequence.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Where are we with this patchset?  Given the nature of the changes I'll
definitely want to get a few Tested-bys in addition to acks from people
involved in this thread.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
