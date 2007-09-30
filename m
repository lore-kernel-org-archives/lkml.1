Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbXI3EB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbXI3EB1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 00:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750813AbXI3EBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 00:01:19 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:38502 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbXI3EBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 00:01:19 -0400
Date: Sun, 30 Sep 2007 00:01:10 -0400
Message-Id: <200709300401.l8U41AhY024890@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 0/3 coding standards documentation/code updates 
In-reply-to: Your message of "Sat, 29 Sep 2007 17:49:12 PDT."
             <alpine.LFD.0.999.0709291748160.3579@woody.linux-foundation.org> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <alpine.LFD.0.999.0709291748160.3579@woody.linux-foundation.org>, Linus Torvalds writes:
> 
> 
> On Sat, 29 Sep 2007, Erez Zadok wrote:
> > 
> > Would you prefer if CodingStyle was reorganized or even split into (1)
> > general principles and (2) details?  Perhaps we need a CodingStylePrinciples
> > and a CodingStyleDetails?
> 
> I'm certainly ok with the split into two files.
> 
> What I'm not ok with is really important stuff (indentation), and then 
> mixing in silly rules ("parenthesis are bad in printk's"?)
> 
> 		Linus

OK, looking at CodingStyle, I see two kinds of chapters.  The first is stuff
that's more generic to C, and the other is more specific to Linux and how
one codes in the linux kernel.  So I propose the following:

1. we create a new file called CodingSuggestions

2. we keep in CodingStyle the following chapters

   Chapter 1: Indentation
   Chapter 2: Breaking long lines and strings
   Chapter 3: Placing Braces and Spaces
   Chapter 4: Naming
   Chapter 5: Typedefs
   Chapter 6: Functions
   Chapter 7: Centralized exiting of functions
   Chapter 8: Commenting
   Chapter 9: You've made a mess of it

   Note: I'd suggest we rename the title of ch9 to "Custom Editor
   Programming/Indentation Modes" or something more descriptive.

   Chapter 10: Kconfig configuration files
   Chapter 11: Data structures
   Chapter 12: Macros, Enums and RTL
   Chapter 15: The inline disease
   Chapter 16: Function return values and names
   Chapter 18: Editor modelines and other cruft

3. move the following chapters to CodingSuggestions:

   Chapter 13: Printing kernel messages
   Note: ch13 is the one which mentions the don't put parentheses around %d.

   Chapter 14: Allocating memory
   Chapter 17: Don't re-invent the kernel macros
   Chapter 19: branch prediction optimizations (the un/likely debacle)

4. We go through checkpatch.pl and ensure that every test in checkpatch is
   documented either in CodingStyle or in CodingSuggestions, determined by
   whether checkpatch considers it an ERROR, WARNING, or just CHECK.

I think the above chapter split will be a reasonable start, and of course we
can tweak things over time.  The general idea is that CodingStyle will
remain largely unchanged (until such day as the kernel is rewritten in Java
:-), while CodingSuggestions will evolve over time and be kept in sync with
checkpatch.


But, there's something really nice abuot having to point people to just one
file instead of two.  We could also keep it all in one file, but split it
into two parts:

   Part 1: Mandatory Coding Style
   Chapter 1: indentation
   ...

   Part 2: Coding Style Suggestions
   Chapter n: printing kernel messages
   ...

Erez.
