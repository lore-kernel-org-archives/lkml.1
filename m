Return-Path: <linux-kernel-owner+w=401wt.eu-S1753557AbYKZLZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbYKZLZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 06:25:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbYKZLZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 06:25:00 -0500
Received: from mail-qy0-f22.google.com ([209.85.221.22]:34732 "EHLO
	mail-qy0-f22.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbYKZLY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 06:24:59 -0500
X-Greylist: delayed 819 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Nov 2008 06:24:58 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=F1ejEUi8xFPh6D7tavMA88AvCJp64XqraDwMi1Jgz0QcKWabWpcIvR9xqX239+w0Bb
         ACWZcbwDdTBjcQyckkUg6YLIdSGSCrYhif+ngFVJfUfi+vbLyMVyR6hZ5tCgi+pepxAy
         XDPksYp1CWAwG7+GPGzEsq+T75vJ2fngdZq4s=
Message-ID: <c62985530811260311k4237012asd27ebd8599328cea@mail.gmail.com>
Date: Wed, 26 Nov 2008 12:11:15 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] tracing/function-return-tracer: set a more human readable output
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081126020459.GA16374@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492C90E5.8070907@gmail.com> <20081126003936.GA26937@elte.hu>
	 <20081126020459.GA16374@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/26 Ingo Molnar <mingo@elte.hu>:
> 1) Compression of non-nested calls into a single line.
>
>   Implementing this probably necessiates some trickery with the
>   ring-buffer: we'd have to look at the next entry as well and see
>   whether it closes the function call.


I wanted to do so. That's not so easy, I guess I will not only have to read
the next entry. I'll have to modify it to avoid the next entry to
print a closing brace.
But I don't think that would be a problem.
Note with this method that if there is a context switch or an
interrupt between the entry and
the return of a leaf function, it will not anymore be considered as a non-nested
function on its output.
But the case would be rare enough, so I will apply this.

> 2) Adding a closing ';' semicolon to single-line calls. It's the C
>   syntax and i'm missing it :-)


Yeah :-)


> 3) The first column: single-character visual shortcuts for "overhead".
>   This is a concept we used in the -rt tracer and it still lives in
>   the latency tracer bits of ftrace and is quite useful:
>
>    '+' means "overhead spike": overhead is above 10 usecs.
>    '!' means "large overhead": overhead is above 100 usecs.
>
>   These give at-a-glance hotspot analysis - hotspots are easier to
>   miss as pure numbers.
>
> 4) Printing out in units of microseconds, with a decimal point and by
>   explicitly mentioning the 'us' unit.
>
>   All of these are important properties: microseconds is still the
>   most common 'overhead' unit in kernel circles. It also gives rather
>   human single-digit or two-digit results. Nanoseconds is three or-
>   four-digit - which is too much. Repeating 'us' so many times is not
>   a problem - these lines will be grepped, quoted, etc - constant
>   reminder about the unit is just fine.
>
> 5) Nesting the overhead numbers aligned to the right end of the graph.
>
>   This cleans up the view of the source code printout, but not
>   cluttering it with numbers. It also structures the numbers some
>   more. Visual cues are given via '-' and '+' signs, to follow
>   nesting. This nesting aligns up with the function nesting levels on
>   the left side - so it's easy to pair up number and function name.
>   It also separates the numbers from the symbol length effects in the
>   single-line case. (which is the most common trace line)


Totally agree!


> What do you think? It's lots of work (sorry! :-), but it would produce
> even more stunning graph-tracer output IMO.

Yes, I knew this was only a first try when I submitted it :-)
I will apply these suggestions.

Thanks!
