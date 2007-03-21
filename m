Return-Path: <linux-kernel-owner+w=401wt.eu-S933353AbXCUSc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933353AbXCUSc1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 14:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933347AbXCUSc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 14:32:26 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54842 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933353AbXCUSc0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 14:32:26 -0400
To: akpm@linux-foundation.org
Subject: Re: [PATCH] slab: deal with NULL pointers passed to kmem_cache_free
X-IlohaMail-Blah: penberg@cs.helsinki.fi
X-IlohaMail-Method: mail() [mem]
X-IlohaMail-Dummy: moo
X-Mailer: IlohaMail/0.8.12+pk-11 (On: iloha.cs.Helsinki.FI)
In-Reply-To: <20070321083027.437361f1.akpm@linux-foundation.org>
Message-ID: <BL4zLqyD.1174501944.8113450.penberg@cs.helsinki.fi>
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, "Jarek Poplawski" <jarkao2@o2.pl>,
       "Eric Dumazet" <dada1@cosmosbay.com>,
       "mpm@selenic.com" <mpm@selenic.com>,
       "Christoph Lameter" <clameter@sgi.com>, "ast@domdv.de" <ast@domdv.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Date: Wed, 21 Mar 2007 20:32:24 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On 3/21/2007, "Andrew Morton" <akpm@linux-foundation.org> wrote:
> Thing is, such a patch would amount to adding a test-for-NULL to codepaths
> which we *know* do not need it.  There is no point in doing that.

Now you're just being stubborn, Andrew ;-).

The extra check does not matter much at all for most cases. What it buys
us is consistent API with kfree(), more robust slab, and less bugs, no?

All the super-hot paths can be fixed with __kmem_cache_free(). As an
added bonus, we can remove all extra debugging checks when
CONFIG_SLAB_DEBUG is disabled from __kmem_cache_free() as it will be
only used in tested, known good code paths so performance for those
cases will be even better!

So I'll whoop up a patch soonish and send it to you. Perhaps your evil
twin will apply it.
