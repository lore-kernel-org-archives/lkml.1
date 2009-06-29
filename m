Return-Path: <linux-kernel-owner+w=401wt.eu-S1758874AbZF2KuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874AbZF2KuH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 06:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755948AbZF2Kt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 06:49:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:27380 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484AbZF2Ktz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 06:49:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,309,1243839600"; 
   d="scan'208";a="159542421"
Subject: Re: [PATCH v2] enable x2APIC without interrupt remapping under KVM
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: Gleb Natapov <gleb@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "avi@redhat.com" <avi@redhat.com>
In-Reply-To: <20090629100837.GW20289@redhat.com>
References: <20090629100837.GW20289@redhat.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 29 Jun 2009 03:46:56 -0700
Message-Id: <1246272416.27006.10632.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-29 at 03:08 -0700, Gleb Natapov wrote:
>  
> -	local_irq_save(flags);
>  	mask_IO_APIC_setup(ioapic_entries);
> -	mask_8259A();

Is there a reason why the 8259 mask/unmask operations are separated from
io-apic mask/unmask operations.

Can we keep it together so that it will be easy to read and understand
that we first do the interrupt subsystem mask, try enabling IR and
x2apic and  unmask the interrupt subsystem.

Otherwise I am ok with this change.

thanks,
suresh

