Return-Path: <linux-kernel-owner+w=401wt.eu-S932815AbZKXL2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815AbZKXL2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 06:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754787AbZKXL2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 06:28:48 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:64252 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205AbZKXL2s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 06:28:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=tik9eGoDE+HXm2s18NxvAbuRmw7ZUDjSUUXvHW0HLqlPUyiihNt5SZ8NNrLXsxYjt6
         4w2K76vOmG1LzvB7dUx+Ct+ZLSk5g4+W6WoXf9v5l+kp2+oeVzppSpzC2+fSuCc16PfM
         vhGpVxtTC4m7iFB+hIaf0sqdLX2SX+PJSta74=
MIME-Version: 1.0
In-Reply-To: <20091124112058.GA23765@elte.hu>
References: <cover.1259059549.git.tim@klingt.org> <4B0BBBA8.2090604@klingt.org>
	 <20091124112058.GA23765@elte.hu>
Date: Tue, 24 Nov 2009 13:28:53 +0200
X-Google-Sender-Auth: 1a04b2f37ae1b479
Message-ID: <84144f020911240328l3d36d347o6c91b2b1a0f50f2a@mail.gmail.com>
Subject: Re: [PATCH 3/5] slab.c: remove branch hint
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tim Blechmann <tim@klingt.org>, linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 1:20 PM, Ingo Molnar <mingo@elte.hu> wrote:
> (Pekka Cc:-ed)
>
> * Tim Blechmann <tim@klingt.org> wrote:
>
>> branch profiling on my nehalem machine showed 99% incorrect branch hints:
>>
>>    28459  7678524  99 __cache_alloc_node             slab.c
>>   3551
>>
>> Signed-off-by: Tim Blechmann <tim@klingt.org>
>> ---
>>  mm/slab.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/mm/slab.c b/mm/slab.c
>> index f70b326..4125fcd 100644
>> --- a/mm/slab.c
>> +++ b/mm/slab.c
>> @@ -3548,7 +3548,7 @@ __cache_alloc_node(struct kmem_cache *cachep,
>> gfp_t flags, int nodeid,
>>       slab_irq_save(save_flags, this_cpu);
>>       this_node = cpu_to_node(this_cpu);
>> -     if (unlikely(nodeid == -1))
>> +     if (nodeid == -1)
>>               nodeid = this_node;
>>       if (unlikely(!cachep->nodelists[nodeid])) {

That sounds odd to me. Can you see where the incorrectly predicted
calls are coming from? Calling kmem_cache_alloc_node() with node set
to -1 most of the time could be a real bug somewhere.
