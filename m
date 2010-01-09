Return-Path: <linux-kernel-owner+w=401wt.eu-S1753950Ab0AINeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab0AINeI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 08:34:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410Ab0AINeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 08:34:07 -0500
Received: from mga01.intel.com ([192.55.52.88]:36576 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853Ab0AINeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 08:34:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,246,1262592000"; 
   d="scan'208";a="529869597"
Date: Sat, 9 Jan 2010 21:33:42 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>, Eric Paris <eparis@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] fs: O_* bit numbers uniqueness check
Message-ID: <20100109133342.GB20015@localhost>
References: <20100106065526.GB11368@localhost> <4B443695.5090301@gmail.com> <20100106072029.GA25169@localhost> <m2iqbfwq7h.fsf@whitebox.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m2iqbfwq7h.fsf@whitebox.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 05:13:54PM +0800, Andreas Schwab wrote:
> Wu Fengguang <fengguang.wu@intel.com> writes:
> 
> > On Wed, Jan 06, 2010 at 03:07:01PM +0800, Eric Dumazet wrote:
> >> Le 06/01/2010 07:55, Wu Fengguang a écrit :
> >> > The O_* bit numbers are defined in 20+ arch/*, and hence can silently
> >> > overlap. Add a boot time check to ensure the uniqueness as suggested
> >> > by David Miller.
> >> > 
> >> > CC: David Miller <davem@davemloft.net>
> >> > CC: Stephen Rothwell <sfr@canb.auug.org.au>
> >> > CC: Al Viro <viro@zeniv.linux.org.uk>
> >> > CC: Christoph Hellwig <hch@infradead.org>
> >> > CC: Eric Paris <eparis@redhat.com>
> >> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> >> > ---
> >> >  {
> >> > +	/* please add new bits here to ensure allocation uniqueness */
> >> > +	BUG_ON(20 != hweight32(
> >> > +		O_RDONLY	| O_WRONLY	| O_RDWR	|
> >> > +		O_CREAT		| O_EXCL	| O_NOCTTY	|
> >> > +		O_TRUNC		| O_APPEND	| O_NONBLOCK	|
> >> > +		O_SYNC		| FASYNC	| O_DIRECT	|
> >> > +		O_LARGEFILE	| O_DIRECTORY	| O_NOFOLLOW	|
> >> > +		O_NOATIME	| O_CLOEXEC	| O_RANDOM	|
> >> > +		FMODE_EXEC	| FMODE_NONOTIFY));
> >> > +
> >> 
> >> I cannot test it, but given O_RDONLY is 0, are you sure 20 bits are actually set ?
> >
> > Yes, I tested it. The tricky one is O_SYNC, which actually has two bits..
> 
> What if a new architecture wants to use a single bit value (since it
> does not need backwards compatibility)?

You mean to test __O_SYNC | O_DSYNC instead of O_SYNC?
