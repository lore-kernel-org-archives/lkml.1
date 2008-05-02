Return-Path: <linux-kernel-owner+w=401wt.eu-S936876AbYEBVeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936876AbYEBVeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 17:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760548AbYEBVeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 17:34:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57956 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758680AbYEBVeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 17:34:03 -0400
Message-ID: <481B888F.3070302@zytor.com>
Date: Fri, 02 May 2008 14:33:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Carlos R. Mafra" <crmafra@ift.unesp.br>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/time.c: Silence gcc warning 'integer constant
 to large for long type'
References: <200805021858.m42Iw4Lj025952@tazenda.hos.anvin.org> <alpine.LFD.1.10.0805021407030.5994@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805021407030.5994@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 2 May 2008, H. Peter Anvin wrote:
>> kernel/time.c: In function msecs_to_jiffies:
>> kernel/time.c:479: warning: integer constant is too large for long type
> 
> Shouldn't we fix the perl-script to mark the constants appropriately 
> typed? Ie add the proper "ul" or "ull" endings there as necessary?
> 
> For example, I see
> 
> 	#define MSEC_TO_HZ_ADJ64        0x18000000000000000
> 
> in the auto-generated timeconst.h file, and the fact is, that's a really 
> really ugly constant. It simply doesn't even fit in a u64. Why do these 
> kinds of pointless and useless #define even get generated, when using them 
> would inevitably be a bug anyway?
> 
> As to the ones that *do* fit in 64 bits, they should still haev the 
> correct "ul" and "ull" endings on 64- and 32-bit architectures 
> respectively. Yeah, hex constants are always unsigned and the compiler 
> will expand them to the right size, but the compiler is also rigth to warn 
> about it (and casting them shouldn't even change that fact, even if it 
> happens to do so with gcc).

That's more or less what my other patchset does.  It's a bit more 
complex (because it gets the suffixes via macros, to get the right 
suffixes), but most of it is pure cleanup of the way we handle integers 
in architecture includes:

git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-inttypes.git

	-hpa
