Return-Path: <linux-kernel-owner+w=401wt.eu-S1756720AbZFRBJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720AbZFRBJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 21:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbZFRBJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 21:09:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:59322 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558AbZFRBJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 21:09:27 -0400
Message-ID: <4A3993A2.9070109@kernel.org>
Date: Thu, 18 Jun 2009 10:08:50 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Eric Dumazet <dada1@cosmosbay.com>, davem@davemloft.net
Subject: Re: [this_cpu_xx 01/11] Introduce this_cpu_ptr() and generic this_cpu_*
 operations
References: <20090605191819.376530498@gentwo.org> <20090605191850.441840884@gentwo.org> <4A38A719.2030709@kernel.org> <alpine.DEB.1.10.0906171343370.30060@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0906171343370.30060@gentwo.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 18 Jun 2009 01:08:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Christoph Lameter wrote:
> On Wed, 17 Jun 2009, Tejun Heo wrote:
>> Please note that this can also happen between addition or other
>> modifying ops and cause incorrect result.
> 
> Per cpu operations are only safe for the current processor. One issue
> there may be that the store after rescheduling may not occur to the
> current processors per cpu instance but the prior cpu. At that point
> another thread may be running on the prior cpu and be disturbed like you
> point out. So it needs a preempt disable there too.

Yeap, to summarize, the problem is that the address determination and
the actual memory write aren't atomic with respect to preeamption.

>> Also, these macros depricate percpu_OP() macros, right?
> 
> They are different. percpu_OP() macros require a percpu variable name
> to be passed.
> 
> this_cpu_* macros require a reference to a variable in a
> structure allocated with the new per cpu allocator.
> 
> It is possible to simply pass the full variable name of a percpu variable
> to this_cpu_* macros. See the patch of the vm statistics handling.
> 
> It uses
> 
> 	per_cpu_var(per_cpu_name_without_prefix)
> 
> to generate the full name.

Yeap, I guess it's about time to ressurect Rusty's drop-per_cpu_
prefix patch; then, we can truly handle static and dynamic variables
in the same manner.

Thanks.

-- 
tejun
