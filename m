Return-Path: <linux-kernel-owner+w=401wt.eu-S1757269AbYDHSjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbYDHSjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 14:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbYDHSjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 14:39:25 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:41545 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbYDHSjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 14:39:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BKu918a9et1SVGl38v1RyIg7yKmj2JhxS8xpO7ekgqsV9hUqNjVoPBKuGN54eydMFaWqcNN4gOEngdv5uFDkQ7mZ4MnCoc6Sa2nK2ZUK+YgCVl+VgvC1wETVt3PuOzH9QpEobUqv+PDRY7KMQIXRfxdDthHsYbambZOOCpBeAXQ=
Message-ID: <86802c440804081139i60f93694u7336b0e808e83d11@mail.gmail.com>
Date: Tue, 8 Apr 2008 11:39:22 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Alexander van Heukelum" <heukelum@mailshack.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: cleanup boot-heap usage
Cc: "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "Mike Travis" <travis@sgi.com>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, heukelum@fastmail.fm
In-Reply-To: <20080408105430.GA11595@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080405013014.478571000@polaris-admin.engr.sgi.com>
	 <20080405013014.693571000@polaris-admin.engr.sgi.com>
	 <20080405134626.GA15894@mailshack.com> <47FA6478.1070301@sgi.com>
	 <20080407214434.GA5296@mailshack.com> <20080408082354.GA13940@elte.hu>
	 <20080408105430.GA11595@mailshack.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2008 at 3:54 AM, Alexander van Heukelum
<heukelum@mailshack.com> wrote:
> The kernel decompressor wrapper uses memory located beyond the
>  end of the image. This might lead to hard to debug problems,
>  but even if it can be proven to be safe, it is at the very
>  least unclean. I don't see any advantages either, unless you
>  count it not being zeroed out as an advantage. This patch
>  moves the boot-heap area to the bss segment.
>
>  Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
>
>  ---
>
>  On Tue, Apr 08, 2008 at 10:23:54AM +0200, Ingo Molnar wrote:
>  > * Alexander van Heukelum <heukelum@mailshack.com> wrote:
>  > > I did see that the malloc space that the inflate code is using is
>  > > taken from _after_ the end of the bss. I don't see how this is
>  > > protected from being used/overwritten. Changing the stack size changes
>  > > the memory layout a bit... maybe you were so unlucky to create a
>  > > vmlinux image that was just barely smaller than some threshold and
>  > > increasing the stack size made the decompression/relocation area be
>  > > located somewhere else?
the compressed image is copied to end of buff ( with extra code size
for from relocated: in .text to _end)
and do the on possition decompressed. .text section is near end.

YH
