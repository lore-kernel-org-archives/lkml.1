Return-Path: <linux-kernel-owner+w=401wt.eu-S1756632AbZIOIiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbZIOIiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 04:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbZIOIiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 04:38:18 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:53551 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbZIOIiR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 04:38:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tUa1Uw+0gNMUpUO5A5gvZN6ulwPazWGrwlOtEYyVyBUrVt9wTnVTFDEB2o/YmmLZN9
         kIn3vtrxSuVvZkkH3y5ukT1eEnd850ebkC7+k6TEfubPdBxjylU9b8j1wv16E8MUbOUv
         w8dLQ3p6SUklEqLhEMGfdLxkRIyLDw4Mn2QpE=
MIME-Version: 1.0
In-Reply-To: <8bd0f97a0909140643x1f9c6478r51dcd762d6ba485@mail.gmail.com>
References: <1252870707-4824-1-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-2-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-3-git-send-email-felipe.contreras@gmail.com>
	 <8bd0f97a0909131412v6ba29823ube9aab20302aaca0@mail.gmail.com>
	 <94a0d4530909131442h43d0ed1cl9f395f7d38f2c43@mail.gmail.com>
	 <8bd0f97a0909131458r8574620pa539876da969eb5f@mail.gmail.com>
	 <94a0d4530909131504h1a9de951k3719000705a86bbc@mail.gmail.com>
	 <20090914044657.GA4252@merkur.ravnborg.org>
	 <94a0d4530909140125p73589cffy71a141d234508049@mail.gmail.com>
	 <8bd0f97a0909140643x1f9c6478r51dcd762d6ba485@mail.gmail.com>
Date: Tue, 15 Sep 2009 11:38:19 +0300
Message-ID: <94a0d4530909150138y3fd09be4te62261bbde768893@mail.gmail.com>
Subject: Re: [PATCH 2/5] kbuild: fix warning when domainname is not available
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 4:43 PM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Mon, Sep 14, 2009 at 04:25, Felipe Contreras wrote:
>> On Mon, Sep 14, 2009 at 7:46 AM, Sam Ravnborg wrote:
>>> On Mon, Sep 14, 2009 at 01:04:11AM +0300, Felipe Contreras wrote:
>>>> On Mon, Sep 14, 2009 at 12:58 AM, Mike Frysinger wrote:
>>>> > On Sun, Sep 13, 2009 at 17:42, Felipe Contreras wrote:
>>>> >> On Mon, Sep 14, 2009 at 12:12 AM, Mike Frysinger wrote:
>>>> >>> On Sun, Sep 13, 2009 at 15:38, Felipe Contreras wrote:
>>>> >>>> +  if $domain; then
>>>> >>>
>>>> >>> is this really correct ?  i think you meant to use:
>>>> >>> [ -n "$domain" ]
>>>> >>
>>>> >> What is the difference?
>>>> >>
>>>> >> $domain unset
>>>> >> test -n "" -> false
>>>> >> test -> false
>>>> >>
>>>> >> $domain is a valid string
>>>> >> test -n "string" -> true
>>>> >> test "string" -> true
>>>> >
>>>> > except that you didnt invoke `test` anywhere.  you're executing the
>>>> > contents of $domain.
>>>>
>>>> Ahh, I'll update it to:
>>>> [ "$domain" ]
>>>
>>> Please use [ -n "$domain" ].
>>> Be explicit about what you do.
>>>
>>> [Likewise in c we never omit "int" just because we can].
>>
>> In fact 'int' is implicit of 'signed int', and 'long' is a shorthand
>> of 'signed long int' and so on. Also, AFAIK 'if (foo)' is preferred
>> over 'if (foo == true)' or 'if (foo != NULL)' and sometimes even 'if
>> (foo >= 0)'.
>>
>> What's the point of going for the explicit form? Make the code less readable?
>
> your argument here is the opposite of reality.  while some of us are
> aware of implicit `test`behavior, not everyone is a shell scripting
> master.  they look at [ "$foo" ] and dont immediately get the
> intention.  or perhaps someone typoed and didnt actually want -n
> semantics.  add the whole *3* characters and be done with it.

I consider myself an expert in bash (or at least was some time ago)
and I still need to run 'man bash' in order to see what the hell -n
means. On the other hand, what can [ "$foo" ] be confused with? To me
that can be assumed as: $foo is valid.

In any case, I don't see that idiom being used in the source tree
(which I think is bad), and I see -n being used in some places, so
I'll send a new patch using -n for consistency.

Cheers.

-- 
Felipe Contreras
