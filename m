Return-Path: <linux-kernel-owner+w=401wt.eu-S1758793AbZEKT2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793AbZEKT2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 15:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758203AbZEKT2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 15:28:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42937 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756086AbZEKT2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 15:28:03 -0400
Date: Mon, 11 May 2009 21:27:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/asm] x86, 64-bit: ifdef out struct thread_struct::ip
Message-ID: <20090511192730.GF28684@elte.hu>
References: <20090503233015.GJ16631@x200.localdomain> <tip-0c23590f00f85467b318ad0c20c36796a5bd4c60@git.kernel.org> <20090511160324.GA7923@infradead.org> <b6fcc0a0905111022g1df0b1c5l95c2a072745578a0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b6fcc0a0905111022g1df0b1c5l95c2a072745578a0@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Mon, May 11, 2009 at 8:03 PM, Christoph Hellwig <hch@infradead.org> wrote:
> > On Mon, May 11, 2009 at 03:09:40PM +0000, tip-bot for Alexey Dobriyan wrote:
> >> +#ifdef CONFIG_X86_32
> >>       unsigned long           ip;
> >> +#endif
> >>  #ifdef CONFIG_X86_64
> >>       unsigned long           fs;
> >>  #endif
> >
> > What happened to the good old concept of #if #else #endif?
> 
> #else suggests alternative which is not the case.
> ->ip and ->fs can be in different parts of thread_struct.

Yes, it's cleaner to have them separate. #if / #else / #endif would 
be shorter by one line, and it would be thicker by a big confusion 
factor: "why is fs the alternative on 64-bit of 32-bit's ip??"

They could also move apart later on, if structure packing 
constraints call for it.

	Ingo
