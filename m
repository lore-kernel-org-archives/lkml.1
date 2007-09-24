Return-Path: <linux-kernel-owner+w=401wt.eu-S1763969AbXIXQsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763969AbXIXQsA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763492AbXIXQnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:43:12 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:14030 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763427AbXIXQnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:43:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UEwKgMVdCxDgGcJhW4oMhZvkNLrB/wJjdCzjhlgRLMpeZrpQd2F+9dQwkKUsuJjxh12pAFUaSZw6YuXmgKBDz3vb/XRopfVVAEjnA2osYK3pFsNPjVjlcVc5v5D0su+ivhSib9a7RRkMW1N8JaAanWIni5fZddndNvTuIsNCaR0=
Message-ID: <19f34abd0709240943s13472c97ma7a4aff3a6089e8f@mail.gmail.com>
Date: Mon, 24 Sep 2007 18:43:09 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Joe Perches" <joe@perches.com>
Subject: Re: [RFC] New kernel-message logging API
Cc: holzheu@linux.vnet.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       "Rob Landley" <rob@landley.net>,
       "Dick Streefland" <dick.streefland@altium.nl>
In-Reply-To: <1190647156.30132.92.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0709221227v67443c0bg2cd2010e5bd5a6c1@mail.gmail.com>
	 <1190625742.12666.30.camel@localhost.localdomain>
	 <1190647156.30132.92.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/24/07, Joe Perches <joe@perches.com> wrote:
> On Mon, 2007-09-24 at 11:22 +0200, Michael Holzheu wrote:
> > Together with the idea of not allowing multiple lines in the kprint_xxx
> > functions, that would go with our approach having message numbers to
> > identify a message.
>
> How does this equate/give message numbers?

Storing the format-string separately allows us to hash THAT instead of
the formatted (ie. console output) message. Since this will never
change from message to message, it can be looked up in a table or
whatever and allow user-space to do translations without for example
regular expressions.

I'm pretty sure this *would* be possible to do with existing printk(),
but I'm betting it also wouldn't look very nice (i.e. hackery).

> > If you do it like that, you can't support "%s", since then you would
> > store only the pointer and not the whole string. I think, that we can't
> > live without %s.
>
> long long would not work either.
>
> Perhaps it's better to scan the format string or indirect the
> printk formatting logic.

The idea was to not use snprintf() for the stored message, but have a
printf-like function that instead writes the output of each format
specifier to its own string (ie. each argument produces a new char*
object). Also needed would be an additional function that reads the
format string but uses the stored arguments.

This turned out to be slightly harder than I assumed at first, though
it's of course not impossible. The downside of this approach is of
course the need to maintain normal vsnprintf() and new functions side
by side, with little possibility of reusing the format parsing of
vsnprintf().

I will follow up with some code to demonstrate as soon as I can.


Vegard
