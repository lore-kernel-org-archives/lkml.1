Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbXGILEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbXGILEd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 07:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbXGILEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 07:04:25 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:7532 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbXGILEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 07:04:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=O134tDaThWjG0CQwI4V0hKVPAwbvU6HNDk4X/JI7U2I+V/KCd9t29sSzd2DlMDg62DP4IGyhFoZemtTTZfShDstoNXLuson6RE9BZJg9DNklOoFui2IyO8Rerlpo7DDu6lSTGJNunqQ7FiXQX26HLYuTxhQJrMHC+NNeOizFMXg=
Message-ID: <84144f020707090404l657a62c7x89d7d06b3dd6c34b@mail.gmail.com>
Date: Mon, 9 Jul 2007 14:04:24 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Christoph Lameter" <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org, suresh.b.siddha@intel.com,
       corey.d.gough@intel.com, "Matt Mackall" <mpm@selenic.com>,
       "Denis Vlasenko" <vda.linux@googlemail.com>,
       "Erik Andersen" <andersen@codepoet.org>
In-Reply-To: <4691A415.6040208@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070708034952.022985379@sgi.com>
	 <20070708035018.074510057@sgi.com> <20070708075119.GA16631@elte.hu>
	 <20070708110224.9cd9df5b.akpm@linux-foundation.org>
	 <4691A415.6040208@yahoo.com.au>
X-Google-Sender-Auth: 7665a7e0297aa06a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On 7/9/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> SLOB contains several significant O(1) and also O(n) memory savings that
> are so far impossible-by-design for SLUB. They are: slab external
> fragmentation is significantly reduced; kmalloc internal fragmentation is
> significantly reduced; order of magnitude smaller kmem_cache data type;
> order of magnitude less code...

I assume with "slab external fragmentation" you mean allocating a
whole page for a slab when there are not enough objects to fill the
whole thing thus wasting memory? We could try to combat that by
packing multiple variable-sized slabs within a single page. Also,
adding some non-power-of-two kmalloc caches might help with internal
fragmentation.

In any case, SLUB needs some serious tuning for smaller machines
before we can get rid of SLOB.
