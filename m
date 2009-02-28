Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbZB1SH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbZB1SH3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 13:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbZB1SHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 13:07:16 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59204 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbZB1SHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 13:07:15 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Salman Qazi <sqazi@google.com>,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] x86, mm: pass in 'total' to __copy_from_user_*nocache()
From: Andi Kleen <andi@firstfloor.org>
References: <20090224020304.GA4496@google.com>
	<200902272305.01867.nickpiggin@yahoo.com.au>
	<20090228082922.GB11425@elte.hu>
	<200902282249.57479.nickpiggin@yahoo.com.au>
	<20090228125816.GA14917@elte.hu>
	<alpine.LFD.2.00.0902280904271.3111@localhost.localdomain>
	<20090228092450.3ded2db5@infradead.org>
	<alpine.LFD.2.00.0902280935010.3111@localhost.localdomain>
Date: Sat, 28 Feb 2009 19:05:22 +0100
In-Reply-To: <alpine.LFD.2.00.0902280935010.3111@localhost.localdomain> (Linus Torvalds's message of "Sat, 28 Feb 2009 09:42:18 -0800 (PST)")
Message-ID: <8763iu309p.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> That's almost unacceptable in the long run. With a 8MB L3 cache - and a 
> compile sequence, do we really want to go out to memory to write the .S 
> file, and then have the assembler go out to memory to read it back? For 

One possible way would be to make the threshold dependent on the LLC
cache size, so that let's say an Atom still prefers to not pollute
its caches.  But I agree with you that it's probably better to 
just drop the nocache copies completely.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
