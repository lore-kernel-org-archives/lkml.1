Return-Path: <linux-kernel-owner+w=401wt.eu-S1753539AbZHXVmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbZHXVmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 17:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbZHXVmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 17:42:37 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:43483 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184AbZHXVmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 17:42:37 -0400
Subject: Re: [patch 3/4 -mm] flex_array: poison free elements
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0908241330361.5574@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0908211619270.28611@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0908211620580.28611@chino.kir.corp.google.com>
	 <1251129384.22398.7166.camel@nimitz>
	 <alpine.DEB.2.00.0908241330361.5574@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Mon, 24 Aug 2009 14:42:36 -0700
Message-Id: <1251150156.22398.8289.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-24 at 13:41 -0700, David Rientjes wrote:
> On the other hand, I'd have no problem trying to eliminate 
> fa->total_nr_elements (since we already have fa->element_size) since we 
> can calculate it in real-time; the only problem is being able to 
> distinguish when the elements are being stored in struct flex_array vs. 
> being stored in struct flex_array_part.

Yeah, that's the only reason it's there: to determine if we're using the
compact form or not.  We could probably find another place to store
that, or just store a flag telling whether we're using that form or not.
We couldn't do the bounds-checking, but I'm OK with that.

But, honestly, it doesn't *really* bother me if we just use two 32-bit
int slots in the 'struct flex_array'.  The 64-bit code has an extra 4
bytes now anyway.

> We could then use that
> unsigned int in struct flex_array to store the number of inuse elements 
> which is an alternative implementation to flex_array_shrink(), yet I'd 
> still propose to keep the poisoning to reveal use-uninitialized.

I kinda like the idea of truncating more, just because its simpler and
doesn't have any assumptions about the contents.  But, you are right
that poisoning has some distinct benefits, namely allowing sparsely used
arrays to shrink.

-- Dave

