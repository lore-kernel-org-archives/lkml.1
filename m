Return-Path: <linux-kernel-owner+w=401wt.eu-S1757194AbZBEPWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbZBEPWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 10:22:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbZBEPWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 10:22:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55772 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbZBEPWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 10:22:37 -0500
Message-ID: <498B0315.5080804@zytor.com>
Date: Thu, 05 Feb 2009 07:17:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>, mingo@elte.hu, x86@kernel.org,
       sam@ravnborg.org, jirislaby@gmail.com, gregkh@suse.de,
       davem@davemloft.net, xyzzy@speakeasy.org, mchehab@infradead.org,
       jens.axboe@oracle.com, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
       netfilter-devel@vger.kernel.org
Subject: Re: [GIT PULL -tip] fix 22 make headers_check - 200901
References: <20090204064307.GA18415@gondor.apana.org.au> <200902041255.53264.arnd@arndb.de> <4989D17F.4030406@zytor.com> <200902051530.25897.arnd@arndb.de>
In-Reply-To: <200902051530.25897.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Wednesday 04 February 2009, H. Peter Anvin wrote:
>> Actually, if anything we should move the *non* __KERNEL_STRICT_NAMES out
>> of <linux/types.h> into something else, or completely deep-six them.  I
>> don't know of any libc which wants these anymore, and I think they're
>> just residual libc5 cruft.
>>
>> However, if we want <linux/extra_types.h> that's fine with me; but
>> <linux/types.h> really should be clean, which means doing what
>> __KERNEL_STRICT_NAMES does now.
> 
> Right now, we have 15 exported headers [1] that use the non-strict 
> posix types (pid_t, off_t, clock_t, ...) and a set of 106 (!)
> files [2] using non-strict integer types (u_int32_t, uint32_t, u32, ...),
> 76 of those alone in netfilter.
> 

Geez.  The integer types is just a pattern replacement, so those we can
just fix.  The 15 exported headers that use other types may very well be
real bugs -- we have had a fair share of broken ioctl signatures due to
exactly this problem.

> Do you think we should fix up all of them before 2.6.29? I'm worried
> that we might introduce more regressions in the process.
> Also, should we leave netfilter alone, in order to reduce the changes?
> I'm also unsure whether a hack in headers_install would be better than
> changing the headers in the source tree.

I have been advocating for hacking headers_install for a while.  That
takes care of the 106.  The 15 *need* to be audited immediately, because
that is even likely to be actual manifest bugs.

	-hpa
-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

