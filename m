Return-Path: <linux-kernel-owner+w=401wt.eu-S1754449Ab0AIMjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab0AIMjQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 07:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099Ab0AIMjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 07:39:14 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:38854 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab0AIMjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 07:39:11 -0500
X-Auth-Info: R0ktkecH2e2vLiPLMEuCLeQsd9mCUAjxts53GMTnKiM=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>, Eric Paris <eparis@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] fs: O_* bit numbers uniqueness check
References: <20100106065526.GB11368@localhost> <4B443695.5090301@gmail.com>
	<20100106072029.GA25169@localhost>
X-Yow: The FALAFEL SANDWICH lands on my HEAD and I become a VEGETARIAN...
Date: Wed, 06 Jan 2010 10:13:54 +0100
In-Reply-To: <20100106072029.GA25169@localhost> (Wu Fengguang's message of
	"Wed, 6 Jan 2010 15:20:29 +0800")
Message-ID: <m2iqbfwq7h.fsf@whitebox.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang <fengguang.wu@intel.com> writes:

> On Wed, Jan 06, 2010 at 03:07:01PM +0800, Eric Dumazet wrote:
>> Le 06/01/2010 07:55, Wu Fengguang a écrit :
>> > The O_* bit numbers are defined in 20+ arch/*, and hence can silently
>> > overlap. Add a boot time check to ensure the uniqueness as suggested
>> > by David Miller.
>> > 
>> > CC: David Miller <davem@davemloft.net>
>> > CC: Stephen Rothwell <sfr@canb.auug.org.au>
>> > CC: Al Viro <viro@zeniv.linux.org.uk>
>> > CC: Christoph Hellwig <hch@infradead.org>
>> > CC: Eric Paris <eparis@redhat.com>
>> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
>> > ---
>> >  {
>> > +	/* please add new bits here to ensure allocation uniqueness */
>> > +	BUG_ON(20 != hweight32(
>> > +		O_RDONLY	| O_WRONLY	| O_RDWR	|
>> > +		O_CREAT		| O_EXCL	| O_NOCTTY	|
>> > +		O_TRUNC		| O_APPEND	| O_NONBLOCK	|
>> > +		O_SYNC		| FASYNC	| O_DIRECT	|
>> > +		O_LARGEFILE	| O_DIRECTORY	| O_NOFOLLOW	|
>> > +		O_NOATIME	| O_CLOEXEC	| O_RANDOM	|
>> > +		FMODE_EXEC	| FMODE_NONOTIFY));
>> > +
>> 
>> I cannot test it, but given O_RDONLY is 0, are you sure 20 bits are actually set ?
>
> Yes, I tested it. The tricky one is O_SYNC, which actually has two bits..

What if a new architecture wants to use a single bit value (since it
does not need backwards compatibility)?

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
