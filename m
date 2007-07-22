Return-Path: <linux-kernel-owner+w=401wt.eu-S1761060AbXGVIKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761060AbXGVIKc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 04:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbXGVIKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 04:10:16 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:39869 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750993AbXGVIKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 04:10:12 -0400
Message-ID: <385091802.23116@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sun, 22 Jul 2007 16:10:10 +0800
From: Fengguang Wu <fengguang.wu@gmail.com>
To: Dave Jones <davej@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>, riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Tim Pepper <lnxninja@us.ibm.com>,
       Chris Snook <csnook@redhat.com>
Subject: Re: [PATCH 0/3] readahead drop behind and size adjustment
Message-ID: <20070722081010.GA6317@mail.ustc.edu.cn>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	linux-kernel <linux-kernel@vger.kernel.org>, riel <riel@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Tim Pepper <lnxninja@us.ibm.com>, Chris Snook <csnook@redhat.com>
References: <20070721210005.000228000@chello.nl> <20070722023923.GA6438@mail.ustc.edu.cn> <20070722024428.GA724@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070722024428.GA724@redhat.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2007 at 10:44:28PM -0400, Dave Jones wrote:
> On Sun, Jul 22, 2007 at 10:39:23AM +0800, Fengguang Wu wrote:
>  
>  > It makes sense to raise it beyond 128K.  1M default readahead
>  > absolutely makes sense for sequential workloads.  For the desktop,
>  > this increases boot speed and readahead misses, both due to more
>  > aggressive mmap read-around. Most users will be glad to feel the
>  > speedup, and happily ignore the readahead misses, which may be
>  > "invisible" in case of large memory.
>  > 
>  > In theory, the distributions can do the same tuning.  So we have an
>  > interesting question for Dave:
>  >         Does fedora desktop raise the default readahead size? Why or
>  >         why not?  It goes so far to do userland readahead ;)
>  
> Fedora takes whatever defaults for readahead the kernel.org kernel has.
> The only reasoning being if anyone reported VM bugs, we'd be able
> to say to interested upstream developers "we're running the stock VM".
> without having to get the user to try and reproduce on unpatched
> kernels.

Thank you.  Now I'm more confident that the kernel should have a
reasonable default readahead size. The current one is 5+ years old and
should be updated now.

>  > - drop behind
>  > 
>  > Sorry, I still doubt it will benefit all/most workloads. Leave it off
>  > by default, and leave the enabling decision to Dave? I do hope that
>  > it help general desktops.
> 
> It's not a subject that I'm intimatly familiar with, and when it
> comes to decisions like this, I tend to just take whatever the
> upstream defaults are.

- It will avoid large-file-reads-thrashing-my-desktop problem,
  so most desktop users should like it. But sure there will be counter
  cases when a user want to keep the data cached.
- File servers may hurt from it. Imagine a mp3/png file server. The
  files are large enough to trigger drop-behind, but small (and hot)
  enough to be cached. Also when a new fedora DVD iso is released, it
  may be cached for some days. These are only the obvious cases.

So I opt for it being made tunable, safe, and turned off by default.

