Return-Path: <linux-kernel-owner+w=401wt.eu-S1763578AbZFLJtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763578AbZFLJtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 05:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964AbZFLJtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 05:49:16 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:35867 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbZFLJtQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 05:49:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=oCD08Z3iGZP//R5rC0Z4rTweZBO3WBHvqm4H726B03BKV2SOthFI1R7ieSsbc1AYw7
         TccsW1XJAtSSxSg2ieO9UtxAZmA6ztYdrke2ms+MbHA4j0u1GLu5Izs96dATxcO8WKbU
         l2BPUEheUN9yncIWCZncBJIKWiAKBLBezbz80=
MIME-Version: 1.0
In-Reply-To: <20090612091002.GA32052@elte.hu>
References: <Pine.LNX.4.64.0906121113210.29129@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0906121201490.30049@melkki.cs.Helsinki.FI>
	 <20090612091002.GA32052@elte.hu>
Date: Fri, 12 Jun 2009 12:49:17 +0300
X-Google-Sender-Auth: 0831016c0eb2194f
Message-ID: <84144f020906120249y20c32d47y5615a32b3c9950df@mail.gmail.com>
Subject: Re: [PATCH v2] slab,slub: ignore __GFP_WAIT if we're booting or 
	suspending
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       benh@kernel.crashing.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 12:10 PM, Ingo Molnar<mingo@elte.hu> wrote:
>> @@ -1548,6 +1548,20 @@ new_slab:
>>               goto load_freelist;
>>       }
>>
>> +     /*
>> +      * Lets not wait if we're booting up or suspending even if the user
>> +      * asks for it.
>> +      */
>> +     if (system_state != SYSTEM_RUNNING)
>> +             gfpflags &= ~__GFP_WAIT;
>
> Hiding that bug like that is not particularly clean IMO. We should
> not let system_state hacks spread like that.
>
> We emit a debug warning but dont crash, so all should be fine and
> the culprits can then be fixed, right?

OK, lets not use system_state then and go with Ben's approach then.
Again, neither of the patches are about "hiding buggy callers" but
changing allocation policy wrt. gfp flags during boot (and later on
during suspend).

                                 Pekka
