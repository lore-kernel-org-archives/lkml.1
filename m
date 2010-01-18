Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162Ab0ARP4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab0ARP4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 10:56:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058Ab0ARP4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 10:56:08 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:43424 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab0ARP4H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 10:56:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PiTYAkN2IXycMbP4F+VQ7bZWYE2ZHd7aH7oYFNBy7pqlz7GHE+eViRmCXzhnjuNEzv
         msVjUGJa1aCyiYX4lBJXI4XYNldcuQPJKwNqLdBO8q8dTIG1gi/RUtms8nAI3kY2MrbV
         B8LFoYyKjEnD1TJBygW0OHY5CPwQSLk0nM5PY=
MIME-Version: 1.0
In-Reply-To: <1263826439.28171.4006.camel@gandalf.stny.rr.com>
References: <4B4E86FB.40208@cn.fujitsu.com> <4B4E8743.6030805@cn.fujitsu.com>
	 <81b0412b1001160312x3874bbddj28aac9e5a36bf98a@mail.gmail.com>
	 <1263826439.28171.4006.camel@gandalf.stny.rr.com>
Date: Mon, 18 Jan 2010 16:56:05 +0100
Message-ID: <81b0412b1001180756u4daf3099h76d633f1f1143f05@mail.gmail.com>
Subject: Re: [PATCH 4/7] lib: Introduce strnstr()
From: Alex Riesen <raa.lkml@gmail.com>
To: rostedt@goodmis.org
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 15:53, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Sat, 2010-01-16 at 12:12 +0100, Alex Riesen wrote:
>>
>> Are you sure you want to search _past_ the NUL-terminator
>> of s1?
>>
>> > +       l2 = strlen(s2);
>> > +       if (!l2)
>> > +               return (char *)s1;
>> > +       while (l1 >= l2) {
>> > +               l1--;
>
> The first check is len-1, I don't see it searching past the
> NUL-terminator. The loop will stop when l1 == l2 (the size of s2) and s1
> pointing near the end of the string.

I thought that len means "minimum of strlen(s1) and len".

Li already explained that was not intended, even if s2 cannot be made to
contain a \0, as s1 can by specifying len greater than strlen(s1).
