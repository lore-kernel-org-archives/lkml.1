Return-Path: <linux-kernel-owner+w=401wt.eu-S1759292AbXFFJF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292AbXFFJF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 05:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbXFFJFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 05:05:14 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:55662 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbXFFJFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 05:05:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=W4LWC8vbt5hbFhxQwxGxRA0L50lBHyFp5QYlJQUsf0X6CxkBASg9C4REzdEycrrTVRDFdHfnhovxb8M/tfzEeq95JCIkmlWumG/JdciMdWenCDmff/+mM7TjBgVxUIoYU/GG59cbrI3k6oU8vbRMp3v97QULgrIQJON6h/IBuFU=
Message-ID: <9a8748490706060205y1fc8e354p4af7426fd76dd816@mail.gmail.com>
Date: Wed, 6 Jun 2007 11:05:07 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Andy Whitcroft" <apw@shadowen.org>
Subject: Re: [PATCH] update checkpatch.pl to version 0.03
Cc: "Andrew Morton" <akpm@osdl.org>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Joel Schopp" <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <0a25fd03117c678f17006c5fcefaaed0@pinky>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <0a25fd03117c678f17006c5fcefaaed0@pinky>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/07, Andy Whitcroft <apw@shadowen.org> wrote:
>
> This version brings a host of changes to cure false positives and
> bugs detected on patches submitted to lkml and -mm.  It also brings
> a number of new tests in response to reviews, of particular note:
>

I have a few ideas for additional checks you could add to that script:

 - Source files should be 7bit ASCII and Documentation/Kbuild
files/etc should be UTF-8, test that the patch honors that and doesn't
put something else in (cleanups that remove 8bit ASCII etc from a
source file is OK though).

- Check that nothing in the patch touches any file from Documentation/dontdiff

- Check for an excessive number of blank lines - some people have a
nasty tendency to put 3 or more blank lines between functions or
between comments and next source line etc.

- Check that all newlines added by the patch are "\n", not "\r",
"\r\n" or "\n\r".

- Check that, if the patch adds a new file, the new file ends with a newline.

- Warn about usage of the "register" keyword.

- Maybe warn about usage of float/double in source files?

- 'return' is not a function, so warn about patches that think it is
and use 'return(expr);' (this one is tricky since 'return (expr);' can
be OK in some cases.


That's all I can come up with at the moment. If more ideas pop up I'll
let you know.
Good work with that script btw.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
