Return-Path: <linux-kernel-owner+w=401wt.eu-S1756567AbYBYF2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbYBYF2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 00:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbYBYF2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 00:28:33 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:1596 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbYBYF2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 00:28:32 -0500
Date: Mon, 25 Feb 2008 05:29:25 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Christer Weinigel <christer@weinigel.se>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org
Subject: Re: [RFC/PATCH] Update coding standard to avoid ungrepable printk format strings
Message-ID: <20080225052925.GA2604@shadowen.org>
References: <20080222132612.GA11717@basil.nowhere.org> <47C017C4.20209@weinigel.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C017C4.20209@weinigel.se>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 01:55:32PM +0100, Christer Weinigel wrote:
> Andi Kleen wrote:
> >RFC: Update coding standard to avoid split up printk format strings
> 
> While we're talking about checkpatch.pl, I'd definitely like to teach 
> checkpatch about "list_for_each" and friends.
> 
> list_for_each is flow control, not a function call.  I find it much 
> easier to see that something is a loop when there is a space between the 
> name and the parenthesis rather than when they are smashed together.
> 
> old patch follows
> 
>   /Christer
> 
> checkpatch complains about the following:
> 
> WARNING: no space between function name and open parenthesis '('
> #520: FILE: drivers/spi/spi_s3c24xx_dma.c:478:
> +       list_for_each_entry (transfer, &message->transfers, transfer_list) {
> 
> which I think is a bit bogus since it actually is a for statement in
> disguise.  The following patch adds list_for_each to the list of things
> that look like functions that it shouldn't complain about.
> 
> Index: linux-2.6.23/scripts/checkpatch.pl
> ===================================================================
> --- linux-2.6.23.orig/scripts/checkpatch.pl
> +++ linux-2.6.23/scripts/checkpatch.pl
> @@ -681,7 +681,7 @@ sub process {
> 
>  # check for spaces between functions and their parentheses.
>  		if ($line =~ /($Ident)\s+\(/ &&
> -		    $1 !~ 
> /^(?:if|for|while|switch|return|volatile|__volatile__|__attribute__|format|__extension__|Copyright)$/ 
> &&
> +		    $1 !~ 
> /^(?:if|for|while|switch|list_for_each.*|return|volatile|__volatile__|__attribute__|format|__extension__|Copyright)$/ 
> &&
>  		    $line !~ /$Type\s+\(/ && $line !~ /^.\#\s*define\b/) {
>  			WARN("no space between function name and open 
>  			parenthesis '('\n" . $herecurr);
>  		}

This has come up a few times.  In previous discussions there were
supporters for spaces as well as not.  Looking over the existing in kernel
use, the majority are without a space (from before checkpatch encouraged
that usage); and so it is that that won the day.

-apw
