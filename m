Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbYLLUNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbYLLUNZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 15:13:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbYLLUNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 15:13:16 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40783 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbYLLUNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 15:13:16 -0500
Date: Fri, 12 Dec 2008 20:12:39 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Scott Lurndal <scott.lurndal@3leafsystems.com>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH v2] Add preadv and pwritev system calls.
Message-ID: <20081212201239.GE5774@flint.arm.linux.org.uk>
Mail-Followup-To: Gerd Hoffmann <kraxel@redhat.com>,
	Scott Lurndal <scott.lurndal@3leafsystems.com>,
	Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>
References: <1229090440-32120-1-git-send-email-kraxel@redhat.com> <20081212152929.GM26095@parisc-linux.org> <494287D4.2070909@redhat.com> <20081212155113.GO26095@parisc-linux.org> <49428AFD.5090009@redhat.com> <20081212182929.GA9631@pendragon.3leafnetworks.com> <20081212190728.GC5774@flint.arm.linux.org.uk> <4942C1D0.1080009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4942C1D0.1080009@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 08:56:00PM +0100, Gerd Hoffmann wrote:
> Russell King wrote:
> >> should be similar to pread/pwrite, e.g:
> >>
> >>     int preadv(fd, iovec, iovec_size, offset)
> > 
> > Yes, and that's easy for glibc to achieve.
> 
> This hints the ABI problem exists at syscall level only.  Is that
> correct?  So we can have
> 
> 	preadv(fd, vec, vlen, off)
> 
> argument ordering at app <-> glibc level and
> 
> 	preadv(fd, vec, off, vlen)
> 
> ordering at glibc <-> kernel (aka syscall) level and it works fine for
> ARM + MIPS + PARISC?

Fine for ARM - and yes, the user visible API should be changed from the
BSD standard.  I don't think anyone in this thread was suggesting that
the user visible argument ordering should be any different from the
original.

Having it in a different order from *BSD at the libc visible interface
is just crazy from the OS portability point of view.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
