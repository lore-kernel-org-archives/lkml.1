Return-Path: <linux-kernel-owner+w=401wt.eu-S1759038AbZA2UD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038AbZA2UD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 15:03:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbZA2UDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 15:03:33 -0500
Received: from relay2.sgi.com ([192.48.179.30]:58796 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751558AbZA2UDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 15:03:31 -0500
Date: Thu, 29 Jan 2009 14:03:28 -0600
From: Jack Steiner <steiner@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: suresh.b.siddha@intel.com, linux-kernel@vger.kernel.org
Subject: Re: Possible x2apic breakage
Message-ID: <20090129200328.GA4210@sgi.com>
References: <20090129154146.GA2694@sgi.com> <20090129161546.GB28984@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129161546.GB28984@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 05:15:46PM +0100, Ingo Molnar wrote:
> 
> * Jack Steiner <steiner@sgi.com> wrote:
> 
> > Suresh -
> > 
> > This popped up in Ingo's x86 tree yesterday. This appears to be breaking
> > on our simulator running in x2apic mode. If I understand the code,
> > this is a real breakage and not a problem in our simulator:
> > 
> > 
> > arch/x86/include/asm/genapic.h
> > 
> > 	static inline unsigned int read_apic_id(void)
> > 	{
> >         	unsigned int reg;
> > 
> >         	reg = *(u32 *)(APIC_BASE + APIC_ID);
> >         	return apic->get_apic_id(reg);
> > 	}
> > 
> > 
> > As expected, the failure occurs right after:
> > 
> > 	Enabling x2apic
> > 	Enabled x2apic and interrupt-remapping
> > 
> > The next reference to apicid tries to read from mem instead of MSRs.
> 
> yes - Suresh sent a fix earlier today. Could you please check latest 
> tip/master (v2.6.29-rc3-1212-g69f3c6d or later), does it work fine in your 
> simulator?

That fixed it. The latest tree now runs our (very limited) regression suite
of tests on all apic modes.

Thanks...


--- jack
