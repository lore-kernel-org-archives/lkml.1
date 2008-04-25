Return-Path: <linux-kernel-owner+w=401wt.eu-S933703AbYDYTNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933703AbYDYTNP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 15:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933855AbYDYTLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 15:11:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39461 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765218AbYDYTLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 15:11:21 -0400
Message-ID: <48122CB0.7020003@zytor.com>
Date: Fri, 25 Apr 2008 12:10:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 01/24] types: create <asm-generic/int-*.h>
References: <1209078352-7593-1-git-send-email-hpa@zytor.com> <1209078352-7593-2-git-send-email-hpa@zytor.com> <1209078352-7593-3-git-send-email-hpa@zytor.com> <alpine.LNX.1.10.0804252026040.20150@fbirervta.pbzchgretzou.qr> <alpine.LFD.1.10.0804251133100.2779@woody.linux-foundation.org> <20080425185251.GL14990@parisc-linux.org>
In-Reply-To: <20080425185251.GL14990@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> 
> So ... given all this, why do we define s64 to be 'long' on some
> architectures and 'long long' on others?  It seems to actively _hinder_
> passing it to printf(), so there must be some other good reason that
> I'm missing to not make it 'long long' everywhere.
> 

Well, compatibility with userspace is probably one aspect of that. 
x86-64 is the odd man out there, it defines __s64 as "long long" even 
for userspace, even though int64_t from <stdint.h> is "long".  This, 
IMO, is the Wrong Thing, but it's a separate set of changes.

The right thing to do is probably to always use "long long" in the 
kernel, while defining __s64 et al as "long" on 64-bit platforms when 
not under __KERNEL__.

Again, this is a separate set of changes from this patchset, which is 
just a code transformation.

	-hpa

