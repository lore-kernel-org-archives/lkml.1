Return-Path: <linux-kernel-owner+w=401wt.eu-S933318AbZDASII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318AbZDASII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 14:08:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933297AbZDASHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 14:07:39 -0400
Received: from gw.goop.org ([64.81.55.164]:37276 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933293AbZDASHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 14:07:38 -0400
Message-ID: <49D3AD61.5090206@goop.org>
Date: Wed, 01 Apr 2009 11:07:29 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Ingo Molnar <mingo@elte.hu>, Tejun Heo <htejun@gmail.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Joe Perches <joe@perches.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] x86: percpu_to_op() misses memory and flags clobbers
References: <49D32212.80607@cosmosbay.com> <49D32DC2.9010003@goop.org> <49D33E80.70802@cosmosbay.com> <20090401161218.GB3859@elte.hu> <49D3A0C2.9000403@cosmosbay.com>
In-Reply-To: <49D3A0C2.9000403@cosmosbay.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> +#define percpu_inc(var)		percpu_to_op0("inc", per_cpu__##var)
> +#define percpu_dec(var)		percpu_to_op0("dec", per_cpu__##var)
>   

There's probably not a lot of value in this.  The Intel and AMD 
optimisation guides tend to deprecate inc/dec in favour of using 
add/sub, because the former can cause pipeline stalls due to its partial 
flags update.

    J
