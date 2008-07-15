Return-Path: <linux-kernel-owner+w=401wt.eu-S1761586AbYGOCoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761586AbYGOCoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbYGOCor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:44:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56737 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753967AbYGOCoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:44:46 -0400
Date: Mon, 14 Jul 2008 19:39:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: rene.herman@keyaccess.nl, david@lang.hm, arjan@infradead.org,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <20080714.192425.241878700.davem@davemloft.net>
Message-ID: <alpine.LFD.1.10.0807141934060.3017@woody.linux-foundation.org>
References: <alpine.DEB.1.10.0807141750290.14223@asgard.lang.hm> <20080714.185207.203328391.davem@davemloft.net> <487C0A12.9060906@keyaccess.nl> <20080714.192425.241878700.davem@davemloft.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Jul 2008, David Miller wrote:
> 
> They states that it was being done on a technical basis rather
> than being predominantly a legal one.

No.

Yes, the original reason for request_firmware() was obviously very much 
partly legal.

HOWEVER.

Once you have a model that is required (for whatever reasons) for some 
drivers, we're much better off using the _same_ model for all drivers, 
whether it is necessary for legal reasons for those other drivers.

Put this way: if you do a distro, you _need_ to support firmware loading 
anyway. And once you do that, it's just annoying how some drivers then do 
something odd and special for the same thing, for no real good reason.

It's like having each wireless driver do their own 802.11 stack. It works, 
and all those driver writers seem to be always convinced that it's the 
right thing to do. But as a network maintainer, do you like it?

Now, replace "802.11 stack" with "firmware loader", and then replace 
"network maintainer" with "kernel maintainer".

And maybe you can see why I like just making everybody do 
request_firmware().

Do you call that a legal reason? Or a technical one?

				Linus
