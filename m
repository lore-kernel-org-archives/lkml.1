Return-Path: <linux-kernel-owner+w=401wt.eu-S1756680AbZBJV4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbZBJV4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 16:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755509AbZBJV4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 16:56:35 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:42415 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613AbZBJV4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 16:56:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cyLuTi68gotU77nq90J1ZDKUbAQhb/+xbBY+xpm2MFC6UsO9qzBp0d1CVtjgcNIqAd
         oX2TnpKgRriZkHdbmXjIiuO3sewxig1UEI5A4LYL71asEl31OXqfejEE5srSajzBXxAj
         M0v+s5IF7+xTY9nHeEO0Q8uJrlrHdcRLC67Gw=
MIME-Version: 1.0
In-Reply-To: <f73f7ab80902101311w30d5aecet6dd7c2123a671480@mail.gmail.com>
References: <56e1b5710902040628w5ceb36f5kdb1f433087355f80@mail.gmail.com>
	 <20090204221451.GA27254@uranus.ravnborg.org>
	 <adavdrplty2.fsf@cisco.com> <498A295A.4090008@gmail.com>
	 <adaskmtjsnn.fsf@cisco.com>
	 <56e1b5710902050026s5a8fd48fhf4a65c05a533dbc3@mail.gmail.com>
	 <f73f7ab80902101311w30d5aecet6dd7c2123a671480@mail.gmail.com>
Date: Tue, 10 Feb 2009 22:56:32 +0100
Message-ID: <56e1b5710902101356h56140a5r12be50439b2ce10f@mail.gmail.com>
Subject: Re: [PATCH] Kbuild: Disable the -Wformat-security gcc flag
From: Floris Kraak <randakar@gmail.com>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Roland Dreier <rdreier@cisco.com>, Robert Hancock <hancockrwd@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 10:11 PM, Kyle Moffett <kyle@moffetthome.net> wrote:
> On Thu, Feb 5, 2009 at 3:26 AM, Floris Kraak <randakar@gmail.com> wrote:
>> There are probably some real bugs in there. On the other hand there is
>> some overhead to fixing the warnings. Kernel text size increase,
>> possibly some CPU overhead from parsing the format string. Hopefully
>> none of these calls are in really hot code paths ;-)
>
> Actually, I would really suspect that CPU time would *decrease* for
> most of these, because instead of groveling through the whole argument
> string looking for '%' symbols we would do a single "%s" lookup
> followed by a basic strncpy(dmesg_buffer + offset, arg,
> dmesg_buffer_size - offset);
>

True enough.
Still increasing kernel text in a number of cases.

I've been thinking that in a lot of them (most of the 'banner' and
'version' substitutions, basically) I can probably get away with
moving the string argument into the function that uses it without
losing the __initdata section advantage - it just gets moved from an
__initdata segment into an __init declared function anyway.. or
something that should be declared __init at any rate since what the
hell is it using __initdata segment data for otherwise?

Unless some expert on these section markers can dispute that line of
reasoning, anyway ;-)
It means redoing most - possibly all - of the trivial patch though.

Getting rid if a few warnings most people don't even get is more work
than I thought. And to think I was considering looking into other
types of warnings as well ..
I should consider it a nice exercise in learning kernel development
practices I guess ..

Regards,
Floris
---
"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."
  -- Ben Franklin

"The course of history shows that as a government grows, liberty
decreases."
  -- Thomas Jefferson
