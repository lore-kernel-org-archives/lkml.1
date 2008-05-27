Return-Path: <linux-kernel-owner+w=401wt.eu-S1755585AbYE0EiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbYE0EiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 00:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbYE0Eh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 00:37:59 -0400
Received: from ozlabs.org ([203.10.76.45]:50546 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbYE0Eh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 00:37:58 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] net: wireless: airo semaphore to mutex
Date: Tue, 27 May 2008 14:37:22 +1000
User-Agent: KMail/1.9.9
Cc: Michal Schmidt <mschmidt@redhat.com>, Daniel Walker <dwalker@mvista.com>,
       linville@tuxdriver.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, arjan@infradead.org
References: <20080522232103.120033152@mvista.com> <200805271117.23051.rusty@rustcorp.com.au> <20080527021503.GH30894@parisc-linux.org>
In-Reply-To: <20080527021503.GH30894@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805271437.23114.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 May 2008 12:15:03 Matthew Wilcox wrote:
> On Tue, May 27, 2008 at 11:17:22AM +1000, Rusty Russell wrote:
> > On Tuesday 27 May 2008 03:29:14 Michal Schmidt wrote:
> > > Mutexes are not allowed in interrupt context, not even mutex_trylock.
> >
> > As an aside, does anyone know why?  I know the documentation says so, but
> > it wasn't immediately obvious to me.  I asked before to no response...
>
> Because mutexes have an owner.  In interrupt context, there is no owner.
> This owner is used to do priority boosts as well as debugging.

Shows how little I know, I didn't see priority boosting in my glance thru 
mutex.c.

But it seems like mutex_trylock_irq would be easy to add if needed, if only 
for clarity.

Thanks!
Rusty.
