Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbZETMZD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbZETMZD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 08:25:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026AbZETMYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 08:24:53 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:34053 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955AbZETMYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 08:24:52 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joerg.roedel@amd.com>,
       Weidong Han <weidong.han@intel.com>, dwmw2@infradead.org,
       suresh.b.siddha@intel.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/2] Intel-IOMMU, intr-remap: source-id checking
References: <1242757912-6041-1-git-send-email-weidong.han@intel.com>
	<1242757912-6041-3-git-send-email-weidong.han@intel.com>
	<20090519115055.GB14305@elte.hu> <m1k54cj3iz.fsf@fess.ebiederm.org>
	<20090520082114.GC6736@elte.hu>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 20 May 2009 05:24:49 -0700
In-Reply-To: <20090520082114.GC6736@elte.hu> (Ingo Molnar's message of "Wed\, 20 May 2009 10\:21\:14 +0200")
Message-ID: <m1fxf0klm6.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: mingo@elte.hu, kvm@vger.kernel.org, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com, dwmw2@infradead.org, weidong.han@intel.com, joerg.roedel@amd.com, yinghai@kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

>> The table of apic information by apic_id also seems wrong.  Don't 
>> we have chip_data or something that should point it that we can 
>> get from the irq?
>
> ->chip_data is already used for io-apic configuration bits - if it's 
> reused then the right way to do it is to extend struct irq_cfg in 
> arch/x86/kernel/apic/io_apic.c.

We are talking about some extra io-apic configuration bits, that
happen to currently be private to dmar.c.

chip_data, handler_data I can never keep those straight except
when I am deep in the code.  What I do know is that encouraging
more arrays of size MAX_IO_APICS seems like the wrong direction.

Which probably means adding the information we need to struct irq_cfg.

Eric
