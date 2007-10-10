Return-Path: <linux-kernel-owner+w=401wt.eu-S1756985AbXJJUkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985AbXJJUkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 16:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755992AbXJJUkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 16:40:10 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:59569 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755891AbXJJUkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 16:40:08 -0400
Date: Wed, 10 Oct 2007 22:41:39 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       parisc-linux-request@lists.parisc-linux.org,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Kyle McMartin <kyle@parisc-linux.org>
Subject: Re: parisc arch makefile clean-up needed [Was: cleaning up "make headers_install" for various architectures]
Message-ID: <20071010204139.GA3255@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0710101234340.32502@localhost.localdomain> <20071010095954.79c39a73.randy.dunlap@oracle.com> <Pine.LNX.4.64.0710101324230.6071@localhost.localdomain> <20071010183858.GA2270@uranus.ravnborg.org> <20071010202128.GG2730@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071010202128.GG2730@parisc-linux.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Now, compiler.h has some checks like:
> 
> #elif __GNUC__ == 3 && __GNUC_MINOR__ >= 2
> # include <linux/compiler-gcc3.h>
> #else
> # error Sorry, your compiler is too old/not recognized.
> #endif
> 
> But it doesn't permit us to rule out gcc 3.3 unless we patch compiler.h.
> There's no asm/compiler.h, for example.  Obviously, we could put some
> tests for compiler version in arch/parisc somewhere.  Where's the right
> place these days?

Good question...
I prefer the solution used by powerpc.
See the checkbin dependency of archprepare:

archprepare: is only triggered when we actually try to build a kernel,
and will not trigger for the said headers_install thing.

	Sam
