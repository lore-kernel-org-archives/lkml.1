Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbYIEJS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbYIEJS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 05:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbYIEJSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 05:18:46 -0400
Received: from outbound-mail-39.bluehost.com ([69.89.20.193]:55982 "HELO
	outbound-mail-39.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752125AbYIEJSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 05:18:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=TdSz9zRffbxJnU43U/8iBAP1bdaSe2hd1GFz6Jt7uKOTGHzZoMF9f0pSnAsKnJb3+56PSte3hl6ojdX+T0VKHXRet/vMkm/1Ap5ohg/lnB2z4R6n/vRPvTUUZ1t3QyZX;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 1/5] x2apic: fix reserved APIC register accesses in print_local_APIC()
Date: Fri, 5 Sep 2008 02:18:25 -0700
User-Agent: KMail/1.9.9
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
References: <20080904000237.746216000@linux-os.sc.intel.com> <20080904175139.GN14481@linux-os.sc.intel.com> <20080905081042.GD12409@elte.hu>
In-Reply-To: <20080905081042.GD12409@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809050218.25504.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 212.183.134.129 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 05, 2008 1:10 am Ingo Molnar wrote:
> * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> > On Thu, Sep 04, 2008 at 04:06:31AM -0700, Ingo Molnar wrote:
> > > applied the following patches tip/irq/sparseirq:
> >
> > Ingo, Shouldn't this go to tip/x86/x2apic ? Thanks.
>
> normally yes - but this is a special case: there's existing overlap with
> other DMAR changes in irq/sparseirq (intr-remap and ioapic unification
> changes), so these followups have to go there too. Also, since they
> change the generic PCI code it's better they live in a generic topic to
> begin with. The full stack of pending changes is:
>
> 0f48966: dmar: fix dmar_parse_dev() devices_cnt error condition check
> 2283240: dmar: use list_for_each_entry_safe() in dmar_dev_scope_init()
> 3f1fdb3: dmar: initialize the return value in dmar_parse_dev()
> f12c73e: dmar: fix using early fixmap mapping for DMAR table parsing
> 1cb1158: x64, x2apic/intr-remap: disable DMA-remapping if
> Interrupt-remapping is detected (temporary quirk) 2ae2101: x64,
> x2apic/intr-remap: Interrupt remapping infrastructure fe962e9: x64,
> x2apic/intr-remap: Queued invalidation infrastructure (part of VT-d)
> ad3ad3f: x64, x2apic/intr-remap: parse ioapic scope under vt-d structures
> 2d6b5f8: x64, x2apic/intr-remap: Fix the need for RMRR in the DMA-remapping
> detection aaa9d1d: x64, x2apic/intr-remap: use CONFIG_DMAR for
> DMA-remapping specific code 1886e8a: x64, x2apic/intr-remap: code
> re-structuring, to be used by both DMA and Interrupt remapping c42d9f3:
> x64, x2apic/intr-remap: fix the need for sequential array allocation of
> iommus e61d98d: x64, x2apic/intr-remap: Intel vt-d, IOMMU code
> reorganization
>
> Jesse, do you have any objections to this approach?

Nope, no problems.  I think I have some pending patches that may have 
conflicts with the above, but I'll take care of that when I get back to the 
US (I think Sunday or Monday will be a massive patch review/merge/comment 
day).

Thanks,
Jesse
