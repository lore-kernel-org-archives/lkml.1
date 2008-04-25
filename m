Return-Path: <linux-kernel-owner+w=401wt.eu-S1765544AbYDYTHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765544AbYDYTHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 15:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933169AbYDYSwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:52:54 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:57591 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933056AbYDYSww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:52:52 -0400
Date: Fri, 25 Apr 2008 12:52:51 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 01/24] types: create <asm-generic/int-*.h>
Message-ID: <20080425185251.GL14990@parisc-linux.org>
References: <1209078352-7593-1-git-send-email-hpa@zytor.com> <1209078352-7593-2-git-send-email-hpa@zytor.com> <1209078352-7593-3-git-send-email-hpa@zytor.com> <alpine.LNX.1.10.0804252026040.20150@fbirervta.pbzchgretzou.qr> <alpine.LFD.1.10.0804251133100.2779@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804251133100.2779@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2008 at 11:36:26AM -0700, Linus Torvalds wrote:
> On Fri, 25 Apr 2008, Jan Engelhardt wrote:
> > long long is 64 bits on both 32 and 64, is not it?
> > If so, the split between 32 and 64 should not be necessary.
> 
> They may be the same size, but there are still pure C-level _type_ 
> differences that the compiler will warn about.
> 
> This is the same issue as a 32-bit type on x86-32: is it an "int" or a 
> "long"? From a pure size perspective it shouldn't matter, but if you pass 
> a pointer to it, or use it in a "printf()", it matters a whole lot, 
> because the compiler will complain if you use the wrong version.
> 
> So on some 32-bit architectures, "size_t" is "unsigned int", on others it 
> is "unsigned long", and you have to get it right in order to avoid 
> complaints. 
> 
> The exact same thing is true about "long" vs "long long" on 64-bit 
> architectures. They may have the same size, but they don't have the same 
> type.

So ... given all this, why do we define s64 to be 'long' on some
architectures and 'long long' on others?  It seems to actively _hinder_
passing it to printf(), so there must be some other good reason that
I'm missing to not make it 'long long' everywhere.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
