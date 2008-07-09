Return-Path: <linux-kernel-owner+w=401wt.eu-S1757922AbYGIPu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922AbYGIPu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 11:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbYGIPuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 11:50:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:42515 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282AbYGIPuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 11:50:21 -0400
Date: Wed, 9 Jul 2008 08:50:18 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Bruno Santos <bsantos@av.it.pt>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>
Subject: Re: semaphore: lockless fastpath using atomic_{inc,dec}_return
Message-ID: <20080709085018.3a76d1e0@infradead.org>
In-Reply-To: <4874DBBF.1000907@av.it.pt>
References: <4874DBBF.1000907@av.it.pt>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jul 2008 16:39:43 +0100
Bruno Santos <bsantos@av.it.pt> wrote:

> Hi,
> 
>  >hi,
>  >
>  >not to ruin the party but... how is this lockless? An atomic
>  >variable is every bit a "lock" as a spinlock is... and very much
>  >equally expensive as well for most cases ;-(
> 
> Perhaps not the best the choice of words, I should have omitted the
> word lockless. But it seems my understanding of lockless and yours is
> different. And indeed, it's very expensive as a spinlock, but
> comparatively, is only one operation, that if successful doesn't have
> to lock and then unlock (that's why I called it lockless ...).

ok I only come from an Intel/x86 background, where unlock is basically
free, and the "lock" is exactly the same cost as an atomic op.
(in fact, an atomic op and a lock are the exact same code.. you're just
open coding it)

> The mutex takes the same approach, however it uses it's own flavour
> of atomic ops. What I'm really interested is if this brings any
> benefit in terms of performance.

on x86... I would highly doubt it since you have the same number of
atomic operations. (it's not the lock that is expensive. ever. it's
always the fact that a lock implies an atomic operation that makes it
expensive)
