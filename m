Return-Path: <linux-kernel-owner+w=401wt.eu-S1752923AbYBDLVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbYBDLVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 06:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751296AbYBDLVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 06:21:35 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:2279 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbYBDLVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 06:21:34 -0500
Date: Mon, 4 Feb 2008 11:22:03 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Timur Tabi <timur@freescale.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: add __asm__ to function-space-paren exception list
Message-ID: <20080204112203.GA19879@shadowen.org>
References: <12016486482483-git-send-email-timur@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12016486482483-git-send-email-timur@freescale.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 05:17:28PM -0600, Timur Tabi wrote:
> checkpatch.pl thinks that __asm__ is a function name, so it complains about
> a space between the function name and a parenthesis when it sees
> "__asm__ ("mov ax,bx")".
> 
> This change will also encourage developers to use '__asm__' instead of 'asm'.
> 
> Signed-off-by: Timur Tabi <timur@freescale.com>
> ---
>  scripts/checkpatch.pl |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 579f50f..971c822 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1115,7 +1115,7 @@ sub process {
>  
>  # check for spaces between functions and their parentheses.
>  		while ($line =~ /($Ident)\s+\(/g) {
> -			if ($1 !~ /^(?:if|for|while|switch|return|volatile|__volatile__|__attribute__|format|__extension__|Copyright|case)$/ &&
> +			if ($1 !~ /^(?:if|for|while|switch|return|volatile|__volatile__|__attribute__|format|__extension__|Copyright|case|__asm__)$/ &&
>  		            $line !~ /$Type\s+\(/ && $line !~ /^.\#\s*define\b/) {
>  				WARN("no space between function name and open parenthesis '('\n" . $herecurr);
>  			}
> -- 

It truly is not clear what "type" of thing an __asm__ is these days.
Cirtainly it seems we can use it as an attribute of a type:

        register unsigned long __r16 __asm__("$16") = rtc_access->function;

and yet also in its more traditional form:

	__asm__("	call foo");

The latter form feels like a function?  But cirtainly in the examples it
is shown with a space some of the time, and not others.  Is __asm__ an
attribute of the null function (;) in this context or ... well ?

This patch really just removes any checks for spacing on __asm__ do we
have a preferred style for these?  Attributes do seem to have spaces,
though in their most attribute like usage the __asm__ "attribute" does
not seem to be used with a space, so far anyhow.

Oh and why are we preferring the use of __asm__ over asm?  They both
seem valid.  Should we be recommending one over the other?

-apw
