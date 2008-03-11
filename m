Return-Path: <linux-kernel-owner+w=401wt.eu-S1756539AbYCKU6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539AbYCKU6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 16:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbYCKU6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 16:58:32 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:42424 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbYCKU6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 16:58:31 -0400
Date: Tue, 11 Mar 2008 14:00:12 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: P6 NOPs again: MPSC?
In-Reply-To: <47D62A0D.3070107@zytor.com>
Message-ID: <Pine.LNX.4.64.0803111346150.22181@blonde.site>
References: <Pine.LNX.4.64.0803041929230.14934@blonde.site>
 <20080304210111.GB31546@elte.hu> <47CDBE09.3060000@zytor.com>
 <Pine.LNX.4.64.0803101853090.15511@blonde.site> <47D59743.7040709@zytor.com>
 <Pine.LNX.4.64.0803102142440.2464@blonde.site> <47D62A0D.3070107@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2008, H. Peter Anvin wrote:
> Hugh Dickins wrote:
> > 
> > Yup, I realized that (with || in place of &&): I meant that perhaps
> > it was supposed to say X86_64 || (!X86_GENERIC && (M686 || ....))
> > since quite a lot of other options there have "|| X86_64" to cover
> > all the 64-bit possibilities at once i.e. is it only MPSC that
> > needs to be added, or both MPSC and CPU_GENERIC?
> 
> No.  The left-hand clause (X86_64 || !X86_GENERIC) indicates when using these
> NOPs are *permitted*; the right-hand clause indicates when doing so is
> *desirable*.  The latter isn't, for example, for K8, even on 64 bits.

Okay, so if we're to exclude CPU_GENERIC and MK8, I think that
makes my original patch the right one: here it is with a signoff.


I've now noticed that the machine I call MPENTIUM4 for 32-bit kernels
is called MPSC for 64-bit kernels, and in that case it still doesn't
get the P6 NOPs it ought to.  hpa explains that MK8 should still be
excluded, so it's just a matter of including MPSC along with MPENTIUM4.

Signed-off-by: Hugh Dickins <hugh@veritas.com>

--- 2.6.25-rc5/arch/x86/Kconfig.cpu	2008-03-05 11:27:23.000000000 +0000
+++ linux/arch/x86/Kconfig.cpu	2008-03-10 18:48:10.000000000 +0000
@@ -388,7 +388,7 @@ config X86_OOSTORE
 #
 config X86_P6_NOP
 	def_bool y
-	depends on (X86_64 || !X86_GENERIC) && (M686 || MPENTIUMII || MPENTIUMIII || MPENTIUMM || MCORE2 || MPENTIUM4)
+	depends on (X86_64 || !X86_GENERIC) && (M686 || MPENTIUMII || MPENTIUMIII || MPENTIUMM || MCORE2 || MPENTIUM4 || MPSC)
 
 config X86_TSC
 	def_bool y


