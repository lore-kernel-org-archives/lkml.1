Return-Path: <linux-kernel-owner+w=401wt.eu-S1765980AbYB0AMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765980AbYB0AMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 19:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbYB0AMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 19:12:06 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754445AbYB0AMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 19:12:05 -0500
Date: Tue, 26 Feb 2008 16:09:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: (regression) kernel/timeconst.h bugs with HZ=128
Message-Id: <20080226160958.3f58a5c1.akpm@linux-foundation.org>
In-Reply-To: <20080226183224.DE5BB8DE50@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
References: <20080226183224.DE5BB8DE50@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008 10:32:24 -0800 David Brownell <david-b@pacbell.net> wrote:

> I see these warnings on 32 bit ARM systems:
> 
>   CC      kernel/time.o
> kernel/time.c: In function 'msecs_to_jiffies':
> kernel/time.c:472: warning: integer constant is too large for 'long' type
> kernel/time.c: In function 'usecs_to_jiffies':
> kernel/time.c:487: warning: integer constant is too large for 'long' type
> 
> Line 472: 
> 	return ((u64)MSEC_TO_HZ_MUL32 * m + MSEC_TO_HZ_ADJ32)
> line 487:
> 	return ((u64)USEC_TO_HZ_MUL32 * u + USEC_TO_HZ_ADJ32)
> 
> The problem seems to be that these constants from kernel/timeconst.h
> have too many digits:
> 
> #define ONLY_THIRTYTWO_BITS	0x01234567
> 
> #define MSEC_TO_HZ_ADJ32        0x3f7ced916
> #define USEC_TO_HZ_ADJ32        0xfffbce4217d
> 
> Those *_ADJ32 constants should have "ULL" suffixes, yes?
> Adding that by hand resolves the problem, but only until
> the next time that header file gets regenerated.
> 
> Someone with observable Perl-fu should fix this ...
> 

(cc's added)
