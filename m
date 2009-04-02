Return-Path: <linux-kernel-owner+w=401wt.eu-S1761577AbZDBTJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761577AbZDBTJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 15:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329AbZDBTJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 15:09:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55881 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089AbZDBTJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 15:09:48 -0400
Message-ID: <49D50CB7.2050705@redhat.com>
Date: Thu, 02 Apr 2009 15:06:31 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Rusty Russell <rusty@rustcorp.com.au>,
       virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       akpm@osdl.org, frankeh@watson.ibm.com, hugh@veritas.com
Subject: Re: [patch 0/6] Guest page hinting version 7.
References: <20090327150905.819861420@de.ibm.com>	<200903281705.29798.rusty@rustcorp.com.au>	<20090329162336.7c0700e9@skybase>	<200904022232.02185.nickpiggin@yahoo.com.au> <20090402175249.3c4a6d59@skybase>
In-Reply-To: <20090402175249.3c4a6d59@skybase>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Schwidefsky wrote:
> The benefits are the same but the algorithmic complexity is reduced.
> The patch to the memory management has complexity in itself but from a
> 1000 feet standpoint guest page hinting is simpler, no? 
Page hinting has a complex, but well understood, mechanism
and simple policy.

Ballooning has a simpler mechanism, but relies on an
as-of-yet undiscovered policy.

Having experienced a zillion VM corner cases over the
last decade and a bit, I think I prefer a complex mechanism
over complex (or worse, unknown!) policy any day.
> Ok, I can understand that. We probably need a KVM based version to show
> that benefits exist on non-s390 hardware as well.
I believe it can work for KVM just fine, if we keep the host state
and the guest state in separate places (so the guest can always
write the guest state without a hypercall).
