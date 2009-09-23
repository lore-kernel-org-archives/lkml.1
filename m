Return-Path: <linux-kernel-owner+w=401wt.eu-S1753839AbZIWBUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbZIWBUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 21:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737AbZIWBUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 21:20:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:54067 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719AbZIWBUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 21:20:14 -0400
Message-ID: <4AB97776.3070906@kernel.org>
Date: Wed, 23 Sep 2009 10:18:46 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Axel Birndt <towerlexa@gmx.de>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Greg KH <greg@kroah.com>,
       Robert Hancock <hancockr@shaw.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-pci@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       Daniel Ritz <daniel.ritz@gmx.ch>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH 3/3 pci#linux-next] pccard: configure CLS on attach
References: <4A4EE3E9.7090205@kernel.org> <20090917103131.55eca691@jbarnes-g45> <4AB88C28.8070602@kernel.org> <4AB8A0A2.3010300@gmx.de>
In-Reply-To: <4AB8A0A2.3010300@gmx.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 23 Sep 2009 01:18:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Axel.

Axel Birndt wrote:
> Tejun Heo schrieb:
>> For non hotplug PCI devices, the system firmware usually configures
>> CLS correctly.  For pccard devices system firmware can't do it and
>> Linux PCI layer doesn't do it either.  Unfortunately this leads to
>> poor performance for certain devices (sata_sil).  Unless MWI, which
>> requires separate configuration, is to be used, CLS doesn't affect
>> correctness, so the configuration should be harmless.
>>
>> This patch makes pci_set_cacheline_size() always built and export it
>> and make pccard call it during attach.
>>
>> Please note that some other PCI hotplug drivers (shpchp and pciehp)
>> also configure CLS on hotplug.
> 
> i would like to ask, when this patch is usable for normal guy's, like me.
> could you tell me in which kernel release or in which bugfix this will
> be implemented?
> 
> currently i'am using Kubuntu 8.04 with all current released bugfixes and
> kernel updates...

This patch is rather dangerous and should sit out for a while in
linux-next and then -rc.  In mainline, I think it will appear in
2.6.33.  Distros may choose to backport them but I don't think they'll
do it before the change at least lands on -rc which is at least 3+
months away.  It's also possible for distros to backport it but enable
it only if certain kernel parameter is set but you'll have to ask each
distro whether they're willing to do such thing.

Thanks.

-- 
tejun
