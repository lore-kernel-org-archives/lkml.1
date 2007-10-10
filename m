Return-Path: <linux-kernel-owner+w=401wt.eu-S1756342AbXJJUVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342AbXJJUVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 16:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbXJJUVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 16:21:31 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:50081 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbXJJUVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 16:21:30 -0400
Date: Wed, 10 Oct 2007 14:21:28 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       parisc-linux-request@lists.parisc-linux.org,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Kyle McMartin <kyle@parisc-linux.org>
Subject: Re: parisc arch makefile clean-up needed [Was: cleaning up "make headers_install" for various architectures]
Message-ID: <20071010202128.GG2730@parisc-linux.org>
References: <Pine.LNX.4.64.0710101234340.32502@localhost.localdomain> <20071010095954.79c39a73.randy.dunlap@oracle.com> <Pine.LNX.4.64.0710101324230.6071@localhost.localdomain> <20071010183858.GA2270@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071010183858.GA2270@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2007 at 08:38:58PM +0200, Sam Ravnborg wrote:
> parisc arch Makefile needs some love and care...

None of your comments actually address the thing that he was having
problems with:

ifneq ($(call cc-ifversion, -lt, 0303, "bad"),)
$(error Sorry, GCC v3.3 or above is required.)
endif

Now, compiler.h has some checks like:

#elif __GNUC__ == 3 && __GNUC_MINOR__ >= 2
# include <linux/compiler-gcc3.h>
#else
# error Sorry, your compiler is too old/not recognized.
#endif

But it doesn't permit us to rule out gcc 3.3 unless we patch compiler.h.
There's no asm/compiler.h, for example.  Obviously, we could put some
tests for compiler version in arch/parisc somewhere.  Where's the right
place these days?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
