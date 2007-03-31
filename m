Return-Path: <linux-kernel-owner+w=401wt.eu-S933506AbXCaCyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933506AbXCaCyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 22:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933535AbXCaCyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 22:54:43 -0400
Received: from ozlabs.org ([203.10.76.45]:52876 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933506AbXCaCym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 22:54:42 -0400
Subject: Re: [patch 4/6] Convert PDA into the percpu section
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <200703310435.59298.ak@suse.de>
References: <20070331020042.003398870@goop.org>
	 <20070331020055.075978807@goop.org>  <200703310435.59298.ak@suse.de>
Content-Type: text/plain
Date: Sat, 31 Mar 2007 12:54:17 +1000
Message-Id: <1175309657.12230.420.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-31 at 04:35 +0200, Andi Kleen wrote:
> On Saturday 31 March 2007 04:00, Jeremy Fitzhardinge wrote:
> > Currently x86 (similar to x84-64) has a special per-cpu structure
> > called "i386_pda" which can be easily and efficiently referenced via
> > the %fs register.  An ELF section is more flexible than a structure,
> > allowing any piece of code to use this area.  Indeed, such a section
> > already exists: the per-cpu area.
> 
> Hmm, I'm a little reluctant. This moves i386 more away from x86-64
> again. If we ever merge them it would mean more work. Do you really need it?

Well, I think the merge should go the other way in this case: this
really does simplify things.

The only thing stopping x86-64 from doing the same as i386 is the
stack-protector stuff.  And that can be fixed (unfortunately requires a
gcc patch to change the %gs:40 to %gs:__gcc_stack_protector_offset and
emit a weak absolute symbol __gss_stack_protector_offset = 40).

I shall prepare a patch for that next week; I've been busy Kleening up
lguest 8)

Rusty.


