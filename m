Return-Path: <linux-kernel-owner+w=401wt.eu-S1756873AbXERLrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbXERLrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 07:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbXERLr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 07:47:26 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:48701 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754052AbXERLrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 07:47:25 -0400
Subject: Re: [RFC] LZO1X de/compression support
From: Richard Purdie <richard@openedhand.com>
To: Nitin Gupta <nitingupta910@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4cefeab80705180258g516a6f92w15a49e666dd62b66@mail.gmail.com>
References: <4cefeab80705180258g516a6f92w15a49e666dd62b66@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 18 May 2007 12:46:56 +0100
Message-Id: <1179488817.5876.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2007-05-18 at 15:28 +0530, Nitin Gupta wrote:
> This is kernel port of LZO1X de/compression algo stripped down to just ~500 LOC!
> It is derived from original LZO 2.02 code found at:
> http://www.oberhumer.com/opensource/lzo/download/
> The code has also been reformatted to match general kernel style.
> 
> Facts for LZO (at least for original code. Should hold true for this
> port also - hence the RFC!):
> - The compressor can never overrun buffer.
> - The "non-safe" version of decompressor can never overrun buffer if
> compressed data is unmodified. I am not sure about this if compressed
> data is malicious (to be confirmed from the author).

If the data is malicious, it *can* overrun the buffer.

> - The "safe" version can never crash (buffer overrun etc.) - confirmed
> from the author.
> This patch, as of yet, only gives 'non-safe' version of decompressor.
> The 'safe' version  will be included soon.

How are you planning to add that back?

> Since 'non-safe' version has no problems if compressed data is
> unmodified, it is useful in cases we have such guarantees on
> compressed data and hence don't want additional overhead of 'safe'
> version. For e.g. Compressed Caching project
> (http://linuxcompressed.sourceforge.net) has been using the 'non-safe'
> version of LZO1X since long time without any problems w.r.t.
> de/compression itself.
> 
> For now, I have tested this on x86 only.

The LZO author had some concerns about this code. The major issue he
highlighted was that it was 64-bit unsafe. Have you addressed that
problem? Has it been tested on 64bit?

I'm worried that in converting this code the way you have, you've
possibly introduced potential security holes. You've removed all bounds
checking and are going to have to add that back to create the "safe"
version of the decompression function. Until I mentioned it, you seemed
unaware of the potential problem and the comments above suggest you
don't understand this code as fully as I'd like with regard to
overflows.

The version I submitted has at least been subject to userspace scrutiny
over a period of time and is basically unchanged with regard to
security. It is much uglier though.

Richard


