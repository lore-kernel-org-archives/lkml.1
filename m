Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbZJ1Lij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbZJ1Lij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 07:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbZJ1Lij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 07:38:39 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:14100 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbZJ1Lii convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 07:38:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=wx+PJEZsIPnWLYJAWixC1WCe0bQcKRG0qzjCxRbMOq32aWBnINvkoklWeMptOMob6w
         K22gx8GTJVxTx1NOTDz+FMppYlKHcG7PiLXJ7AaqAziqlmyKRZY6mo55rnasrKGwYXte
         nhFhNwVa63AsPBsFcr25G0xv0E/hAilE8jPOs=
MIME-Version: 1.0
In-Reply-To: <4AE7FA12.2070905@kernel.org>
References: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <1256712464-21472-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <20091028074832.GC19402@elte.hu> <4AE7FA12.2070905@kernel.org>
Date: Wed, 28 Oct 2009 13:38:42 +0200
X-Google-Sender-Auth: e636734c98136cd4
Message-ID: <84144f020910280438j65bcacacq731f6076cbd8d99@mail.gmail.com>
Subject: Re: [PATCH 07/10] bootmem: add free_bootmem_late
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, chrisw@sous-sol.org, dwmw2@infradead.org,
       joerg.roedel@amd.com, Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Wed, Oct 28, 2009 at 10:00 AM, Tejun Heo <tj@kernel.org> wrote:
> ISTR an attempt to initialize the kmalloc allocator much earlier
> during boot such that it can completely replace the bootmem allocator,
> which would nicely remove all the complications although it may
> require the kmalloc allocator to go through more complex boot
> strapping steps.  I didn't follow how that went.  Did it prove to be
> unworkable?

We're doing it before scheduler init now but I haven't put any effort
into moving it earlier than that yet. I don't see any fundamental
reason we can't do that but the practical problem is that we're going
to affect architecture specific boot code which is really hard to
test.

                        Pekka
