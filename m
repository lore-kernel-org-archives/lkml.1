Return-Path: <linux-kernel-owner+w=401wt.eu-S1764373AbZFLLLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764373AbZFLLLc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 07:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755675AbZFLLLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 07:11:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:54401 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303AbZFLLLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 07:11:21 -0400
Subject: Re: [PATCH v2] slab,slub: ignore __GFP_WAIT if we're booting or 
 suspending
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, npiggin@suse.de,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       torvalds@linux-foundation.org
In-Reply-To: <84144f020906120311x7c7dd628s82e3ca9a840f9890@mail.gmail.com>
References: <Pine.LNX.4.64.0906121113210.29129@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0906121201490.30049@melkki.cs.Helsinki.FI>
	 <20090612091002.GA32052@elte.hu>
	 <84144f020906120249y20c32d47y5615a32b3c9950df@mail.gmail.com>
	 <20090612100756.GA25185@elte.hu>
	 <84144f020906120311x7c7dd628s82e3ca9a840f9890@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 21:11:00 +1000
Message-Id: <1244805060.7172.126.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> OK, but that means we need to fix up every single caller. I'm fine
> with that but Ben is not. As I am unable to test powerpc here, I am
> inclined to just merge Ben's patch as "obviously correct".
> 
> That does not mean we can't introduce GFP_BOOT later on if we want to. Hmm?

Again, you are missing part of the picture. Yes we -can- fix all the
-direct- callers that are obviously only be run at boot time. But what
about all the indirect ones (or even direct ones) that can be called
either at boot time or later. vmalloc() is the perfect example (or more
precisely __get_vm_area() which brings in ioremap etc...) but there are
many more.

Cheers,
Ben.

