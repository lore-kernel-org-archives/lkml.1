Return-Path: <linux-kernel-owner+w=401wt.eu-S1760357AbZFYKr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760357AbZFYKr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 06:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760273AbZFYKrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 06:47:15 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:57467 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760268AbZFYKrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 06:47:13 -0400
Message-ID: <4A435593.1050806@cosmosbay.com>
Date: Thu, 25 Jun 2009 12:46:43 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, fbl@redhat.com,
       nhorman@redhat.com, davem@redhat.com, oleg@redhat.com
Subject: Re: [RFC] tcp: race in receive part
References: <20090618102727.GC3782@jolsa.lab.eng.brq.redhat.com> <4A3A49F2.6060705@gmail.com> <20090623091257.GA4850@jolsa.lab.eng.brq.redhat.com> <4A40AF2A.3050509@gmail.com> <20090624102038.GA5409@jolsa.lab.eng.brq.redhat.com> <4A42082D.9060402@gmail.com> <20090624162112.GB5409@jolsa.lab.eng.brq.redhat.com> <4A435162.90109@gmail.com>
In-Reply-To: <4A435162.90109@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 25 Jun 2009 12:46:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet a écrit :
> Jiri Olsa a écrit :
>> I made the modification, plz check the attached diff.
>>
>> I found some places where the read_lock is not ahead of the check:
>>   "if (sk->sk_sleep && waitqueue_active(sk->sk_sleep))"
>>
>> I'm not sure we dont want to address those as well; located in following
>> files:
>>         drivers/net/tun.c
>>         net/core/stream.c
>>         net/sctp/socket.c
>>         net/sunrpc/svcsock.c
> 
> We'll take care of them later :)
> 
>>
>> thanks,
>> jirka
>>
> 
> This patch is OK with me, please submit a new formal patch with
> fresh ChangeLog so that we can all agree and Signed-off-by/Acked-by
> 
> Oleg, I think your comment can be addressed in a followup patch ?
> 
> Thanks to all

To clarify, I meant the second comment from Oleg.

Jiri, please define a "smp_mb__after_lock()" instead of smp_mb__after_read_lock()

+/* The {read|write|spin}_lock() on x86 are full memory barriers. */
+#define smp_mb__after_lock() do { } while (0)
+
