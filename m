Return-Path: <linux-kernel-owner+w=401wt.eu-S1756607AbZETMON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607AbZETMON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 08:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755684AbZETMN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 08:13:58 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:40296 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbZETMN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 08:13:57 -0400
To: "Han\, Weidong" <weidong.han@intel.com>
Cc: "'Ingo Molnar'" <mingo@elte.hu>, "'Yinghai Lu'" <yinghai@kernel.org>,
       "'Joerg Roedel'" <joerg.roedel@amd.com>,
       "'dwmw2\@infradead.org'" <dwmw2@infradead.org>,
       "Siddha\, Suresh B" <suresh.b.siddha@intel.com>,
       "'linux-kernel\@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'iommu\@lists.linux-foundation.org'" 
	<iommu@lists.linux-foundation.org>,
       "'kvm\@vger.kernel.org'" <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] Intel-IOMMU, intr-remap: source-id checking
References: <1242757912-6041-1-git-send-email-weidong.han@intel.com>
	<1242757912-6041-3-git-send-email-weidong.han@intel.com>
	<20090519115055.GB14305@elte.hu> <m1k54cj3iz.fsf@fess.ebiederm.org>
	<20090520082114.GC6736@elte.hu>
	<715D42877B251141A38726ABF5CABF2C054568FF38@pdsmsx503.ccr.corp.intel.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 20 May 2009 05:13:54 -0700
In-Reply-To: <715D42877B251141A38726ABF5CABF2C054568FF38@pdsmsx503.ccr.corp.intel.com> (Weidong Han's message of "Wed\, 20 May 2009 16\:38\:53 +0800")
Message-ID: <m13ab0m0ot.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: weidong.han@intel.com, kvm@vger.kernel.org, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com, dwmw2@infradead.org, joerg.roedel@amd.com, yinghai@kernel.org, mingo@elte.hu
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Han, Weidong" <weidong.han@intel.com> writes:

>>> The early pci reading of the bus is just wrong.  What happens if
>>> the pci layer decided to renumber things?  It looks like we have a
>>> real dependency on pci there and are avoiding sorting it out with
>>> this.
>> 
>> Yes ... but is there much we can do about this bootstrap dependency?
>> We want to enable the IO-APIC very early in its final form. There's
>> quite a bit of IRQ functionality that doesnt go via the PCI layer,
>> and which is being relied on by early bootup. The timer irq must
>> work, etc.
>
> Currently VT-d code didn't support pci rebalance. There is much work to do. It needs to track devcie identity changes and resultant imapct to Device Scope under each VT-d engine.

Sure.  I am thinking of the much simpler case where the BIOS goofs up
and we need to apply some fixes at boot time.  If you can't
delay things enough to get your hands on the pci dev of your
iommu.  If you can't get that far supporting pci rebalance under VT-d is
impossible.

Eric
