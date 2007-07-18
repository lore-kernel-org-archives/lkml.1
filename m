Return-Path: <linux-kernel-owner+w=401wt.eu-S935405AbXGRReP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935405AbXGRReP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 13:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763685AbXGRRd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 13:33:59 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:34939 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763684AbXGRRd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 13:33:58 -0400
Message-ID: <469E4EB0.4050305@gmail.com>
Date: Wed, 18 Jul 2007 19:32:32 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Phillip Susi <psusi@cfl.rr.com>
CC: Matt Mackall <mpm@selenic.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
References: <200707111916.35036.jesper.juhl@gmail.com> <2c0942db0707112159v3ee2cd83i74759c7138e273f7@mail.gmail.com> <9a8748490707121324q3b3e6e65ye14ab8e7f089d999@mail.gmail.com> <4696C89E.4010002@goop.org> <9a8748490707121925w5fb22c0o61068f06d66d5845@mail.gmail.com <20070714191737.GA11166@waste.org> <469E4BB0.8010203@cfl.rr.com>
In-Reply-To: <469E4BB0.8010203@cfl.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2007 07:19 PM, Phillip Susi wrote:

> Why do the two pages have to be physically contiguous?  The stack just 
> needs to be two contiguous pages in virtual memory, but they can map to 
> any two pages anywhere in physical memory.

As far as I'm aware that's just a consequence of the way linux does memory 
management. If we ignore highmem, virtual memory is simply +/- PAGE_OFFSET 
away from physical so allocating virtually contiguous pages that are _not_ 
physically contiguous requires mapping them somewhere (the vmalloc area) 
which is limited. Given that large number of threads _are_ the problem you 
wouldn't solve things -- you'd again be out of space, although now for a 
different reason.

Rene.
