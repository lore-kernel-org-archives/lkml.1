Return-Path: <linux-kernel-owner+w=401wt.eu-S1763960AbZDHKFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763960AbZDHKFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 06:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756795AbZDHKFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 06:05:32 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:49841 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755707AbZDHKFb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 06:05:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UWP8r2aMITXlRWaNY0xXpjrTJ7w9U0PdJpp1s/3+jHGkRPGBuGbCjPCKjCnrRin8/f
         jDFMYINsK5O1YkqBILYLnattjdEpi7zb/5jPMv9A1D8s/7sW8ZVxaJRv6/s4N5+4ruwn
         67jhI3yo0hVYM3Pb+B8VKW4PyzZR1KuL8Jetg=
MIME-Version: 1.0
In-Reply-To: <20090408094159.GK17934@one.firstfloor.org>
References: <20090407509.382219156@firstfloor.org>
	 <20090407150959.C099D1D046E@basil.firstfloor.org>
	 <28c262360904071621j5bdd8e33u1fbd8534d177a941@mail.gmail.com>
	 <20090408065121.GI17934@one.firstfloor.org>
	 <28c262360904080039l65c381edn106484c88f1c5819@mail.gmail.com>
	 <20090408094159.GK17934@one.firstfloor.org>
Date: Wed, 8 Apr 2009 19:05:30 +0900
Message-ID: <28c262360904080305y381628e3y466038f7c6232b2f@mail.gmail.com>
Subject: Re: [PATCH] [3/16] POISON: Handle poisoned pages in page free
From: Minchan Kim <minchan.kim@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 8, 2009 at 6:41 PM, Andi Kleen <andi@firstfloor.org> wrote:
> On Wed, Apr 08, 2009 at 04:39:17PM +0900, Minchan Kim wrote:
>> On Wed, Apr 8, 2009 at 3:51 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> >> >
>> >> >        /*
>> >> > +        * Page may have been marked bad before process is freeing it.
>> >> > +        * Make sure it is not put back into the free page lists.
>> >> > +        */
>> >> > +       if (PagePoison(page)) {
>> >> > +               /* check more flags here... */
>> >>
>> >> How about adding WARNING with some information(ex, pfn, flags..).
>> >
>> > The memory_failure() code is already quite chatty. Don't think more
>> > noise is needed currently.
>>
>> Sure.
>>
>> > Or are you worrying about the case where a page gets corrupted
>> > by software and suddenly has Poison bits set? (e.g. 0xff everywhere).
>> > That would deserve a printk, but I'm not sure how to reliably test for
>> > that. After all a lot of flag combinations are valid.
>>
>> I misunderstood your code.
>> That's because you add the code in bad_page.
>>
>> As you commented, your intention was to prevent bad page from returning buddy.
>> Is right ?
>
> Yes. Well actually it should not happen anymore. Perhaps I should
> make it a BUG()
>
>> If it is right, how about adding prevention code to free_pages_check ?
>> Now, bad_page is for showing the information that why it is bad page
>> I don't like emergency exit in bad_page.
>
> There's already one in there, so i just reused that one. It was a convenient
> way to keep things out of the fast path


Sorry for my vague previous comment.
I mean bad_page function's role is just to print why it is bad now.
Whoever can use bad_page to show information.
If someone begin to add side branch in bad_page, anonther people might
add his exception case in one.

So, I think it would be better to check PagePoison in free_pages_check
not bad_page. :)

> -Andi
>
> ak@linux.intel.com -- Speaking for myself only.
>



-- 
Kinds regards,
Minchan Kim
