Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbXJJTil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbXJJTil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 15:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbXJJTic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 15:38:32 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:39180 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbXJJTib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 15:38:31 -0400
Date: Wed, 10 Oct 2007 15:38:27 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       parisc-linux-request@lists.parisc-linux.org,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       Kyle McMartin <kyle@parisc-linux.org>
Subject: Re: parisc arch makefile clean-up needed [Was: cleaning up "make headers_install" for various architectures]
Message-ID: <20071010193827.GE2746@fattire.cabal.ca>
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
> 

It basically hasn't been touched since 2.4, I already have a patch to
clean up a lot of things when Randy pointed it out a while ago. Thanks
for the reminder, I'll queue it for 2.6.24.

Regards,
	Kyle

> The logic selecting CROSS_COMPILE seems fishy and wrong -
> the error reported by rday is obvious in this respect.
> 
> FINAL_LD is unused - kill it.
> 
> Building with oldpalo has been broken for a loong time - time to kill it?
> Hint - the "cd ../palo" is not working as expected.
> And use of TOPDIR is deprecated.
> 
> The libs-y assignment should learn from the other architectures how to
> get the gcc lib filename:
> $(shell $(CC) $(CFLAGS) -print-libgcc-file-name)
> 
> 
> And this snippet is also wrong:
> PALO := $(shell if which palo; then : ; \
> 	elif [ -x /sbin/palo ]; then echo /sbin/palo; \
> 	fi)
> 
> palo: vmlinux
> 	@if [ -x $PALO ]; then \
> 
> 
> Make does not export variables so $PALO is not the same as $(PALO).
> The latter should be used.
> 
> I did not supply a patch because I do not fully understand the
> logic behind setting CROSS_COMPILE and 64BIT or not.
> But I will be happy to review a patch to fix the issues in the
> parisc Makefile.

I'll add this to the patch as well.
