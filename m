Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbZGLJ6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbZGLJ6p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 05:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbZGLJ6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 05:58:37 -0400
Received: from ozlabs.org ([203.10.76.45]:37748 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628AbZGLJ6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 05:58:36 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH v5] RO/NX protection for loadable kernel modules
Date: Sun, 12 Jul 2009 19:28:27 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Siarhei Liakh <sliakh.lkml@gmail.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-cris-kernel@axis.com
References: <817ecb6f0907081610p6d60341cudbee42685eac1347@mail.gmail.com> <200907121410.39874.rusty@rustcorp.com.au> <20090712004524.2f0c4e57@infradead.org>
In-Reply-To: <20090712004524.2f0c4e57@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907121928.28887.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Jul 2009 05:15:24 pm Arjan van de Ven wrote:
> Rusty Russell <rusty@rustcorp.com.au> wrote:
> > (I like the idea of trying kmalloc and falling back, simply because
> > it reduces TLB pressure, but that's probably best done after
> > unification).
>
> or using a non-power-of-two get_free_pages() thing...
>
> some architectures will need to know that memory needs to be executable
> at allocation time so that it can be put in an executable address range
> etc...

Yes, maybe that's better than kmalloc.  On my laptop I have 105 modules 
loaded, with 3778464 total length: I'm wasting 206944 bytes on unused tails of 
pages.  But that's only 0.06% of my memory.

Thanks,
Rusty.
