Return-Path: <linux-kernel-owner+w=401wt.eu-S1755571AbYJXLuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbYJXLuX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 07:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbYJXLuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 07:50:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55739 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbYJXLuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 07:50:08 -0400
Date: Fri, 24 Oct 2008 13:50:10 +0200
From: Andi Kleen <andi@firstfloor.org>
To: apw@shadowen.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Handle space after for_each_* macros gracefully in checkpatch
Message-ID: <20081024115010.GA31761@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle space after for_each_* macros gracefully in checkpatch.pl

Anyone else seeing the irony of checkpatch.pl recommending to 
use for_each_cpu_mask, but then not actually parsing it
correctly.

When you write 

	for_each_cpu_mask (...) { 

it would complain about the space between mask and the open bracket
because it thinks it's a normal function call.

Fix this in a generic way. In theory someone could construct
a normal function that starts with for_each_* and it would
not warn, but I think that would be uncommon. The alternative
of listing all macros was tried first, but turned out to 
be unwieldly.

I think I covered most of the common ones available, the
only exceptions are a few oddballs with leading prefix 
like pnp_for_each* or zorro_for_each.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.27-misc/scripts/checkpatch.pl
===================================================================
--- linux-2.6.27-misc.orig/scripts/checkpatch.pl
+++ linux-2.6.27-misc/scripts/checkpatch.pl
@@ -1513,6 +1513,7 @@ sub process {
 				if|for|while|switch|return|case|
 				volatile|__volatile__|
 				__attribute__|format|__extension__|
+				([ph]?list_)?for_each_[a-z_]+|
 				asm|__asm__)$/x)
 			{
 
