Return-Path: <linux-kernel-owner+w=401wt.eu-S1761652AbXFESgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761652AbXFESgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 14:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756050AbXFESfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 14:35:55 -0400
Received: from terminus.zytor.com ([192.83.249.54]:41153 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478AbXFESfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 14:35:54 -0400
Message-ID: <4665AD01.6030003@zytor.com>
Date: Tue, 05 Jun 2007 11:35:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Richard Purdie <richard@openedhand.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Problems (a bug?) with UINT_MAX from kernel.h
References: <1181054562.6180.77.camel@localhost.localdomain>
In-Reply-To: <1181054562.6180.77.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Purdie wrote:
> The kernel uses UINT_MAX defined from kernel.h in a variety of places.
> 
> While looking at the behaviour of the LZO code, I noticed it seemed to
> think an int was 8 bytes large on my 32 bit i386 machine. It isn't but
> why did it think that?
> 
> kernel.h says:
> 
> #define INT_MAX		((int)(~0U>>1))
> #define INT_MIN		(-INT_MAX - 1)
> #define UINT_MAX	(~0U)
> #define LONG_MAX	((long)(~0UL>>1))
> #define LONG_MIN	(-LONG_MAX - 1)
> #define ULONG_MAX	(~0UL)
> #define LLONG_MAX	((long long)(~0ULL>>1))
> #define LLONG_MIN	(-LLONG_MAX - 1)
> #define ULLONG_MAX	(~0ULL)
> 
> If I try to compile the code fragment below, I see the error:
> 
> #define UINT_MAX	(~0U)
> #if (0xffffffffffffffff == UINT_MAX)
>   #error argh
> #endif
> 
> I've tested this on several systems with a variety of gcc versions with
> the same result. I've tried various other ways of testing this all with
> the same conclusion, UINT_MAX is wrong.
> 

C99 states that all arithmetic in the preprocessor is done in
(u)intmax_t, regardless of prefixes or suffixes.

	-hpa
