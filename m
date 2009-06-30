Return-Path: <linux-kernel-owner+w=401wt.eu-S1754950AbZF3OVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbZF3OVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 10:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbZF3OVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 10:21:30 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:39587 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751735AbZF3OV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 10:21:29 -0400
Date: Tue, 30 Jun 2009 10:20:24 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: paulmck@linux.vnet.ibm.com, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, jdb@comx.dk
Subject: Re: [PATCH RFC] fix RCU-callback-after-kmem_cache_destroy problem
 in  sl[aou]b
In-Reply-To: <84144f020906292358j6517b599n471eed4e88781a78@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0906301014060.6124@gentwo.org>
References: <20090625193137.GA16861@linux.vnet.ibm.com>  <alpine.DEB.1.10.0906291827050.21956@gentwo.org>  <1246315553.21295.100.camel@calx>  <alpine.DEB.1.10.0906291910130.32637@gentwo.org>  <1246320394.21295.105.camel@calx>  <20090630060031.GL7070@linux.vnet.ibm.com>
 <84144f020906292358j6517b599n471eed4e88781a78@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009, Pekka Enberg wrote:

> I don't even claim to understand all the RCU details here but I don't
> see why we should care about _kmem_cache_destroy()_ performance at
> this level. Christoph, hmmm?

Well it was surprising to me that kmem_cache_destroy() would perform rcu
actions in the first place. RCU is usually handled externally and not
within the slab allocator. The only reason that SLAB_DESTROY_BY_RCU exists
is because the user cannot otherwise control the final release of memory
to the page allocator.


