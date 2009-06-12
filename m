Return-Path: <linux-kernel-owner+w=401wt.eu-S1757462AbZFLLn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462AbZFLLn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 07:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbZFLLnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 07:43:50 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:60474 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbZFLLnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 07:43:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=WN10BgX2721ufc94jdHYvwldS8O0rdaqkEevGAnEeqZWJFR/mkVnn0n7BX+NTEwoz+
         R1nSBZLLF4v/H93tAOfeCk2ocAHgOBKHkFInjzo6UY7mHEITG9satCwTqMxMxI4WkTY1
         PugcH9tYsNoAT3R4eBUR1vEzvfPTwos3tFY5c=
MIME-Version: 1.0
In-Reply-To: <1244806872.7172.138.camel@pasglop>
References: <Pine.LNX.4.64.0906121113210.29129@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0906121201490.30049@melkki.cs.Helsinki.FI>
	 <20090612091002.GA32052@elte.hu>
	 <84144f020906120249y20c32d47y5615a32b3c9950df@mail.gmail.com>
	 <20090612100756.GA25185@elte.hu>
	 <84144f020906120311x7c7dd628s82e3ca9a840f9890@mail.gmail.com>
	 <1244805060.7172.126.camel@pasglop>
	 <1244806440.30512.51.camel@penberg-laptop>
	 <1244806872.7172.138.camel@pasglop>
Date: Fri, 12 Jun 2009 14:43:50 +0300
X-Google-Sender-Auth: b097960559765db8
Message-ID: <84144f020906120443w6496d408uadede7a8e1b772a@mail.gmail.com>
Subject: Re: [PATCH v2] slab,slub: ignore __GFP_WAIT if we're booting or 
	suspending
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, npiggin@suse.de,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Fri, Jun 12, 2009 at 2:41 PM, Benjamin
Herrenschmidt<benh@kernel.crashing.org> wrote:
>> That said, Nick and Ingo seem to think special-casing is questionable
>> and I haven't had green light for any of the patches yet. The gfp
>> sanitization patch adds some overhead to kmalloc() and page allocator
>> paths which is obviously a concern.
>
> Let's wait and see what Linus thinks...

Yup, lets do that.

On Fri, Jun 12, 2009 at 2:41 PM, Benjamin
Herrenschmidt<benh@kernel.crashing.org> wrote:
>> So while we continue to discuss this, I'd really like to proceed with
>> the patch below. At least it should allow people to boot their kernels
>> (although it will produce warnings). I really don't want to keep other
>> people waiting for us to reach a resolution on this. Are you OK with
>> that?
>
> I don't care -how- we achieve the result I want as long as we achieve
> it, which is to remove the need for callers to care. My approach was one
> way to do it, I'm sure there's a better one. That's not the point. I'm
> too tried now to properly review your patch and I'll need to test it
> tomorrow morning, but it looks ok except for the WARN_ON maybe.

OK, the WARN_ON is there because you will get warnings for
might_sleep() et al as well.

                                        Pekka
