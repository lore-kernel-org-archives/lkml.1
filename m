Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbZDUThU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbZDUThU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 15:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbZDUThG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 15:37:06 -0400
Received: from vena.lwn.net ([206.168.112.25]:44496 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266AbZDUThF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 15:37:05 -0400
Date: Tue, 21 Apr 2009 13:37:01 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>, Theodore Tso <tytso@mit.edu>
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
Message-ID: <20090421133701.5b1cd303@bike.lwn.net>
In-Reply-To: <200904201744.22572.rusty@rustcorp.com.au>
References: <200904140159.n3E1x1K1014705@hera.kernel.org>
	<200904161130.28129.rusty@rustcorp.com.au>
	<20090416075541.527b8f85@bike.lwn.net>
	<200904201744.22572.rusty@rustcorp.com.au>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Apr 2009 17:44:21 +0930
Rusty Russell <rusty@rustcorp.com.au> wrote:

> There are several readers: someone reviewing the patch, someone looking
> for a specific bug, someone backporting, someone dealing with an API change,
> someone bisecting. 

With this in mind, I've tried to make a relatively concise addition to
the development process document.  How does the following look?

jon

--

>From c67584ac4f8fcad9f577e5ca9f73496ef99df63a Mon Sep 17 00:00:00 2001
From: Jonathan Corbet <corbet@lwn.net>
Date: Tue, 21 Apr 2009 13:33:06 -0600
Subject: [PATCH] docs: Encourage better changelogs in the development process document

Add a couple of paragraphs to the "patch formatting" section on how patches
should be described.  This text is shamelessly cribbed from suggestions
posted by Rusty Russell.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 Documentation/development-process/5.Posting |   31 ++++++++++++++++++++++++--
 1 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/Documentation/development-process/5.Posting b/Documentation/development-process/5.Posting
index dd48132..f622c1e 100644
--- a/Documentation/development-process/5.Posting
+++ b/Documentation/development-process/5.Posting
@@ -119,7 +119,7 @@ which takes quite a bit of time and thought after the "real work" has been
 done.  When done properly, though, it is time well spent.
 
 
-5.4: PATCH FORMATTING
+5.4: PATCH FORMATTING AND CHANGELOGS
 
 So now you have a perfect series of patches for posting, but the work is
 not done quite yet.  Each patch needs to be formatted into a message which
@@ -146,8 +146,33 @@ that end, each patch will be composed of the following:
  - One or more tag lines, with, at a minimum, one Signed-off-by: line from
    the author of the patch.  Tags will be described in more detail below.
 
-The above three items should, normally, be the text used when committing
-the change to a revision control system.  They are followed by:
+The items above, together, form the changelog for the patch.  Writing good
+changelogs is a crucial but often-neglected art; it's worth spending
+another moment discussing this issue.  When writing a changelog, you should
+bear in mind that a number of different people will be reading your words.
+These include subsystem maintainers and reviewers who need to decide
+whether the patch should be included, distributors and other maintainers
+trying to decide whether a patch should be backported to other kernels, bug
+hunters wondering whether the patch is responsible for a problem they are
+chasing, users who want to know how the kernel has changed, and more.  A
+good changelog conveys the needed information to all of these people in the
+most direct and concise way possible.
+
+To that end, the summary line should describe the effects of and motivation
+for the change as well as possible given the one-line constraint.  The
+detailed description can then amplify on those topics and provide any
+needed additional information.  If the patch fixes a bug, cite the commit
+which introduced the bug if possible.  If a problem is associated with
+specific log or compiler output, include that output to help others
+searching for a solution to the same problem.  If the change is meant to
+support other changes coming in later patch, say so.  If internal APIs are
+changed, detail those changes and how other developers should respond.  In
+general, the more you can put yourself into the shoes of everybody who will
+be reading your changelog, the better that changelog (and the kernel as a
+whole) will be.
+
+Needless to say, the changelog should be the text used when committing the
+change to a revision control system.  It will be followed by:
 
  - The patch itself, in the unified ("-u") patch format.  Using the "-p"
    option to diff will associate function names with changes, making the
-- 
1.6.2.2

