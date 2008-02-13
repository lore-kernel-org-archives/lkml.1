Return-Path: <linux-kernel-owner+w=401wt.eu-S1762937AbYBMSPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762937AbYBMSPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 13:15:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbYBMSP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 13:15:28 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:33939
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbYBMSP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 13:15:27 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: linux-kernel@vger.kernel.org
Subject: No, you do NOT already need perl to build the kernel!
Date: Wed, 13 Feb 2008 12:15:22 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: torvalds@linux-foundation.org, hpa@zytor.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802131215.23297.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please revert commit bdc807871d58285737d50dc6163d0feb72cb0dc2 because it's 
based on a false assumption:

>     At Ralf Baechle's suggestion, this version uses a Perl script to
> compute the necessary constants.  We already have dependencies on Perl for
> kernel compiles.

You do NOT need perl to build the kernel.  Perl is used in various debugging 
tools for stack checking and stuff (just like python is used in 
bloat-o-meter).  But perl is NOT required to compile the kernel, and never 
has been.  Not on x86, x86-64, arm, mips, powerpc, super hitachi, or sparc.  
(Haven't personally tested the others recently.)

I submitted a patch to _remove_ a perl dependency from the User Mode Linux 
build back in 2005.  (During the bitkeeper days, although git 
b05d85a87d9711f5f5f2eb05c79038d5d5ff1f44 updated said patch to work with 
older versions of sed).

Please don't reintroduce this.  I can recompile a system from source code 
under itself with only seven packages (linux, uClibc, busybox, gcc, binutils, 
make, bash), meaning that's the minimal environment I have to bootstrap on a 
new hardware platform in order to be able to compile my way up to a full 
distro in a self-hosting manner.  Adding perl to that would _double_ the 
complexity.  (Getting perl to cross compile requires involves medieval 
torture implements and several lewd acts with a chicken, and that's just for 
microperl...)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
