Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab0CILwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 06:52:42 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37368 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab0CILwj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 06:52:39 -0500
Subject: Re: [PATCH] percpu,lockdep: implement and use
 is_static_percpu_address()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4B963441.40000@kernel.org>
References: <24605.1268073053@localhost> <1268073831.4997.69.camel@laptop>
	 <4B95AA4C.2030303@kernel.org> <4298.1268116039@localhost>
	 <4B95EE4C.3020606@kernel.org>  <4B9610E5.4080805@kernel.org>
	 <1268133942.4162.2.camel@twins>  <4B963441.40000@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 09 Mar 2010 12:52:20 +0100
Message-ID: <1268135540.4162.5.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-09 at 20:42 +0900, Tejun Heo wrote:
> Hello, Peter.
> 
> On 03/09/2010 08:25 PM, Peter Zijlstra wrote:
> >> +/* can't distinguish from other static vars, always false */
> >> +static inline bool is_static_percpu_address(unsigned long addr)
> >> +{
> >> +	return false;
> >> +}
> > 
> > At this point it might make sense to simply fail to compile if lockdep
> > is enabled as well.
> > 
> > I'm not sure if there's many SMP archs that don't have this and do have
> > lockdep, but simply failing this test isn't really an option.
> 
> That might be better.  Returning %false isn't that bad tho.  There
> really is no distinction between percpu and !percpu variable on UP and
> static variable address match will catch both.

Ah, if this is UP only then yes, no complaints ;-)

> >>  /**
> >> + * is_static_percpu_address - test whether address is from static percpu area
> >> + * @addr: address to test
> >> + *
> >> + * Test whether @addr belongs to static percpu area.  Module static
> >> + * percpu areas allocated via __alloc_reserved_percpu() is not
> >> + * considered.  Use is_module_address() for those.
> >> + *
> >> + * RETURNS:
> >> + * %true if @addr is from static percpu area, %false otherwise.
> >> + */
> > 
> > So is_module_address() will only return true for static per-cpu module
> > storage, right?
> 
> Right, got confused there.  I'll update is_static_percpu_address() to
> test for reserved regions too.

Or as per your other email, make the above be true, and have
is_module_address() be true for its static per-cpu regions.
