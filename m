Return-Path: <linux-kernel-owner+w=401wt.eu-S1764098AbZDAQ5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764098AbZDAQ5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 12:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756762AbZDAQ5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 12:57:44 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:41091 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753791AbZDAQ5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 12:57:43 -0400
Date: Wed, 1 Apr 2009 12:57:41 -0400
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: make headers_install broken for ARCH=m68k in 2.6.29-rc7.
Message-ID: <20090401165741.GA3797@csclub.uwaterloo.ca>
References: <200903120437.03837.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903120437.03837.rob@landley.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 04:37:03AM -0500, Rob Landley wrote:
> So I'm doing this:
> 
> make ARCH=m68k headers_install INSTALL_HDR_PATH=walrus
> 
> And it doesn't install unistd_mm.h which is included from asm/unistd.h.  (The 
> file is there in arch/m68k/include/asm/unistd_mm.h, it just doesn't get 
> installed.  So any code that #includes <asm/unistd.h> results in a file not 
> found error for the other one, which is essentially just a wrapper.)
> 
> I don't understand what the code's currently doing here well enough to fix it, 
> specifically where does this file list come from?  The file  
> arch/m68k/include/asm/Kbuild is adding "cachectl.h" to header-y, but there are 
> 31 files getting installed from that directory and only one in there.  If the 
> list was just the contents of the directory, then unistd_mm.h (and 
> unistd_no.h) would get installed, but they don't.  I could add those two to 
> the Kbuild file after cachectl.h, but is that the _right_ fix?  Where are the 
> other 31 identified?  (Is it getting a listing of some _other_ directory?)

I sent a patch to fix that on Feb 5th.  I guess it hasn't been put in.

It looked like this:

Signed-of-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>

diff --git a/arch/m68k/include/asm/Kbuild b/arch/m68k/include/asm/Kbuild
index 1a922fa..d477927 100644
--- a/arch/m68k/include/asm/Kbuild
+++ b/arch/m68k/include/asm/Kbuild
@@ -1,2 +1,18 @@
 include include/asm-generic/Kbuild.asm
 header-y += cachectl.h
+header-y += param_mm.h
+header-y += param_no.h
+header-y += ptrace_mm.h
+header-y += ptrace_no.h
+header-y += setup_mm.h
+header-y += setup_no.h
+header-y += sigcontext_mm.h
+header-y += sigcontext_no.h
+header-y += siginfo_mm.h
+header-y += siginfo_no.h
+header-y += signal_mm.h
+header-y += signal_no.h
+header-y += swab_mm.h
+header-y += swab_no.h
+header-y += unistd_mm.h
+header-y += unistd_no.h

-- 
Len Sorensen
