Return-Path: <linux-kernel-owner+w=401wt.eu-S1757187AbZBSXaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187AbZBSXaa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 18:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429AbZBSXaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 18:30:20 -0500
Received: from mga03.intel.com ([143.182.124.21]:10945 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753645AbZBSXaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 18:30:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,237,1233561600"; 
   d="scan'208";a="112486643"
Subject: Re: [PATCH] x86: enable x2apic early at the first point
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       gleb@redhat.com
In-Reply-To: <499DE05A.40804@kernel.org>
References: <499DD40F.40102@kernel.org> <1235081612.14523.23.camel@vayu>
	 <499DE05A.40804@kernel.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 19 Feb 2009 15:28:38 -0800
Message-Id: <1235086118.14523.40.camel@vayu>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-19 at 14:42 -0800, Yinghai Lu wrote:
> Ingo want to decouple that x2apic and intr_remapping.
> it seems it does work with x2apic without intr_remapping in one of setup.

x2apic with out intr-remapping is not architectural. Even when we have <
255 logical cpu's, logical x2apic id's will be greater than 16 bits even
on a single/two socket systems and this will break interrupt delivery.
Please look at the x2apic logical destination mode definition in the SDM
(Section 9.7.2.3 and 9.7.2.4 in my copy of SDM Vol3a)

While it might work in certain configurations (for example, physical
mode with < 8 bit apicids), it is not architectural and implementation
dependent, which may break in future generations.

And also, logical x2apic mode has more advantages compared to physical
mode (like using lowest priority delivery mode etc).

I will post couple of patches, which revert's Gleb's patch and another
fix for the early boot failure issue, tomorrow.

thanks,
suresh





