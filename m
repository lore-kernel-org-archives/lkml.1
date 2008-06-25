Return-Path: <linux-kernel-owner+w=401wt.eu-S1756626AbYFYWcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbYFYWcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 18:32:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753739AbYFYWb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 18:31:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:48145 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbYFYWb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 18:31:56 -0400
Date: Wed, 25 Jun 2008 15:31:36 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: Re: [PATCH 03 of 36] x86: add memory barriers to wrmsr
Message-ID: <20080625153136.2b3b6737@infradead.org>
In-Reply-To: <4862B3E9.50601@goop.org>
References: <patchbomb.1214367536@localhost>
	<93c7057b1f4acae501b2.1214367539@localhost>
	<20080624214441.13202f12@infradead.org>
	<4862B3E9.50601@goop.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2008 14:08:57 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Arjan van de Ven wrote:
> > it's more readable for several of these cases to stick a barrier();
> > in front and after it to be honest; that makes it more explicit that
> > these are deliberate compiler barriers rather than "actual" memory
> > access...
> >
> >   
> 
> I suppose, though I would be inclined to put the barriers in the
> wrmsr macro itself to act as documentation. 


yeah I meant like this:

static inline void native_write_msr(unsigned int msr,
 				    unsigned low, unsigned high)
{
	barrier();
	asm volatile("wrmsr" : : "c" (msr), "a"(low), "d" (high));
	barrier();
}

or in the same in the thing that calls this.

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
