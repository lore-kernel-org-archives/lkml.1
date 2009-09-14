Return-Path: <linux-kernel-owner+w=401wt.eu-S1754079AbZINNoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbZINNoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 09:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbZINNoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 09:44:15 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:33434 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbZINNoO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 09:44:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=bRyOi0/6OZqCy8tL6kFcYuXSuT/gimOUqSiFKqMvMQugYSCnL/j/FVeazDxE4/DZy6
         5eXbf/LHiiFxGtdZLlqrN/27I81EnzCNDeQrf8XCtu1uayAYnymPUIyh8Gebv1zd5egO
         F1CNPvAUF7G9yvo08cFWNFiAVHkjfzuvmyH4g=
MIME-Version: 1.0
In-Reply-To: <94a0d4530909140125p73589cffy71a141d234508049@mail.gmail.com>
References: <1252870707-4824-1-git-send-email-felipe.contreras@gmail.com> 
	<1252870707-4824-2-git-send-email-felipe.contreras@gmail.com> 
	<1252870707-4824-3-git-send-email-felipe.contreras@gmail.com> 
	<8bd0f97a0909131412v6ba29823ube9aab20302aaca0@mail.gmail.com> 
	<94a0d4530909131442h43d0ed1cl9f395f7d38f2c43@mail.gmail.com> 
	<8bd0f97a0909131458r8574620pa539876da969eb5f@mail.gmail.com> 
	<94a0d4530909131504h1a9de951k3719000705a86bbc@mail.gmail.com> 
	<20090914044657.GA4252@merkur.ravnborg.org> <94a0d4530909140125p73589cffy71a141d234508049@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 14 Sep 2009 09:43:58 -0400
Message-ID: <8bd0f97a0909140643x1f9c6478r51dcd762d6ba485@mail.gmail.com>
Subject: Re: [PATCH 2/5] kbuild: fix warning when domainname is not available
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 04:25, Felipe Contreras wrote:
> On Mon, Sep 14, 2009 at 7:46 AM, Sam Ravnborg wrote:
>> On Mon, Sep 14, 2009 at 01:04:11AM +0300, Felipe Contreras wrote:
>>> On Mon, Sep 14, 2009 at 12:58 AM, Mike Frysinger wrote:
>>> > On Sun, Sep 13, 2009 at 17:42, Felipe Contreras wrote:
>>> >> On Mon, Sep 14, 2009 at 12:12 AM, Mike Frysinger wrote:
>>> >>> On Sun, Sep 13, 2009 at 15:38, Felipe Contreras wrote:
>>> >>>> +  if $domain; then
>>> >>>
>>> >>> is this really correct ?  i think you meant to use:
>>> >>> [ -n "$domain" ]
>>> >>
>>> >> What is the difference?
>>> >>
>>> >> $domain unset
>>> >> test -n "" -> false
>>> >> test -> false
>>> >>
>>> >> $domain is a valid string
>>> >> test -n "string" -> true
>>> >> test "string" -> true
>>> >
>>> > except that you didnt invoke `test` anywhere.  you're executing the
>>> > contents of $domain.
>>>
>>> Ahh, I'll update it to:
>>> [ "$domain" ]
>>
>> Please use [ -n "$domain" ].
>> Be explicit about what you do.
>>
>> [Likewise in c we never omit "int" just because we can].
>
> In fact 'int' is implicit of 'signed int', and 'long' is a shorthand
> of 'signed long int' and so on. Also, AFAIK 'if (foo)' is preferred
> over 'if (foo == true)' or 'if (foo != NULL)' and sometimes even 'if
> (foo >= 0)'.
>
> What's the point of going for the explicit form? Make the code less readable?

your argument here is the opposite of reality.  while some of us are
aware of implicit `test`behavior, not everyone is a shell scripting
master.  they look at [ "$foo" ] and dont immediately get the
intention.  or perhaps someone typoed and didnt actually want -n
semantics.  add the whole *3* characters and be done with it.
-mike
