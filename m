Return-Path: <linux-kernel-owner+w=401wt.eu-S1755263AbYH0KzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbYH0KzP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 06:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbYH0KzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 06:55:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:38953 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbYH0KzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 06:55:03 -0400
Date: Wed, 27 Aug 2008 03:55:01 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: PATCH] debug: add notifier chain debugging
Message-ID: <20080827035501.4b8cc732@infradead.org>
In-Reply-To: <20080827063915.GC6255@elte.hu>
References: <20080815152938.4bc9d48c@infradead.org>
	<12c511ca0808251539w6f00a216s86a09a532c553a34@mail.gmail.com>
	<20080825215555.2331f2cc@infradead.org>
	<12c511ca0808252208n29043ab0lf9e56f94d5e4cb37@mail.gmail.com>
	<20080826092220.66290440@infradead.org>
	<20080827063915.GC6255@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2008 08:39:15 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > The patch below fixes this;
> > Ingo, please replace the patch with this one.
> 
> well, this one is now less than cheap on x86:

really it isn't; dereference_function_descriptor is a fall through and
basically free.

> 
> as it's rather large. So i kept the config option, and it defaults to 
> off.

huh? the consensus was that the config needed to go ... nothing changed
on that front. I agree absolutely with not introducing config options
for things that don't need it; we have too many already anyway.


> 
> > +		if (!func_ptr_is_kernel_text(nb->notifier_call)) {
> > +			WARN(1, "Invalid notifier called!");
> > +			nb = next_nb;
> > +			continue;
> > +		}
> 
> and that should be an unlikely() too i guess.

please do not add new unlikely()'s to the kernel.. not on non-hotpaths
at least

