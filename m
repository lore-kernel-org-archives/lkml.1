Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230AbYJNSrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbYJNSrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 14:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbYJNSrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 14:47:36 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:39883 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbYJNSrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 14:47:36 -0400
Date: Tue, 14 Oct 2008 12:47:19 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, ying.huang@intel.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de
Subject: Re: [PATCH -mm -v5] Separate atomic_t declaration from asm/atomic.h into asm/atomic_def.h
Message-ID: <20081014184718.GG15064@parisc-linux.org>
References: <1223459070.5872.167.camel@yhuang-dev.sh.intel.com> <20081010144335.65d8153b.akpm@linux-foundation.org> <20081010214958.GA7708@elte.hu> <20081010155450.094288b4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010155450.094288b4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 03:54:50PM -0700, Andrew Morton wrote:
> I have a note here that Matthew has proposed a different way of doing
> all this.  I don't immediately recall the details.
> 
> Can we get a refresh on all of that please?

I didn't remember either, but having just reviewed my inbox from August,
I said that all architectures basically use:

typedef struct { volatile int counter; } atomic_t;
#ifdef CONFIG_64BIT
typedef struct { volatile long counter; } atomic64_t;
#endif

and that should just be put in <linux/atomic_types.h>.

Roman Zippel did me one better and suggested just putting it in types.h,
which works for me.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
