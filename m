Return-Path: <linux-kernel-owner+w=401wt.eu-S1756719AbYKTUHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719AbYKTUHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 15:07:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbYKTUHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 15:07:32 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39416 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbYKTUHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 15:07:32 -0500
Message-ID: <4925C299.6070907@cs.helsinki.fi>
Date: Thu, 20 Nov 2008 22:03:37 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.18 (Macintosh/20081105)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mm: slab - __cache_alloc NULL prefetch fix
References: <20081120164400.GC7363@localhost> <28180.1227211108@turing-police.cc.vt.edu>
In-Reply-To: <28180.1227211108@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Thu, 20 Nov 2008 19:44:00 +0300, Cyrill Gorcunov said:
> 
>> -	prefetchw(objp);
>>  
>> -	if (likely(objp))
>> +	if (likely(objp)) {
>> +		prefetchw(objp);
>>  		kmemcheck_slab_alloc(cachep, flags, objp, obj_size(cachep));
>> +	}
> 
> Although it probably makes sense to not bother prefetching NULL, I also
> need to wonder how useful it is to prefetch something that we then
> turn around and dereference in the very next line of code.

Note that kmemcheck_slab_alloc() is going to be a no-op on anything but 
a special developer or tester debug config.
