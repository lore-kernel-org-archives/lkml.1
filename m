Return-Path: <linux-kernel-owner+w=401wt.eu-S1755070AbZJAIzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbZJAIzy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbZJAIzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:55:54 -0400
Received: from mail-pz0-f187.google.com ([209.85.222.187]:62484 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbZJAIzx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:55:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=hjnuKpwxg8+8YtPMmHOe1EtfUbTvcybdWSe8xnJo9mH+WrxxqqQU6BUmSDpTW4ATa1
         LsKvhOfIheycoCRp17xGsjC4SAN610MOtWwfXiKplqp08greagKGCq1eQGvFwZO3Hypw
         Jvlgyu46XqGCaz8FF7BM2uxs5QPpIzgEXPZVk=
MIME-Version: 1.0
In-Reply-To: <1254382000.1799.13.camel@Joe-Laptop.home>
References: <cover.1254193019.git.joe@perches.com>
	 <f28939e0018c7e2a9e898722e0fb8514a843b14c.1254193019.git.joe@perches.com>
	 <10f740e80910010010o4522a008h265e09d7988d7192@mail.gmail.com>
	 <1254382000.1799.13.camel@Joe-Laptop.home>
Date: Thu, 1 Oct 2009 10:55:56 +0200
X-Google-Sender-Auth: 70be621926771299
Message-ID: <10f740e80910010155jdf5c898x80a3a848182148a1@mail.gmail.com>
Subject: Re: [PATCH 1/9] lib/vsprintf.c: Add %pU to print UUID/GUIDs
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@nokia.com>,
       Alex Elder <aelder@sgi.com>, Artem Bityutskiy <dedekind@infradead.org>,
       Christoph Hellwig <hch@lst.de>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jgarzik@redhat.com>,
       Laurent Pinchart <laurent.pinchart@skynet.be>,
       Matt Mackall <mpm@selenic.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Neil Brown <neilb@suse.de>, Steven Whitehouse <swhiteho@redhat.com>,
       xfs-masters@oss.sgi.com, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 1, 2009 at 09:26, Joe Perches <joe@perches.com> wrote:
> On Thu, 2009-10-01 at 09:10 +0200, Geert Uytterhoeven wrote:
>> > Standardize the printed style of UUID/GUIDs by using
>> > another extension to %p.
>> >
>> > %pU:    01020304-0506-0708-090a-0b0c0d0e0f10
>> > %pUr:   04030201-0605-0807-090a-0b0c0d0e0f10
>> > %pU[r]X:Use upper case hex
>>
>> To me, it looks a bit strange to have the options after the `U', combined with
>> the variable-length nature.
>
> I think the whole %p<foo> mechanism is strange and takes
> a bit of getting used to.
>
> You're free to suggest alternatives.
>
> Keep in mind expansion for future different types and that
> <foo> must be alphanumeric chars only.

`r' is reverse endianness?

So what about
    %pUb: lower case big endian
    %pUl: lower case little endian
    %pUB: upper case big endian
    %pUL: upper case little endian
?

That way it's fixed length, and easier to parse.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
