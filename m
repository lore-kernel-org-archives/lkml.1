Return-Path: <linux-kernel-owner+w=401wt.eu-S1760367AbXKMVO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760367AbXKMVO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:14:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756930AbXKMVOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:14:18 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:51380 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755899AbXKMVOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:14:18 -0500
Date: Tue, 13 Nov 2007 13:13:45 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: William Cohen <wcohen@redhat.com>
Cc: akpm@osdl.org, Robert Richter <robert.richter@amd.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, perfmon@napali.hpl.hp.com,
       Andi Kleen <andi@firstfloor.org>, perfmon2-devel@lists.sourceforge.net,
       perfmon@napali.hpl.hp.com
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Message-ID: <20071113211345.GB5747@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20071107003454.GA13374@kroah.com> <20071109120627.60ec9ab4.akpm@linux-foundation.org> <20071109213829.GC28276@kroah.com> <p73abpl2654.fsf@bingen.suse.de> <20071113151718.GA3804@erda.amd.com> <4739C42F.8030208@redhat.com> <20071113175545.GD4319@frankl.hpl.hp.com> <4739EE13.2090006@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4739EE13.2090006@redhat.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Will,

On Tue, Nov 13, 2007 at 01:33:55PM -0500, William Cohen wrote:
> 
> The oprofile module can setup a handler for PMU interrupts. This is done in 
> archi/x86/oprofile/nmi_int:nmi_cpu_setup().  Other modules could do the 
> same. However, it bumps what ever was using the nmi/pmu off, then restores 
> nmi/pmu when oprofile is shut down. Maybe the pmu/nmi resource reservation 
> mechanism should be another self-contained patch.
> 

Oprofile does not setup the PMU interrupt. It builds on top of the NMI watchdog
setup. It uses the register_die() mechanism, if I recall. The low level APIC
and gate is setup elsewhere. Perfmon does not use NMI, unless forced to because
of the NMI watchdog. 


> >	- we could not support per-thread mode with the kernel module 
> >	approach due to
> >	  link to the context switch code. I do believe per-thread is a key 
> >	  value-add
> >	  for performance monitoring.
> 
> The per-thread monitoring is useful to a number of people and many people 
> want it. The thought was how to break the large perfmon patch into set of 
> smaller incremental patches. So it isn't whether to have per-thread pmu 
> virtualization, but rather when/how to get it in.

I think we all agree on this.

-- 

-Stephane
