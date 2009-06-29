Return-Path: <linux-kernel-owner+w=401wt.eu-S1758404AbZF2LZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404AbZF2LZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 07:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbZF2LZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 07:25:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56238 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbZF2LZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 07:25:31 -0400
Date: Mon, 29 Jun 2009 14:25:31 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "avi@redhat.com" <avi@redhat.com>
Subject: Re: [PATCH v2] enable x2APIC without interrupt remapping under KVM
Message-ID: <20090629112531.GA20289@redhat.com>
References: <20090629100837.GW20289@redhat.com> <1246272416.27006.10632.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246272416.27006.10632.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 03:46:56AM -0700, Suresh Siddha wrote:
> On Mon, 2009-06-29 at 03:08 -0700, Gleb Natapov wrote:
> >  
> > -	local_irq_save(flags);
> >  	mask_IO_APIC_setup(ioapic_entries);
> > -	mask_8259A();
> 
> Is there a reason why the 8259 mask/unmask operations are separated from
> io-apic mask/unmask operations.
> 
I left interrupt masking in enable_IR_x2apic() because interrupt should
be masked during transition to x2apic mode, so it can't be moved to
enable_IR(). I moved io-apic into enable_IR() because the state of
io-apic depend on whether IR was enabled or not, so I left it close to
IR enabling logic. Also io-apic masking can fail, but we still want to
enable x2apic on KVM if possible, and moving io-apic masking to
enable_IR_x2apic() will complicate the logic.

> Can we keep it together so that it will be easy to read and understand
> that we first do the interrupt subsystem mask, try enabling IR and
> x2apic and  unmask the interrupt subsystem.
> 
For io-apic this is not 100% symmetric. We mask io-apic, enable IR and
if this succeeds we do not unmask io-apic.

> Otherwise I am ok with this change.
> 
> thanks,
> suresh

--
			Gleb.
