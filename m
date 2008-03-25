Return-Path: <linux-kernel-owner+w=401wt.eu-S1758561AbYCYQUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561AbYCYQUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 12:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756805AbYCYQUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 12:20:01 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60022 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756101AbYCYQUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 12:20:00 -0400
Date: Tue, 25 Mar 2008 11:19:57 -0500
From: Jack Steiner <steiner@sgi.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 6/8] x86_64: Define the macros and tables for the basic UV infrastructure.
Message-ID: <20080325161957.GA1884@sgi.com>
References: <20080324182118.GA21758@sgi.com> <87ej9zi05c.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ej9zi05c.fsf@basil.nowhere.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 11:11:11AM +0100, Andi Kleen wrote:
> Jack Steiner <steiner@sgi.com> writes:
> 
> > Define the macros and tables for the basic UV infrastructure.
> > 
> > 
> > (NOTE: a work-in-progress. Pieces missing....)
> 
> Does the kernel really need all this information? You just want
> to address the UV-APIC right? I suspect you could use a much stripped
> down file.

Most of the macros will never be used by generic kernel code, but we
have UV-specific drivers that will use the information (GRU, XPC and
XPMEM drivers). All of these are getting very close to being ready to
be pushed upstream.

> 
> > +DECLARE_PER_CPU(struct uv_hub_info_s, __uv_hub_info);
> > +#define uv_hub_info 		(&__get_cpu_var(__uv_hub_info))
> > +#define uv_cpu_hub_info(cpu)	(&per_cpu(__uv_hub_info, cpu))
> > +
> > +/* This header file is used in BIOS code that runs in physical mode */
> 
> Not sure what physical mode is.

Me either :-)    I fixed the comment
	"... BIOS code that runs with virtual == physical"

However, then I read the rest of your comments & will take the approach
of defining __va() in the BIOS code. That eliminates the need for
the macro.

> 
> > +#ifdef __BIOS__
> > +#define UV_ADDR(x)		((unsigned long *)(x))
> > +#else
> > +#define UV_ADDR(x)		((unsigned long *)__va(x))
> > +#endif
> 
> But it it would be cleaner if your BIOS just supplied a suitable __va()
> and then you remove these macros.
> 
> -Andi

--- jack
