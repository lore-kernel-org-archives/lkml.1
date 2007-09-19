Return-Path: <linux-kernel-owner+w=401wt.eu-S1758909AbXISLI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909AbXISLI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 07:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756963AbXISLIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 07:08:50 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:60070 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754963AbXISLIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 07:08:49 -0400
Date: Wed, 19 Sep 2007 07:08:46 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 4/7] Immediate Values - i386 Optimization
Message-ID: <20070919110846.GC15500@Krystal>
References: <20070918210747.828804366@polymtl.ca> <20070918210853.588573678@polymtl.ca> <46F04856.3010808@goop.org> <p73myvjwri3.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <p73myvjwri3.fsf@bingen.suse.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 07:02:23 up 51 days, 11:21,  4 users,  load average: 1.65, 1.90, 1.30
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> Jeremy Fitzhardinge <jeremy@goop.org> writes:
> > 
> > It's a pity that gas seems to generate plain 0x90 nops rather than
> > long-nop forms here.  I thought it could do that.
> 
> .p2align does it.
> 

Sadly, p2align does not apply well to my context. I have to align on 4
bytes boundaries - 1 for the 4 bytes mov, so, if I would use p2align, I
would end up aligning on 4 bytes with p2align and then add 3 bytes
(worse case: adding 3 + 3 = 6 bytes of nops).

However, with the .org arithmetic, I can simply add then quantity of
nops needed to make my alignment on 4 bytes - 1, so the worse case
becomes adding 3 bytes.

The example is:

originally: address & 3 = 1
* p2align
p2align adds 3 bytes to align on 4 bytes boundaries
we add 3 bytes to align on the next 4 bytes - 1, so the immediate value
within the instruction is aligned on 4 bytes boundaries

* org
we add 2 bytes to be aligned on the next 4 bytes - 1.

And yes, it's a pity there is no way to produce the long-nops there. :(

Mathieu

> -Andi

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
