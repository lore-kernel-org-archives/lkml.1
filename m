Return-Path: <linux-kernel-owner+w=401wt.eu-S933895AbYBVNxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933895AbYBVNxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 08:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759178AbYBVNxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 08:53:13 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:56222 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756993AbYBVNxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 08:53:12 -0500
Message-ID: <47BED3C3.5020500@s5r6.in-berlin.de>
Date: Fri, 22 Feb 2008 14:53:07 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: [RFC/PATCH] Update coding standard to avoid ungrepable printk
 format strings
References: <20080222132612.GA11717@basil.nowhere.org>
In-Reply-To: <20080222132612.GA11717@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> --- linux.orig/Documentation/CodingStyle
> +++ linux/Documentation/CodingStyle
> @@ -83,20 +83,32 @@ preferred limit.
>  Statements longer than 80 columns will be broken into sensible chunks.
>  Descendants are always substantially shorter than the parent and are placed
>  substantially to the right. The same applies to function headers with a long
> -argument list. Long strings are as well broken into shorter strings. The
> -only exception to this is where exceeding 80 columns significantly increases
> -readability and does not hide information.
> +argument list.
>  
> -void fun(int a, int b, int c)
> -{
> -	if (condition)
> -		printk(KERN_WARNING "Warning this is a long printk with "
> -						"3 parameters a: %u b: %u "
> -						"c: %u \n", a, b, c);
> -	else
> -		next_statement;
> +It is not recommended to break printk format strings into smaller strings.

Instead of a new recommendation (from now on we recommend something
contrary to what we required up until yesterday --- let's go unwrap
strings everywhere in the kernel now), how about simply saying that
printk format strings are not subject to the 80 column rule?
Or keep the old text and insert after "increases readability":  "or
helps full-text searching".  And delete the example code.

> +The problem with doing this is that it makes it much harder to grep
> +for the error messages in the source if they are split up over multiple
> +lines. And grepping for error messages is fairly important for debugging.
> +So for the special case of printk format strings (or formatting any other
> +user visible error message) the normal 80 character column rule
> +does not apply. Or alternatively it is ok to violate the indentation
> +rule for the format string only if that makes the end not exceed
> +80 characters. For example
> +
> +void function(void)
> +{
> +	if (...) {
> +		if (...) {
> +			printk(
> + "very very long formatting string with argument %d and argument %d\n",
> +				a, b);
> +		}
> +	}
>  }

Here is one vote against this indentation exception.

PS:  Could someone implement this for checkpatch.pl:

	WARN_ON(hunk_is_in("Documentation/CodingStyle") &&
		lines_added > lines_removed);
-- 
Stefan Richter
-=====-==--- --=- =-==-
http://arcgraph.de/sr/
