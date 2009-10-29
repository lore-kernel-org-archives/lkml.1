Return-Path: <linux-kernel-owner+w=401wt.eu-S1753111AbZJ2IQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbZJ2IQK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 04:16:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbZJ2IQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 04:16:09 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:59160 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbZJ2IQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 04:16:07 -0400
To: Yinghai Lu <yinghai@kernel.org>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Alex Chiang <achiang@hp.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH] pci: pciehp update the slot bridge res to get big range for pcie devices
References: <4ADEB601.8020200@kernel.org> <4AE52B68.3070501@jp.fujitsu.com>
	<4AE53883.3070709@kernel.org> <4AE5545E.1020900@jp.fujitsu.com>
	<4AE55D12.30403@kernel.org> <4AE57976.4060107@jp.fujitsu.com>
	<4AE5E37F.8070707@kernel.org> <4AE5EFDB.2060908@kernel.org>
	<4AE80170.6030402@jp.fujitsu.com> <4AE88305.8020207@kernel.org>
	<m1ljivibrt.fsf@fess.ebiederm.org> <4AE897B4.9030206@kernel.org>
	<m1eionia3y.fsf@fess.ebiederm.org> <4AE8A080.1040208@kernel.org>
	<m1pr87cilf.fsf@fess.ebiederm.org> <4AE8BA1D.5030908@kernel.org>
	<4AE8C4BF.8040306@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 29 Oct 2009 01:16:08 -0700
In-Reply-To: <4AE8C4BF.8040306@kernel.org> (Yinghai Lu's message of "Wed\, 28 Oct 2009 15\:25\:03 -0700")
Message-ID: <m1my3aboon.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:
>
> after closing look up the code, it looks it will not break your setup.
>
> 1. before the patches:
> a. when master card is inserted, all bridge in that card will get assigned with min_size
> b. when new cards is inserted to those slots in master card, will get assigned in the bridge size.
>
> 2. after the patches: v5
> a. booted up, all leaf bridge mmio get clearred.
> b. when master card is inserted, all bridge in that card will get assigned with min_size, and master bridge will be sum of them
> c. when new cards is inserted to those slots in master card, will get assigned in the bridge size.
>
> can you check those two patches in your setup to verify it?

I have a much simpler case I will break, as I tried something similar by accident.

AMD cpu MCP55 with one pcie port setup as hotplug.
The system only has 2GB of RAM.  So plenty of space for pcie devices.

If the firmware assigns nothing and linux at boot time assigns the pci mmio space:
Reads from the bar of the hotplugged device work
Writes to the bar of the hotplugged device, cause further writes to go to lala land.

So I had to have the firmware make the assignment, because only it knows the
details of the hidden AMD bar registers for each hypertransport chain etc.

I don't see how throwing away the work that the firmware has done in
preallocation is something that we can afford to do in general if what
the firmware has done works for us.

Eric
