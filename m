Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab0BNIeq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 03:34:46 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:30546 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110Ab0BNIep convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 03:34:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lLDqb2eN5GszfhUCZqw3UqsiWWNXYSGhqr2UUJu7uMKi/hWevVpp4puRwePXWkS0t8
         mZsxXOMnmCo3L1ex88CJSc6jFXlUSZ072Dg/iNMzy8EQBNGzaz+KZNf900Cci3qFbj9x
         P3O50d8mqLZB4+r+9qt/X4AtDx/yMHhuaBTvQ=
MIME-Version: 1.0
In-Reply-To: <1265948152.2891.25.camel@edumazet-laptop>
References: <20100212000016.GA25781@linux.vnet.ibm.com>
	 <1265932839-25899-5-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1265948152.2891.25.camel@edumazet-laptop>
Date: Sun, 14 Feb 2010 09:34:43 +0100
Message-ID: <e2d7436a1002140034h74617164p1a5dc90df3587095@mail.gmail.com>
Subject: Re: [PATCH tip/core/rcu 05/13] net: add checking to rcu_dereference() 
	primitives
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/2/12 Eric Dumazet <eric.dumazet@gmail.com>:
> Le jeudi 11 février 2010 à 16:00 -0800, Paul E. McKenney a écrit :
[...]
>> @@ -1654,12 +1654,12 @@ static struct dn_route *dn_rt_cache_get_first(struct seq_file *seq)
>>
>>       for(s->bucket = dn_rt_hash_mask; s->bucket >= 0; --s->bucket) {
>>               rcu_read_lock_bh();
>> -             rt = dn_rt_hash_table[s->bucket].chain;
>> +             rt = rcu_dereference_bh(dn_rt_hash_table[s->bucket].chain);
>>               if (rt)
>>                       break;
>>               rcu_read_unlock_bh();
>>       }
>> -     return rcu_dereference(rt);
>> +     return rt;
>>  }

Isn't there a bug? Looks like data pointed to by rt should be
protected by RCU, but the rcu_read_lock is withdrawn before access.

Best Regards,
Michał Mirosław
