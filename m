Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959AbZGAVDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbZGAVDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 17:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbZGAVDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 17:03:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:44288 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbZGAVDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 17:03:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,328,1243839600"; 
   d="scan'208";a="471293231"
Subject: Re: [PATCH v5] enable x2APIC without interrupt remapping under KVM
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: Gleb Natapov <gleb@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "avi@redhat.com" <avi@redhat.com>, mingo@elte.hu
In-Reply-To: <20090701133007.GC27539@redhat.com>
References: <20090701133007.GC27539@redhat.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 01 Jul 2009 14:00:17 -0700
Message-Id: <1246482017.27006.10670.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-01 at 06:30 -0700, Gleb Natapov wrote:
> KVM would like to provide x2APIC interface to a guest without emulating
> interrupt remapping device. The reason KVM prefers guest to use x2APIC
> is that x2APIC interface is better virtualizable and provides better
> performance than mmio xAPIC interface:
>     
> - msr exits are faster than mmio (no page table walk, emulation)
> - no need to read back ICR to look at the busy bit
> - one 64 bit ICR write instead of two 32 bit writes
> - shared code with the Hyper-V paravirt interface
>     
> Included patch changes x2APIC enabling logic to enable it even if IR
> initialization failed, but kernel runs under KVM and no apic id is
> greater than 255 (if there is one spec requires BIOS to move to x2apic
> mode before starting an OS).
> 
> Signed-off-by: Gleb Natapov <gleb@redhat.com>

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

