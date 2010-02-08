Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab0BHIdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 03:33:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751066Ab0BHIdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 03:33:40 -0500
Date: Mon, 8 Feb 2010 00:32:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] sched: Fix unused variable warning on UP (was: Re: 
 linux-next: tip tree build warning)
Message-Id: <20100208003241.1155a7e5.akpm@linux-foundation.org>
In-Reply-To: <10f740e81002071231j6977c6c7ie3f9e82bd0170f21@mail.gmail.com>
References: <10f740e81002071157p11b78784i8091d4790c29f30d@mail.gmail.com>
	<1265572738.12224.278.camel@laptop>
	<10f740e81002071226g3290d276q4c9df0e79a1e7ac0@mail.gmail.com>
	<10f740e81002071231j6977c6c7ie3f9e82bd0170f21@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Feb 2010 21:31:56 +0100 Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> Shouldn't put_cpu() take a (possibly dummy) `cpu' parameter, as
> returned by get_cpu()?

Yeah, that always seemed a bit screwy.  Something like this...

--- a/include/linux/smp.h~a
+++ a/include/linux/smp.h
@@ -177,6 +177,15 @@ smp_call_function_any(const struct cpuma
 #define put_cpu()		preempt_enable()
 
 /*
+ * This just exists to touch the `cpu' arg, to suppress unused var
+ * warnings
+ */
+static inline void put_cpu_nr(unsigned cpu)
+{
+	put_cpu();
+}
+
+/*
  * Callback to arch code if there's nosmp or maxcpus=0 on the
  * boot command line:
  */
_

