Return-Path: <linux-kernel-owner+w=401wt.eu-S1751755AbXCSTIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755AbXCSTIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 15:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbXCSTIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 15:08:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57183
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751755AbXCSTIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 15:08:54 -0400
Date: Mon, 19 Mar 2007 12:08:54 -0700 (PDT)
Message-Id: <20070319.120854.30182994.davem@davemloft.net>
To: ak@suse.de
Cc: virtualization@lists.linux-foundation.org, jbeulich@novell.com,
       jeremy@goop.org, ak@muc.de, xen-devel@lists.xensource.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       chrisw@sous-sol.org, virtualization@lists.osdl.org,
       anthony@codemonkey.ws, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, mingo@elte.hu
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops
 callsites to make them patchable
From: David Miller <davem@davemloft.net>
In-Reply-To: <200703191157.29780.ak@suse.de>
References: <20070318193030.GB71548@muc.de>
	<45FDCF52.4000805@goop.org>
	<200703191157.29780.ak@suse.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@suse.de>
Date: Mon, 19 Mar 2007 11:57:28 +0100

> On Monday 19 March 2007 00:46, Jeremy Fitzhardinge wrote:
> > Andi Kleen wrote:
> > For example, say we wanted to put a general call for sti into entry.S,
> > where its expected it won't touch any registers.  In that case, we'd
> > have a sequence like:
> >
> >     push %eax
> >     push %ecx
> >     push %edx
> >     call paravirt_cli
> >     pop %edx
> >     pop %ecx
> >     pop %eax
> 
> This cannot right now be expressed as inline assembly in the unwinder at all 
> because there is no way to inject the push/pops into the compiler generated
> ehframe tables.
> 
> [BTW I plan to resubmit the unwinder with some changes]

It's inability to handle sequences like the above sounds to me like
a very good argument to _not_ merge the unwinder back into the tree.

To me, that unwinder is nothing but trouble, it severly limits what
cases you can use special calling conventions via inline asm (and we
have done that on several occaisions) and even ignoring that the
unwinder only works half the time.

Please don't subject us to another couple months of hair-pulling only
to have Linus yank the thing out again, there are certainly more
useful things to spend time on :-)
