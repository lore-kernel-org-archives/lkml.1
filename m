Return-Path: <linux-kernel-owner+w=401wt.eu-S1758228AbZDHHj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228AbZDHHj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbZDHHjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:39:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:37939 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbZDHHjR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:39:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hixrd04o+FY208crskaZuvx3LopL1vB0ip55uslHKNGlFiXICIL0fB88pj7QocFA5I
         W0bCCMfDcL/JS0dJkWn+MS9v0PGT63qUwbtgYilWmYL2+KWZTAOcaeOodYrm0TJArbdF
         24Humb8Rf+R+BLo7SYYDWBk6mHBXy8ZD5IW/U=
MIME-Version: 1.0
In-Reply-To: <20090408065121.GI17934@one.firstfloor.org>
References: <20090407509.382219156@firstfloor.org>
	 <20090407150959.C099D1D046E@basil.firstfloor.org>
	 <28c262360904071621j5bdd8e33u1fbd8534d177a941@mail.gmail.com>
	 <20090408065121.GI17934@one.firstfloor.org>
Date: Wed, 8 Apr 2009 16:39:17 +0900
Message-ID: <28c262360904080039l65c381edn106484c88f1c5819@mail.gmail.com>
Subject: Re: [PATCH] [3/16] POISON: Handle poisoned pages in page free
From: Minchan Kim <minchan.kim@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 8, 2009 at 3:51 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> >
>> >        /*
>> > +        * Page may have been marked bad before process is freeing it.
>> > +        * Make sure it is not put back into the free page lists.
>> > +        */
>> > +       if (PagePoison(page)) {
>> > +               /* check more flags here... */
>>
>> How about adding WARNING with some information(ex, pfn, flags..).
>
> The memory_failure() code is already quite chatty. Don't think more
> noise is needed currently.

Sure.

> Or are you worrying about the case where a page gets corrupted
> by software and suddenly has Poison bits set? (e.g. 0xff everywhere).
> That would deserve a printk, but I'm not sure how to reliably test for
> that. After all a lot of flag combinations are valid.

I misunderstood your code.
That's because you add the code in bad_page.

As you commented, your intention was to prevent bad page from returning buddy.
Is right ?
If it is right, how about adding prevention code to free_pages_check ?
Now, bad_page is for showing the information that why it is bad page
I don't like emergency exit in bad_page.

> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only.
>



-- 
Kinds regards,
Minchan Kim
