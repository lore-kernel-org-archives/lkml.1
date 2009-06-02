Return-Path: <linux-kernel-owner+w=401wt.eu-S1758817AbZFBGsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817AbZFBGsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 02:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbZFBGsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 02:48:32 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:54770 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbZFBGsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 02:48:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZchEJ+fkDddWzY7Nb1cZnfrFsLNoMktDdlYoYmGjGEGSrnuVqGyKU2we8jBuXMib0o
         HfGCV8HPshIBtkfGa/VoZXE/IxL+FjnjoO20pXjrYqfZwMWMjKHYNif2prIEjcQ8pm/+
         5dLt+oPhV2AIOSe4aINfstoKfvE4ghNjA7wh8=
MIME-Version: 1.0
In-Reply-To: <20090601130825.GA1422@wotan.suse.de>
References: <1243517365.11533.65.camel@penberg-laptop>
	 <20090601130825.GA1422@wotan.suse.de>
Date: Tue, 2 Jun 2009 09:48:32 +0300
X-Google-Sender-Auth: 137b4daf79e8a87f
Message-ID: <84144f020906012348r749f7cfbk3cf7112e6263299b@mail.gmail.com>
Subject: Re: [PATCH] init: call vfs_caches_init_early() later in the boot 
	sequence
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nick Piggin <npiggin@suse.de>
Cc: mingo@elte.hu, cl@linux-foundation.com, torvalds@linux-foundation.org,
       mpm@selenic.com, yinghai@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

[ I see I typo'd Linus' email address in the original patch submission... ]

On Thu, May 28, 2009 at 04:29:25PM +0300, Pekka Enberg wrote:
>> From: Pekka Enberg <penberg@cs.helsinki.fi>
>>
>> There's no need to call vfs_caches_init_early() before kmem_cache_init(). All
>> we have to do is make sure we don't attempt to use the bootmem allocator after
>> we've called mem_init().

On Mon, Jun 1, 2009 at 4:08 PM, Nick Piggin <npiggin@suse.de> wrote:
> Hmm, but you'd want to be able to allocate > MAX_ORDER areas in the linear
> KVA, which the page allocator cannot do. So this is just going to silently
> truncate hash table size. Nack on this one.

OK, makes sense. IIRC, Linus suggested doing this but I think I'll
just revert the patch.

                                             Pekka
