Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbYHXQ7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbYHXQ7a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 12:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbYHXQ7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 12:59:18 -0400
Received: from gw.goop.org ([64.81.55.164]:53937 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbYHXQ7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 12:59:18 -0400
Message-ID: <48B19363.6040409@goop.org>
Date: Sun, 24 Aug 2008 09:59:15 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: benh@kernel.crashing.org
CC: Andrew Morton <akpm@linux-foundation.org>, ehabkost@redhat.com,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1 of 3] add phys_addr_t for holding physical addresses
References: <73196c9129c7298f2428.1219176170@localhost> <1219570798.21386.213.camel@pasglop>
In-Reply-To: <1219570798.21386.213.camel@pasglop>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
>  .../...
>
>   
>> diff --git a/include/asm-x86/page_32.h b/include/asm-x86/page_32.h
>> --- a/include/asm-x86/page_32.h
>> +++ b/include/asm-x86/page_32.h
>> @@ -33,7 +33,6 @@
>>  typedef u64	pudval_t;
>>  typedef u64	pgdval_t;
>>  typedef u64	pgprotval_t;
>> -typedef u64	phys_addr_t;
>>     
>  
>  .../...
>
> Might sound a stupid question, but why have a CONFIG_ option and
> a global definition based on it rather than each arch defining it
> as part of the base types ? I don't have a firm preference for one
> or the other at this point, I can see pro and cons to both approach,
> so I'm curious to see what others think about it.

My thinking is that:

There's only two possible types it can have: u32 and u64.  If we leave
it to per-arch definitions, they'll come up with a variety of different
ways of spelling those types (like u64 itself, but I gather that's being
fixed).

Furthermore, with only a couple of exceptions, the size is the same as
the bitness of the architecture, so there's no need to set a config in
most cases.

So, avoiding lots of duplication, basically.

    J
