Return-Path: <linux-kernel-owner+w=401wt.eu-S1756760AbZETMCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbZETMCi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 08:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754932AbZETMCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 08:02:30 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:56445 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771AbZETMC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 08:02:29 -0400
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Weidong Han <weidong.han@intel.com>, dwmw2@infradead.org,
       suresh.b.siddha@intel.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/2] Intel-IOMMU, intr-remap: source-id checking
References: <1242757912-6041-1-git-send-email-weidong.han@intel.com>
	<1242757912-6041-3-git-send-email-weidong.han@intel.com>
	<20090519115055.GB14305@elte.hu> <m1k54cj3iz.fsf@fess.ebiederm.org>
	<20090520082114.GC6736@elte.hu> <20090520094310.GF9835@amd.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 20 May 2009 05:02:23 -0700
In-Reply-To: <20090520094310.GF9835@amd.com> (Joerg Roedel's message of "Wed\, 20 May 2009 11\:43\:10 +0200")
Message-ID: <m1r5ykm180.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: joerg.roedel@amd.com, kvm@vger.kernel.org, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com, dwmw2@infradead.org, weidong.han@intel.com, yinghai@kernel.org, mingo@elte.hu
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel <joerg.roedel@amd.com> writes:

> On Wed, May 20, 2009 at 10:21:14AM +0200, Ingo Molnar wrote:
>> 
>> * Eric W. Biederman <ebiederm@xmission.com> wrote:
>> > Being a major nitpick, I have to point out that the code is not 
>> > structured to support other iommus, and I think AMD has one that 
>> > can do this as well.
>> 
>> (Joerg Cc:-ed)
>
> The AMD IOMMU does also have an interrupt remapping feature. But it is
> currently unsupported in the Linux driver. When this is going to be
> implemented I think we can go the same way as for device passthrough in
> KVM. This was an Intel-only feature too and was later adapted to support
> AMD IOMMU too.

The Intel IOMMU is also interesting because it allows traffic from
buggy ioapcis to be remapped safely in process context, adding a large
margin of safety and flexibility to the existing irq migration
and cpu hotunplug scenarios.

Can we use the AMD IOMMU to achieve the same objective?

I would really like to say from point X on AMD and Intel systems don't
have to worry about irq migrations used caused by old buggy ioapic
state machines, which I have previously confirmed in both AMD and
Intel ioapics.

Eric
