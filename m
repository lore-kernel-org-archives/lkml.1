Return-Path: <linux-kernel-owner+w=401wt.eu-S938351AbXHIQ3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938351AbXHIQ3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 12:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756621AbXHIQ3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 12:29:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44237 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbXHIQ3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 12:29:16 -0400
Message-ID: <46BB40D1.1050109@zytor.com>
Date: Thu, 09 Aug 2007 09:29:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: huang ying <huang.ying.caritas@gmail.com>
CC: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com
Subject: Re: [PATCH 5/5] x86_64 EFI support -v3: EFI document
References: <183884.85434.qm@web26915.mail.ukl.yahoo.com>	 <200708091251.21726.ak@suse.de> <851fc09e0708090709s4f4fbbf9r91a7300a773f985a@mail.gmail.com>
In-Reply-To: <851fc09e0708090709s4f4fbbf9r91a7300a773f985a@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

huang ying wrote:
> 
> I think at least the following should be done to make it a external
> boot protocol.
> 
> 1. A version number field should be added.
> 2. The pointers (especially these come from firmware) should be 64bit
> to make the entry point can be used for both 32bit and 64bit platform.
> 3. More complete and formal document.
> 
> Can you kindly tell me what's more should be done?
> 

I have been looking at this recently, and also found that we already
have to make unacceptable compromises in order to fit into 4K, which is
set completely arbitrary (once upon a time, it was recycled as the
zeropage, but that is ancient history.)

Part of a formalizing the 32-bit/64-bit entrypoint involves a clean way
to extend this data set.

I mentioned in private email to a few people that I think a linked list
of tagged data items (similar to the way PCI capabilities work) would
probably make sense; we want a piece of code to know the structure
without needing to know the contents, in order to rescue data.

It's worth realizing that this is inherently never going to be as stable
as the real-mode entrypoint, and there is always going to be more
catch-up, simply because it's a broader interface.  What is blatantly
clear, however, is that the current structure is utterly ad hoc and has
been totally prematurely adopted as some sort of standard interface.
Since I've spent time formalizing the structure over the last few months
I've been rather horrified; it is truly as bad as you could get.

So, anyway, this has popped up on my radar already; it needs to happen
anyway so let's get the discussion started.

	-hpa
