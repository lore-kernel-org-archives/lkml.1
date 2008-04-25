Return-Path: <linux-kernel-owner+w=401wt.eu-S1759721AbYDYShS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759721AbYDYShS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbYDYShD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:37:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34738 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751353AbYDYShA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:37:00 -0400
Date: Fri, 25 Apr 2008 11:36:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 01/24] types: create <asm-generic/int-*.h>
In-Reply-To: <alpine.LNX.1.10.0804252026040.20150@fbirervta.pbzchgretzou.qr>
Message-ID: <alpine.LFD.1.10.0804251133100.2779@woody.linux-foundation.org>
References: <1209078352-7593-1-git-send-email-hpa@zytor.com> <1209078352-7593-2-git-send-email-hpa@zytor.com> <1209078352-7593-3-git-send-email-hpa@zytor.com> <alpine.LNX.1.10.0804252026040.20150@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 25 Apr 2008, Jan Engelhardt wrote:
> 
> long long is 64 bits on both 32 and 64, is not it?
> If so, the split between 32 and 64 should not be necessary.

They may be the same size, but there are still pure C-level _type_ 
differences that the compiler will warn about.

This is the same issue as a 32-bit type on x86-32: is it an "int" or a 
"long"? From a pure size perspective it shouldn't matter, but if you pass 
a pointer to it, or use it in a "printf()", it matters a whole lot, 
because the compiler will complain if you use the wrong version.

So on some 32-bit architectures, "size_t" is "unsigned int", on others it 
is "unsigned long", and you have to get it right in order to avoid 
complaints. 

The exact same thing is true about "long" vs "long long" on 64-bit 
architectures. They may have the same size, but they don't have the same 
type.

		Linus


