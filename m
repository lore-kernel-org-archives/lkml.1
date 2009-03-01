Return-Path: <linux-kernel-owner+w=401wt.eu-S1756528AbZCABot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbZCABot (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 20:44:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755178AbZCABol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 20:44:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34484 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbZCABok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 20:44:40 -0500
Message-ID: <49A9E7A3.4050102@zytor.com>
Date: Sat, 28 Feb 2009 17:40:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       torvalds@linux-foundation.org, mingo@elte.hu, nickpiggin@yahoo.com.au,
       sqazi@google.com, linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [patch] x86, mm: pass in 'total' to __copy_from_user_*nocache()
References: <alpine.LFD.2.00.0902280904271.3111@localhost.localdomain>	<20090228092450.3ded2db5@infradead.org>	<alpine.LFD.2.00.0902280935010.3111@localhost.localdomain>	<20090228.160651.228301019.davem@davemloft.net>	<20090301004003.GF26292@one.firstfloor.org>	<49A9D6CA.30906@zytor.com>	<20090228163811.48b1de72@infradead.org>	<20090301014822.GG26292@one.firstfloor.org> <20090228173813.6d86c0ef@infradead.org>
In-Reply-To: <20090228173813.6d86c0ef@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> 
> the reason that movntq and co are faster is because you avoid the
> write-allocate behavior of the caches....
> 
> the cache polluting part of it I find hard to buy for general use (as
> this discussion shows)... that will be extremely hard to measure as
> a real huge thing, while the WA part is like a 1.5x to 2x thing.
> 

Note that hardware *can* (which is not the same thing as hardware
*will*) elide the write-allocate behavior.  We did that at Transmeta for
rep movs and certain other instructions which provably filled in entire
cache lines.  I haven't investigated if newer Intel CPUs do that in the
"fast rep movs" case.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

