Return-Path: <linux-kernel-owner+w=401wt.eu-S1754953AbZGARdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953AbZGARdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 13:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbZGARde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 13:33:34 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:59336 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754032AbZGARdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 13:33:33 -0400
Date: Wed, 1 Jul 2009 13:33:03 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Andi Kleen <andi@firstfloor.org>
cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       x86@kernel.org, linux-arch@vger.kernel.org, hpa@zytor.com,
       tglx@linutronix.de
Subject: Re: [PATCHSET] percpu: generalize first chunk allocators and improve
 lpage NUMA support
In-Reply-To: <20090701131146.GR6760@one.firstfloor.org>
Message-ID: <alpine.DEB.1.10.0907011330450.9522@gentwo.org>
References: <20090629163937.94c8cedd.akpm@linux-foundation.org> <20090630191517.GB20567@elte.hu> <alpine.DEB.1.10.0906301533400.29795@gentwo.org> <20090630213146.GA17492@elte.hu> <alpine.DEB.1.10.0906301809330.11362@gentwo.org> <4A4A9DC6.6020003@kernel.org>
 <20090701064250.GM6760@one.firstfloor.org> <4A4B38C5.1070504@kernel.org> <20090701122312.GP6760@one.firstfloor.org> <4A4B5C32.1010009@kernel.org> <20090701131146.GR6760@one.firstfloor.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jul 2009, Andi Kleen wrote:

> And it's imho unclear if that is all worth it just to avoid
> wasting some memory in the "256 possible CPUs" case (which
> I doubt is particularly realistic anyways, at least I don't
> know of any Hypervisor today that scales to 256 CPUs)

I basically agree. Its not worth it given the rare cases where this
matters. It will be a lot of code with callbacks in each subsystem.

One of the motivations of working on revising the percpu handling for
me was that we could get rid of these screwy callbacks that are rarely
tested and cause all sorts of other issues with locking and serialization.
