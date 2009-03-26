Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbZCZEP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbZCZEP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 00:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbZCZEPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 00:15:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:38855 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbZCZEPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 00:15:09 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Strange code in include/linux/cpumask.h
Date: Thu, 26 Mar 2009 09:42:39 +0530
User-Agent: KMail/1.10.3 (Linux/2.6.27.19-3.2-default; KDE/4.1.3; x86_64; ; )
Cc: nikanth@gmail.com, linux-kernel@vger.kernel.org
References: <200903251021.13811.knikanth@novell.com> <200903251214.31731.knikanth@novell.com> <200903260914.46958.rusty@rustcorp.com.au>
In-Reply-To: <200903260914.46958.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903260942.40309.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 March 2009 04:14:46 Rusty Russell wrote:
> On Wednesday 25 March 2009 17:14:30 Nikanth Karthikesan wrote:
> > On Wednesday 25 March 2009 10:41:11 Rusty Russell wrote:
> > > Yes, except that this insists that bitmap be an unsigned long * or
> > > you'll get a warning.  Otherwise the macro could be used on anything. 
> > > And it needs to be a macro to use it as a static initializer.
> >
> > Ah, got it. Thanks a lot for the explanation. May be a comment could be
> > added to the source.
>
> Well, it's not that unusual a trick in the kernel, but an explanation might
> help.
>

I _assumed_ that kernel developers are good programmers who do not need type
enforcements/warnings. And tricky code for non-performance optimizations wont
be allowed. Yes, this is not very tricky once you are aware that such tricks
are done in the kernel just for type-safety. Anyway lets document it.

Thanks
Nikanth


Add a comment explaining the purpose of the tricky code in the macro
to_cpumask(). The __check_is_bitmap() is used to enforce type-safety.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 9f31538..32b802b 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -279,6 +279,7 @@ static inline void __cpus_shift_left(cpumask_t *dstp,
  * expose the definition of 'struct cpumask'.
  *
  * This does the conversion, and can be used as a constant initializer.
+ * __check_is_bitmap() enforces bitmap to be an 'unsigned long *'.
  */
 #define to_cpumask(bitmap)						\
 	((struct cpumask *)(1 ? (bitmap)				\

