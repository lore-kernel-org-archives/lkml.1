Return-Path: <linux-kernel-owner+w=401wt.eu-S1753580AbYJVH4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580AbYJVH4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 03:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbYJVH4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 03:56:13 -0400
Received: from tallyho.bytemark.co.uk ([80.68.81.166]:38216 "EHLO
	tallyho.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbYJVH4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 03:56:13 -0400
Date: Wed, 22 Oct 2008 08:56:17 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: penguin-kernel@i-love.sakura.ne.jp
Cc: rdunlap@xenotime.net, jschopp@austin.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: */ in string confuses checkpatch.pl
Message-ID: <20081022075617.GA22344@brain>
References: <200810210057.m9L0vQ7i012829@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200810210057.m9L0vQ7i012829@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 09:57:26AM +0900, penguin-kernel@i-love.sakura.ne.jp wrote:
> Hello.
> 
> The below code confuses checkpatch.pl ver 0.21.
> 
> Regards.
> ----------
> # cat /tmp/foo.c
> void foo(void)
> {
> 	bar(\" /proc/\\\\*/\");
> 	bar(\" /proc/\\\\$/\");
> }
> # /usr/src/vanilla/linux-2.6.27.2/scripts/checkpatch.pl --file /tmp/foo.c
> ERROR: need consistent spacing around \'/\' (ctx:WxV)
> #4: FILE: tmp/foo.c:4:
> +       bar(\" /proc/\\\\$/\");
>               ^
> 
> total: 1 errors, 0 warnings, 5 lines checked
> 
> /tmp/foo.c has style problems, please review.  If any of these errors
> are false positives report them to the maintainer, see
> CHECKPATCH in MAINTAINERS.

I am unable to reproduce this here with any version from current back to
v0.19, nor with the one I find in v2.6.27.2 (see below).  Though looking at
the code as presented in your example I can see how it might be interpreted
incorrectly.  That said the compiler doesn't seem to be able to understand
this either (also below).  In particular you effectivly open a quote on
the third line and never close it.

Could you send me both the checkpatch script and the foo.c as attachments
so I can be sure I have them without some emailer somewhere mushing
them up.

Thanks for you report.

-apw

$ cat ../checkpatch/Z213.c
void foo(void)
{
	bar(\" /proc/\\\\*/\");
	bar(\" /proc/\\\\$/\");
}
$ cc -c Z213.c
Z213.c: In function ‘foo’:
Z213.c:3: error: stray ‘\’ in program
Z213.c:3:7: warning: missing terminating " character
Z213.c:3: error: missing terminating " character
Z213.c:4: error: stray ‘\’ in program
Z213.c:4:7: warning: missing terminating " character
Z213.c:4: error: missing terminating " character
Z213.c:5: error: expected expression before ‘}’ token
Z213.c:5: error: expected ‘)’ before ‘}’ token
Z213.c:5: error: expected ‘;’ before ‘}’ token

$ git checkout v2.6.27.2
HEAD is now at 6bcd6d7... Linux 2.6.27.2
apw@brain$ ./scripts/checkpatch.pl  --file ../checkpatch/Z213.c
total: 0 errors, 0 warnings, 5 lines checked

../checkpatch/Z213.c has no obvious style problems and is ready for submission.
$
