Return-Path: <linux-kernel-owner+w=401wt.eu-S1758179AbXJXMU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179AbXJXMU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 08:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbXJXMUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 08:20:18 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:38851 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237AbXJXMUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 08:20:17 -0400
Date: Wed, 24 Oct 2007 14:21:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Linux v2.6.24-rc1
Message-ID: <20071024122148.GA2194@uranus.ravnborg.org>
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org> <20071024080451.GA32690@infradead.org> <20071024110733.GA1374@uranus.ravnborg.org> <20071024121218.GA23548@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024121218.GA23548@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 02:12:18PM +0200, Ingo Molnar wrote:
> > The Makefile stuff is trivial to merge.
> 
> yes. But even Makefile merging can be surprisingly nontrivial at times: 
> we had bugs in earlier versions of the unification due to link ordering 
> and silent init section dependencies in the code. When we unified the 
> makefiles certain init code broke because the initcall ordering changed. 
> That's why we went for the "stupid, mechanic unification" approach first 
> - to always have a 100% correct fallback position that people can bisect 
> to.

With trivial I thought of:
ifeq ($(ARCH),x86_64)
include arch/x86/Makefile_64
else
include arch/x86/Makefile_32
endif

And common stuff could be put before/after the include.

	Sam
