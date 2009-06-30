Return-Path: <linux-kernel-owner+w=401wt.eu-S1756968AbZF3O0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968AbZF3O0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 10:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbZF3O0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 10:26:37 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:60046 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbZF3O0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 10:26:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=TyTA/x5/ZmTkyKpMUL/4F1e8UZ0lNlMsyqVUjv+IDi1X+IyKFNnKvL2TTn7SNBeCv1
         D21eMLsxgacVPNsTWGav5ddoHt+7/Bmsz0FSsHE1jaZdbS69SSJ/IF45nOwrOAM5DNr+
         bmg2IIRA32q+JvFmlVdnwD5yrGHZkVSRBhO+g=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0906301014060.6124@gentwo.org>
References: <20090625193137.GA16861@linux.vnet.ibm.com>
	 <alpine.DEB.1.10.0906291827050.21956@gentwo.org>
	 <1246315553.21295.100.camel@calx>
	 <alpine.DEB.1.10.0906291910130.32637@gentwo.org>
	 <1246320394.21295.105.camel@calx>
	 <20090630060031.GL7070@linux.vnet.ibm.com>
	 <84144f020906292358j6517b599n471eed4e88781a78@mail.gmail.com>
	 <alpine.DEB.1.10.0906301014060.6124@gentwo.org>
Date: Tue, 30 Jun 2009 17:26:39 +0300
X-Google-Sender-Auth: 1666c88fb488528b
Message-ID: <84144f020906300726n4978d59ale5c8a3c076a1501a@mail.gmail.com>
Subject: Re: [PATCH RFC] fix RCU-callback-after-kmem_cache_destroy problem in 
	sl[aou]b
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: paulmck@linux.vnet.ibm.com, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, jdb@comx.dk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Tue, 30 Jun 2009, Pekka Enberg wrote:
>> I don't even claim to understand all the RCU details here but I don't
>> see why we should care about _kmem_cache_destroy()_ performance at
>> this level. Christoph, hmmm?

On Tue, Jun 30, 2009 at 5:20 PM, Christoph
Lameter<cl@linux-foundation.org> wrote:
> Well it was surprising to me that kmem_cache_destroy() would perform rcu
> actions in the first place. RCU is usually handled externally and not
> within the slab allocator. The only reason that SLAB_DESTROY_BY_RCU exists
> is because the user cannot otherwise control the final release of memory
> to the page allocator.

Right. A quick grep for git logs reveals that it's been like that in
mm/slab.c at least since 2.6.12-rc2 so I think we should consider it
as part of the slab API and Paul's patch is an obvious bugfix to it.

                                           Pekka
