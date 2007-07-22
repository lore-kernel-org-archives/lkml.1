Return-Path: <linux-kernel-owner+w=401wt.eu-S1759092AbXGVCjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759092AbXGVCjg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 22:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbXGVCj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 22:39:29 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:50125 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750909AbXGVCj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 22:39:28 -0400
Message-ID: <385071955.09308@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sun, 22 Jul 2007 10:39:23 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Tim Pepper <lnxninja@us.ibm.com>,
       Chris Snook <csnook@redhat.com>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 0/3] readahead drop behind and size adjustment
Message-ID: <20070722023923.GA6438@mail.ustc.edu.cn>
Mail-Followup-To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
	linux-kernel <linux-kernel@vger.kernel.org>, riel <riel@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Tim Pepper <lnxninja@us.ibm.com>, Chris Snook <csnook@redhat.com>,
	Dave Jones <davej@redhat.com>
References: <20070721210005.000228000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070721210005.000228000@chello.nl>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2007 at 11:00:05PM +0200, Peter Zijlstra wrote:
> The various readahead bits I have lying about.
> 
> Wu, would you agree with asking Andrew to stick these behind your latest
> readahead series?

They are generally good feature to have. Thank you!

- default readahead size

It makes sense to raise it beyond 128K.  1M default readahead
absolutely makes sense for sequential workloads.  For the desktop,
this increases boot speed and readahead misses, both due to more
aggressive mmap read-around. Most users will be glad to feel the
speedup, and happily ignore the readahead misses, which may be
"invisible" in case of large memory.

In theory, the distributions can do the same tuning.  So we have an
interesting question for Dave:
        Does fedora desktop raise the default readahead size? Why or
        why not?  It goes so far to do userland readahead ;)


- drop behind

Sorry, I still doubt it will benefit all/most workloads. Leave it off
by default, and leave the enabling decision to Dave? I do hope that
it help general desktops.

