Return-Path: <linux-kernel-owner+w=401wt.eu-S1757194AbZEKJlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbZEKJlU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 05:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756443AbZEKJlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 05:41:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:14795 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438AbZEKJlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 05:41:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VWSrfZa3VRa98vJGJKp+9Fu4LwWiiMerBsYm9AE5QsMMlDFWIeUTzPpWyrwv/hZltq
         y0sK5aXydef93qDUzXGqi61GQIFbzkFrBY7jMGlQ/p4bQcsnYR1/KjKJ9hwXsy69Vtzh
         yTOKNCkxjzbIZ2reYfts5YhqtIxtI72y+EdTM=
Date: Mon, 11 May 2009 13:40:57 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ed Swierk <eswierk@aristanetworks.com>
Subject: Re: [PATCH] x86: read apic id if it is not acpi_lapic -v2
Message-ID: <20090511094056.GB4624@lenovo>
References: <20090430084145.GD21699@elte.hu> <49FBD0A2.4030309@kernel.org> <20090502070254.GA4791@lenovo> <49FC85A9.2070702@kernel.org> <20090511092655.GC26444@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090511092655.GC26444@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Mon, May 11, 2009 at 11:26:55AM +0200]
| 
| * Yinghai Lu <yinghai@kernel.org> wrote:
| 
| > @@ -1590,21 +1591,32 @@ void __init init_apic_mappings(void)
| >  	} else
| >  		apic_phys = mp_lapic_addr;
| >  
| > -	set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
| > +	/* lets check if we may to NOP'ify apic operations */
| > +	if (!cpu_has_apic) {
| > +		pr_info("APIC: disable apic facility\n");
| > +		apic_disable();
| > +		return;
| > +	}
| > +
| > +	/*
| > +	 * acpi lapic path already map that address in
| > +	 * acpi_register_lapic_address()
| > +	 */
| >  	apic_printk(APIC_VERBOSE, "mapped APIC to %08lx (%08lx)\n",
| >  				APIC_BASE, apic_phys);
| > +	if (acpi_lapic)
| > +		return;
| 
| why do we return here? We should sanity-check the APIC ID even if we 
| come from ACPI.
| 
| 	Ingo
| 

I believe we already have it checked in acpi_register_lapic_address
so no need to do it twice. Or I miss something?

	-- Cyrill
