Return-Path: <linux-kernel-owner+w=401wt.eu-S1756614AbZJLNOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbZJLNOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 09:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756563AbZJLNOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 09:14:39 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:40910 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756372AbZJLNOi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 09:14:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=wg/MiPrX8Jv0lKLJnE756eqQwHtyzbT3WiDe2IcUEu0QEAr18809ud9vAVmjMqgzCr
         /T8NqgmegcfSPI/om8fAOGNSG0YHviGVpaF7UT4ltV02fPETNKlfg0KVB1PHPYIigX6W
         k0sfZHgmNCCu4834Y41edHRRgIBBweqBlej3Y=
MIME-Version: 1.0
In-Reply-To: <4AD307A5.105@kernel.org>
References: <20091007211024.442168959@gentwo.org>
	 <20091007211053.378634196@gentwo.org> <4AD307A5.105@kernel.org>
Date: Mon, 12 Oct 2009 16:14:01 +0300
X-Google-Sender-Auth: 52543c1348ecb49e
Message-ID: <84144f020910120614r529d8e4em9babe83a90e9371f@mail.gmail.com>
Subject: Re: [this_cpu_xx V6 7/7] this_cpu: slub aggressive use of this_cpu 
	operations in the hotpaths
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Tejun Heo <tj@kernel.org>
Cc: cl@linux-foundation.org, linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Mel Gorman <mel@csn.ul.ie>, David Rientjes <rientjes@google.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 1:40 PM, Tejun Heo <tj@kernel.org> wrote:
> cl@linux-foundation.org wrote:
>> Use this_cpu_* operations in the hotpath to avoid calculations of
>> kmem_cache_cpu pointer addresses.
>>
>> On x86 there is a trade off: Multiple uses segment prefixes against an
>> address calculation and more register pressure. Code size is reduced
>> also therefore it is an advantage icache wise.
>>
>> The use of prefixes is necessary if we want to use a scheme
>> for fastpaths that do not require disabling interrupts.
>>
>> Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
>> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
>> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
>
> The rest of the patches look good to me but I'm no expert in this area
> of code.  But you're the maintainer of the allocator and the changes
> definitely are percpu related, so if you're comfortable with it, I can
> happily carry the patches through percpu tree.

The patch looks sane to me but the changelog contains no relevant
numbers on performance. I am fine with the patch going in -percpu but
the patch probably needs some more beating performance-wise before it
can go into .33. I'm CC'ing some more people who are known to do SLAB
performance testing just in case they're interested in looking at the
patch. In any case,

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

                        Pekka
