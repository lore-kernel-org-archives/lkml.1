Return-Path: <linux-kernel-owner+w=401wt.eu-S1755076AbZEYK2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076AbZEYK2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 06:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbZEYK2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 06:28:17 -0400
Received: from ozlabs.org ([203.10.76.45]:43820 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141AbZEYK2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 06:28:16 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/3] kernel.h: Add DO_ONCE statement expression macro
Date: Mon, 25 May 2009 16:15:07 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
       Dave Jones <davej@redhat.com>, "Greg Kroah-Hartman" <gregkh@suse.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       x86@vger.kernel.org, Len Brown <len.brown@intel.com>,
       Mike Travis <travis@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
References: <cover.1242943463.git.joe@perches.com> <7b063fda0675875d51a5da49f59e89520d025eee.1242943463.git.joe@perches.com>
In-Reply-To: <7b063fda0675875d51a5da49f59e89520d025eee.1242943463.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905251615.08414.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 May 2009 08:30:22 am Joe Perches wrote:
> Add a DO_ONCE statement expression analogous to printk_once
> that executes any arbitrary statement exactly once.
>
> This will take the place of printk_once so that
> DO_ONCE(pr_<foo>) or any other statement performed
> a single time may be easily written.

If you're going to use a statement expression, was the intent to make
it usable for a test?  If so, you want something vaguely like:

#define DO_ONCE(x...) ({			\
	static bool __done = false;		\
	bool did = !__done;			\
	if (!__done) {				\
		x;				\
		__done = true;			\
	}					\
	did;					\
})

Otherwise, why not just use a normal do {} while (0) ?

Anyway, statements in macros leave me uncomfortable. I prefer explicit
ONCE() macro which can be tested.

Cheers,
Rusty.
