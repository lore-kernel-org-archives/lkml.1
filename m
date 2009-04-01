Return-Path: <linux-kernel-owner+w=401wt.eu-S933718AbZDASsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933718AbZDASsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 14:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933324AbZDASsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 14:48:03 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:33364 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933682AbZDASsA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 14:48:00 -0400
Message-ID: <49D3B6CD.2030908@cosmosbay.com>
Date: Wed, 01 Apr 2009 20:47:41 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, Tejun Heo <htejun@gmail.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Joe Perches <joe@perches.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] x86: percpu_to_op() misses memory and flags clobbers
References: <49D32212.80607@cosmosbay.com> <49D32DC2.9010003@goop.org> <49D33E80.70802@cosmosbay.com> <20090401161218.GB3859@elte.hu> <49D3A0C2.9000403@cosmosbay.com> <49D3AD61.5090206@goop.org>
In-Reply-To: <49D3AD61.5090206@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 01 Apr 2009 20:47:42 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge a écrit :
> Eric Dumazet wrote:
>> +#define percpu_inc(var)        percpu_to_op0("inc", per_cpu__##var)
>> +#define percpu_dec(var)        percpu_to_op0("dec", per_cpu__##var)
>>   
> 
> There's probably not a lot of value in this.  The Intel and AMD
> optimisation guides tend to deprecate inc/dec in favour of using
> add/sub, because the former can cause pipeline stalls due to its partial
> flags update.
> 
>    J

Sure, but this saves one byte per call, this is probably why we still use
inc/dec in so many places...

