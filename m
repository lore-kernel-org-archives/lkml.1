Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbYBWMzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbYBWMzn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 07:55:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbYBWMzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 07:55:36 -0500
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:43935 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbYBWMzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 07:55:35 -0500
Message-ID: <47C017C4.20209@weinigel.se>
Date: Sat, 23 Feb 2008 13:55:32 +0100
From: Christer Weinigel <christer@weinigel.se>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: [RFC/PATCH] Update coding standard to avoid ungrepable printk
 format strings
References: <20080222132612.GA11717@basil.nowhere.org>
In-Reply-To: <20080222132612.GA11717@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> RFC: Update coding standard to avoid split up printk format strings

While we're talking about checkpatch.pl, I'd definitely like to teach 
checkpatch about "list_for_each" and friends.

list_for_each is flow control, not a function call.  I find it much 
easier to see that something is a loop when there is a space between the 
name and the parenthesis rather than when they are smashed together.

old patch follows

   /Christer

checkpatch complains about the following:

WARNING: no space between function name and open parenthesis '('
#520: FILE: drivers/spi/spi_s3c24xx_dma.c:478:
+       list_for_each_entry (transfer, &message->transfers, transfer_list) {

which I think is a bit bogus since it actually is a for statement in
disguise.  The following patch adds list_for_each to the list of things
that look like functions that it shouldn't complain about.

Index: linux-2.6.23/scripts/checkpatch.pl
===================================================================
--- linux-2.6.23.orig/scripts/checkpatch.pl
+++ linux-2.6.23/scripts/checkpatch.pl
@@ -681,7 +681,7 @@ sub process {

  # check for spaces between functions and their parentheses.
  		if ($line =~ /($Ident)\s+\(/ &&
-		    $1 !~ 
/^(?:if|for|while|switch|return|volatile|__volatile__|__attribute__|format|__extension__|Copyright)$/ 
&&
+		    $1 !~ 
/^(?:if|for|while|switch|list_for_each.*|return|volatile|__volatile__|__attribute__|format|__extension__|Copyright)$/ 
&&
  		    $line !~ /$Type\s+\(/ && $line !~ /^.\#\s*define\b/) {
  			WARN("no space between function name and open parenthesis '('\n" . 
$herecurr);
  		}
