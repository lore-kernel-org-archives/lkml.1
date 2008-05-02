Return-Path: <linux-kernel-owner+w=401wt.eu-S936726AbYEBVPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936726AbYEBVPg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 17:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932626AbYEBVP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 17:15:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932601AbYEBVPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 17:15:25 -0400
Date: Fri, 2 May 2008 14:14:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: "Carlos R. Mafra" <crmafra@ift.unesp.br>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/time.c: Silence gcc warning 'integer constant to
 large for long type'
In-Reply-To: <200805021858.m42Iw4Lj025952@tazenda.hos.anvin.org>
Message-ID: <alpine.LFD.1.10.0805021407030.5994@woody.linux-foundation.org>
References: <200805021858.m42Iw4Lj025952@tazenda.hos.anvin.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 May 2008, H. Peter Anvin wrote:
> 
> kernel/time.c: In function msecs_to_jiffies:
> kernel/time.c:479: warning: integer constant is too large for long type

Shouldn't we fix the perl-script to mark the constants appropriately 
typed? Ie add the proper "ul" or "ull" endings there as necessary?

For example, I see

	#define MSEC_TO_HZ_ADJ64        0x18000000000000000

in the auto-generated timeconst.h file, and the fact is, that's a really 
really ugly constant. It simply doesn't even fit in a u64. Why do these 
kinds of pointless and useless #define even get generated, when using them 
would inevitably be a bug anyway?

As to the ones that *do* fit in 64 bits, they should still haev the 
correct "ul" and "ull" endings on 64- and 32-bit architectures 
respectively. Yeah, hex constants are always unsigned and the compiler 
will expand them to the right size, but the compiler is also rigth to warn 
about it (and casting them shouldn't even change that fact, even if it 
happens to do so with gcc).

		Linus
