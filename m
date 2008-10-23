Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbYJWLy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbYJWLy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 07:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbYJWLyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 07:54:21 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:51500 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbYJWLyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 07:54:20 -0400
Date: Thu, 23 Oct 2008 12:54:21 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: rdunlap@xenotime.net, jschopp@austin.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [checkpatch.pl] two bugs
Message-ID: <20081023115421.GD8343@brain>
References: <200810210057.m9L0vQ7i012829@www262.sakura.ne.jp> <20081022075617.GA22344@brain> <20081022083141.GB22344@brain> <200810222021.EEH69777.MOFOLSVtQJHFOF@I-love.SAKURA.ne.jp> <200810232027.FDJ17114.tLQOOHVMFOJFSF@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810232027.FDJ17114.tLQOOHVMFOJFSF@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 08:27:34PM +0900, Tetsuo Handa wrote:
> Hello.
> 
> I think these are bugs.
> 
> Regards.
> -----
> 
> Bug 1:
>   assignment in 'if' is not warned if '\n' is inserted before the assignment.

Yep that looks wrong, too line oriented.

> # cat /tmp/test1.c
> void foo(void)
> {
> 	int i = 0;
> 	if (0 ||
> 	    (i = 0) != 0)
> 		return;
> }
> # /usr/src/vanilla/linux-2.6.27.3/scripts/checkpatch.pl --file /tmp/test1.c
> total: 0 errors, 0 warnings, 7 lines checked
> 
> /tmp/test1.c has no obvious style problems and is ready for submission.
> # ./scripts/checkpatch.pl-testing --strict --file /tmp/test1.c
> total: 0 errors, 0 warnings, 0 checks, 7 lines checked
> 
> /tmp/test1.c has no obvious style problems and is ready for submission.
> 
> 
> 
> Bug 2:
>   'while' placed after 'if { }' block is not handled properly.
> 
> # cat /tmp/test2.c
> int i;
> void foo(void)
> {
> 	if (!i) {
> 		i++;
> 		return;
> 	}
> 	while (i);
> }
> # /usr/src/vanilla/linux-2.6.27.3/scripts/checkpatch.pl --file /tmp/test2.c
> ERROR: trailing statements should be on next line
> #8: FILE: tmp/test2.c:8:
> +       while (i);
> 
> ERROR: while should follow close brace '}'
> #8: FILE: tmp/test2.c:8:
> +       }
> +       while (i);
> 
> total: 2 errors, 0 warnings, 9 lines checked
> 
> /tmp/test2.c has style problems, please review.  If any of these errors
> are false positives report them to the maintainer, see
> CHECKPATCH in MAINTAINERS.
> # ./scripts/checkpatch.pl-testing --strict --file /tmp/test2.c
> ERROR: trailing statements should be on next line
> #8: FILE: tmp/test2.c:8:
> +       while (i);
> +       while (i);

Hmmm, we have done a lot of work here to figure out this is a while
without a do and therefore the ; should be on the next line; yet we then
let the looser check below fire too.  A bug indeed.

> ERROR: while should follow close brace '}'
> #8: FILE: tmp/test2.c:8:
> +       }
> +       while (i);
> 
> total: 2 errors, 0 warnings, 0 checks, 9 lines checked

Thanks for your reports.  Will get them on the tofix list.

-apw
