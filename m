Return-Path: <linux-kernel-owner+w=401wt.eu-S1753163AbYLOE5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbYLOE5b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 23:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbYLOE5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 23:57:20 -0500
Received: from ozlabs.org ([203.10.76.45]:54658 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003AbYLOE5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 23:57:20 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18757.55706.609537.196994@drongo.ozlabs.ibm.com>
Date: Mon, 15 Dec 2008 15:14:18 +1100
From: Paul Mackerras <paulus@samba.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Gerd Hoffmann <kraxel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH v2] Add preadv and pwritev system calls.
In-Reply-To: <20081212152929.GM26095@parisc-linux.org>
References: <1229090440-32120-1-git-send-email-kraxel@redhat.com>
	<20081212152929.GM26095@parisc-linux.org>
X-Mailer: VM 8.0.11 under Emacs 22.2.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox writes:

> On Fri, Dec 12, 2008 at 03:00:40PM +0100, Gerd Hoffmann wrote:
> > The patch sports the actual system call implementation and the windup in
> > the x86 system call tables.  Other archs are TBD.
> 
> > +asmlinkage ssize_t sys_preadv(unsigned long fd, const struct iovec __user *vec,
> > +                              unsigned long vlen, loff_t pos)
> > +asmlinkage ssize_t sys_pwritev(unsigned long fd, const struct iovec __user *vec,
> > +                               unsigned long vlen, loff_t pos)
> 
> Are these prototypes required?  MIPS and PARISC will need wrappers to
> fix them if they are.  These two architectures have an ABI which
> requires 64-bit arguments to be passed in aligned pairs of registers,

As does 32-bit PowerPC, so I also would prefer the alternate argument
order for the syscall (pos as the 3rd argument).

Paul.
