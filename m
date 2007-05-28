Return-Path: <linux-kernel-owner+w=401wt.eu-S1762050AbXE1Jos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762050AbXE1Jos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 05:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761778AbXE1Joj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 05:44:39 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:13527 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761708AbXE1Joh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 05:44:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aKwDhumvJxp0KjWCX/uhaBnMUAiuMaLmRq2r8Uvcl1Aqhc1IKALyy2f5qe8IR0I3/0NRHipub093oQNYVi5pgku6Pc10cGS+m0H/SnWPkPXMJafto9zD8oaLLY31Ohj5fWs748pvCfb+C8ToVFbwjs7dh+qzXAOOnUrkzgi6PMM=
Message-ID: <a781481a0705280244i1d5d315at841e4e480f0d6aa0@mail.gmail.com>
Date: Mon, 28 May 2007 15:14:35 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Nitin Gupta" <nitingupta910@gmail.com>
Subject: Re: [RFC] LZO de/compression support - take 5
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mm-cc@laptop.org,
       linuxcompressed-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Richard Purdie" <richard@openedhand.com>,
       "Daniel Hazelton" <dhazelton@enter.net>,
       "Bret Towe" <magnade@gmail.com>
In-Reply-To: <4cefeab80705272359o16725994k7f3c01b99c5691cd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705272359o16725994k7f3c01b99c5691cd@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/28/07, Nitin Gupta <nitingupta910@gmail.com> wrote:
> [...]
> Can anyone do timing measurement in kernel space only. This will
> eliminate all possible problems w.r.t usespace testing. I tried doing
> the same using get_jiffies_64() across calls to compressor in the
> 'compress-test' module but this is giving same value when measured
> just before and after calls to lzo1x_compress(). I don't know why.

Jiffies wouldn't really offer the kind of precision to serve your purpose.

> If anyone can simply measure time across lzo1x_compress() and
> lzo1x_decompress() calls in this compress-test module, then that will
> give us proper perf. figures.

I wish I had time for this myself (I'll see if I can do this tonight) ... but
anyhow, the idea is quite simply this:

cycles_t start, end;
unsigned long long diff;

start = get_cycles();
/*
 * lzo1x_compress() or
 * lzo1x_decompress() or whatever
 * on large enough input size.
 */
end = get_cycles();

diff = end - start;

That is all there is to it.

Note that get_cycles() (on x86 boxes, at least) might not be usable
or trustworthy on SMP machines unless you ensure that your code
(including the start and end timing measurements) executes on the
same particular CPU.

You could also use something like this when pin-pointing the exact
cause of the performance loss you experienced when the code was
fully cleaned up initially (before you started rolling back some stuff).

Satyam
