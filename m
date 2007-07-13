Return-Path: <linux-kernel-owner+w=401wt.eu-S935864AbXGMHA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935864AbXGMHA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 03:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755788AbXGMHAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 03:00:22 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:21300 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752134AbXGMHAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 03:00:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=f9JsWGtv2cCVtt1gORxrqgWAfV3T7vs6rJ7MIoANLinlTl3gOiJ3SpAjNayijogR18iyCCo4jzLMyPSTrp7QEbBIWpjEtuLypZ8RA5MX8gce9Tj9OJdoLwUsl7zdBvZ1F6Ctyxj4d3c3w3PxM3l1m+x6vJJ2ya89m1mEX2MU+IU=  ;
X-YMail-OSG: P3nZ8uUVM1mMCQ5x7gEVVG_yxKoKnOjTdJOVur1mMQSbH2g4RmkZZxOTEM8t7mEH9mkflbLN6GxphtldfCpY8J6GfgDuuN3rwUJ8FOimxEt1gN8CmQ--
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2.6.22-git] dev_vdbg(), available with -DVERBOSE_DEBUG
Date: Fri, 13 Jul 2007 00:00:16 -0700
User-Agent: KMail/1.9.6
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Alan Stern <stern@rowland.harvard.edu>
References: <200707122030.49465.david-b@pacbell.net> <20070712220734.d98a43f1.akpm@linux-foundation.org>
In-Reply-To: <20070712220734.d98a43f1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707130000.17125.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 July 2007, Andrew Morton wrote:
> On Thu, 12 Jul 2007 20:30:49 -0700 David Brownell <david-b@pacbell.net> wrote:
> 
> > This defines a dev_vdbg() call, which is enabled with -DVERBOSE_DEBUG.
> > When enabled, dev_vdbg() acts just like dev_dbg().  When disabled, it
> > is a NOP ... just like dev_dbg() without -DDEBUG.  The specific code
> > was moved out of a USB patch, but lots of drivers have similar support.
> 
> I suppose we should find some way of telling people about this.  Maybe
> in the `make help' output?

Whereever people learn about "-DDEBUG", they should probably
be able to learn about "-DVERBOSE_DEBUG".  Which is likely
from existing kernel code (although most C coders will expect
that "-DDEBUG" does *something* interesting).

I suspect maybe Documentation/CodingStyle would be better..

- Dave

====	CUT HERE
Update CodingStyle to talk about "-DDEBUG" message conventions and the
new "-DVERBOSE_DEBUG" convention.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 Documentation/CodingStyle |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- g26.orig/Documentation/CodingStyle	2007-07-12 23:03:25.000000000 -0700
+++ g26/Documentation/CodingStyle	2007-07-12 23:53:52.000000000 -0700
@@ -621,12 +621,27 @@ covers RTL which is used frequently with
 
 Kernel developers like to be seen as literate. Do mind the spelling
 of kernel messages to make a good impression. Do not use crippled
-words like "dont" and use "do not" or "don't" instead.
+words like "dont"; use "do not" or "don't" instead.  Make the messages
+concise, clear, and unambiguous.
 
 Kernel messages do not have to be terminated with a period.
 
 Printing numbers in parentheses (%d) adds no value and should be avoided.
 
+There are a number of driver model diagnostic macros in <linux/device.h>
+which you should use to make sure messages are matched to the right device
+and driver, and are tagged with the right level:  dev_err(), dev_warn(),
+dev_info(), and so forth.  For messages that aren't associated with a
+particular device, <linux/kernel.h> defines pr_debug() and pr_info().
+
+Coming up with good debugging messages can be quite a challenge; and once
+you have them, they can be a huge help for remote troubleshooting.  Such
+messages should be compiled out when the DEBUG symbol is not defined (that
+is, by default they are not included).  When you use dev_dbg() or pr_debug(),
+that's automatic.  Many subsystems have Kconfig options to turn on -DDEBUG.
+A related convention uses VERBOSE_DEBUG to add dev_vdbg() messages to the
+ones already enabled by DEBUG.
+
 
 		Chapter 14: Allocating memory
 
@@ -751,4 +766,5 @@ Kernel CodingStyle, by greg@kroah.com at
 http://www.kroah.com/linux/talks/ols_2002_kernel_codingstyle_talk/html/
 
 --
-Last updated on 2006-December-06.
+Last updated on 2007-July-13.
+

