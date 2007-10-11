Return-Path: <linux-kernel-owner+w=401wt.eu-S1757837AbXJKNsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837AbXJKNsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 09:48:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbXJKNr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 09:47:56 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3641 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbXJKNrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 09:47:55 -0400
Date: Thu, 11 Oct 2007 14:47:50 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Ingo Molnar <mingo@elte.hu>, rdunlap@xenotime.net, jschopp@austin.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 0/3 checkpatch updates, new checkfiles script
Message-ID: <20071011134750.GA3376@shadowen.org>
References: <20071006111343.GA29484@elte.hu> <200710071905.l97J5l6r018154@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710071905.l97J5l6r018154@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 07, 2007 at 03:05:47PM -0400, Erez Zadok wrote:
> 
> and got many perl warnings such as:
> 
> Use of uninitialized value in concatenation (.) or string at ./scripts/checkpatch.pl line 455.

Yes, this support seems to be wholy broken, as a non emacs user I had
failed to test it correctly as I added the --file option.  Bad Andy.

In testing it I note we are emitting wholy the wrong line number, and
the filename was off as you fixed up in your patch.

> followed by the usual verbose error message instead of one-per-line as I
> assume the --emacs option is supposed to produce:
> 
> :2823: WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> #2823: FILE: namei.c:2820:
> +EXPORT_SYMBOL(vfs_mkdir);
> 
> BTW, calling the option --emacs is a bit too restrictive.  Emacs didn't
> invent the format of "filename:linenumeber:message".  C compilers had it
> before.  Even "grep -n *" had it before.  That's why I think calling it a
> "terse output" option may be more accurate.
> 
> The following small patch to checkpath.pl-next seems to fix the perl
> warnings, but it still outputs the long error messages along with the
> shorter one-liners.

As I understand things this is called emacs mode because the emacs
buffer mode expects the filename:line:message format with the long error
to follow.  It seems pretty emacs specific.  So for now I'll leave it
named that.  If people convince me its --compiler-format or something we
can add that as an alias later.

I have hopefully sorted the main problems with it and will push out an
update for testing.

-apw
