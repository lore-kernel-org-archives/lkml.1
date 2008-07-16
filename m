Return-Path: <linux-kernel-owner+w=401wt.eu-S1758517AbYGPOeD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517AbYGPOeD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 10:34:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754611AbYGPOdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 10:33:54 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:63688 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587AbYGPOdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 10:33:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NLI/lD70n66k3l5l5gxEnnvfz1VwJcAkzjY23PJ0YJKvPE2pbCa16kRdRZtso2JNMG
         rq+SoPMGuEypW4KCgeNZQ04C9gwd5TnvfJbva/MJJf535TwiHFBDg7KwarSXUMeIQkV8
         bjb4eC4soOpjAMSIPAT7tWpcyckjPB8rsyy5U=
Message-ID: <19f34abd0807160733q2594bd9fk268703d2aedc8254@mail.gmail.com>
Date: Wed, 16 Jul 2008 16:33:53 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Christoph Lameter" <cl@linux-foundation.org>
Subject: Re: [PATCH][RFC] slub: increasing order reduces memory usage of some key caches
Cc: "Richard Kennedy" <richard@rsk.demon.co.uk>, penberg@cs.helsinki.fi,
       mpm@selenic.com, linux-mm <linux-mm@kvack.org>,
       lkml <linux-kernel@vger.kernel.org>, "Mel Gorman" <mel@csn.ul.ie>
In-Reply-To: <487DFFBE.5050407@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216211371.3122.46.camel@castor.localdomain>
	 <487DF5D4.9070101@linux-foundation.org>
	 <1216216730.3122.60.camel@castor.localdomain>
	 <487DFFBE.5050407@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 4:03 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> Richard Kennedy wrote:
>
>> before
>> dentry             82136  82137    208   19    1 : tunables    0    0    0 : slabdata   4323   4323      0
>> after
>> dentry             79482  79482    208   39    2 : tunables    0    0    0 : slabdata   2038   2038      0
>
> 19 objects with an order 1 alloc and 208 byte size? Urgh. 8192/208 = 39 and not 19.
>
> Kmemcheck or something else active? We seem to be loosing 50% of our memory.

Hm, I don't think so? I thought that those 1 and 2 were not orders,
but in fact the number of pages. Which seems correct, since now you
have 4096 / 208 = 19 :-)

(His patch bumps order from 0 to 1, so the number of pages were bumped
from 1 to 2.)

Or..?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
