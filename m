Return-Path: <linux-kernel-owner+w=401wt.eu-S1761580AbZDANzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761580AbZDANzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756622AbZDANzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:55:05 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:42412 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765404AbZDANzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:55:03 -0400
Date: Wed, 1 Apr 2009 09:49:25 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Tejun Heo <tj@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH UPDATED] percpu: use dynamic percpu allocator as the
 default percpu allocator
In-Reply-To: <49D2B209.9060000@kernel.org>
Message-ID: <alpine.DEB.1.10.0904010948120.7643@qirst.com>
References: <1236671631-9305-1-git-send-email-tj@kernel.org> <20090316190132.7965a49a@skybase> <49C300D8.5080204@kernel.org> <49C8FAC4.6060508@kernel.org> <20090325122738.42d105b7@skybase> <49CA1AC3.9080908@kernel.org> <20090325150035.541e707a@skybase>
 <49CA3C2C.5030702@kernel.org> <49D099F0.3000807@kernel.org> <20090330114938.GB10070@elte.hu> <alpine.DEB.1.10.0903301049060.13333@qirst.com> <alpine.DEB.1.10.0903311208110.17960@qirst.com> <49D2B209.9060000@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Apr 2009, Tejun Heo wrote:

> > 1. Lot of unnecessary use of __read_mostly for local static variables that
> > are not on the hotpath. Patch follows in this message.
>
> Hmmm... Those are basically read-only vars once initialization is
> complete.  IIUC, __read_mostly just puts the tagged variables into a
> separate segment so that they don't have to worry about cacheline
> bouncing.  Is there any reason to remove __read_mostly?  Or is it just
> that it's mostly superflous?

Yes its better for the variables to be all together if its not on hot
cache paths. And its better to keep the __read_mostly segment reserved for
frequently accessed variables.
