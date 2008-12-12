Return-Path: <linux-kernel-owner+w=401wt.eu-S1753165AbYLLTLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbYLLTLt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 14:11:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbYLLTLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 14:11:40 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38076 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbYLLTLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 14:11:39 -0500
Date: Fri, 12 Dec 2008 19:02:42 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Wilcox <matthew@wil.cx>, Gerd Hoffmann <kraxel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH v2] Add preadv and pwritev system calls.
Message-ID: <20081212190242.GB5774@flint.arm.linux.org.uk>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Matthew Wilcox <matthew@wil.cx>, Gerd Hoffmann <kraxel@redhat.com>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	Ulrich Drepper <drepper@redhat.com>
References: <1229090440-32120-1-git-send-email-kraxel@redhat.com> <20081212152929.GM26095@parisc-linux.org> <494287D4.2070909@redhat.com> <20081212155113.GO26095@parisc-linux.org> <49428AFD.5090009@redhat.com> <20081212170347.GR26095@parisc-linux.org> <20081212182142.46dcf220@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081212182142.46dcf220@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 06:21:42PM +0000, Alan Cox wrote:
> On Fri, 12 Dec 2008 10:03:47 -0700
> Matthew Wilcox <matthew@wil.cx> wrote:
> 
> > On Fri, Dec 12, 2008 at 05:02:05PM +0100, Gerd Hoffmann wrote:
> > > I'd *really* hate it to have the same system call with different
> > > argument ordering on different systems though.  Especially when swapping
> > > two integer values, so gcc wouldn't error out on wrong usage.
> > 
> > We can always permute it further:
> > 
> > int fd, int vlen, loff_t pos, const struct *
> 
> Or you could add cobol calling syntax or pass the arguments in XML
> format ?
> 
> Any particular reason you want to make things hell for programmers and
> the standard people. Follow the BSD one at least to user space. Anything
> else will just lead to pain and suffering later on the standardisation
> front.

Yes - non-aligned 64-bit arguments in registers really really really
sucks.  On ARM, we will change the syscall argument ordering to avoid
having additional compatibility implementations for EABI vs OABI.

The same goes for similar ABIs with restrictions on 64-bit arguments.

There are causes were a syscall just can not be used on such ABIs.  Eg,

	int a1, unsigned long long a2, int a3, unsigned long long a4

is an impossible syscall argument order for ARM - we run out of registers
for the upper word of 'a4'.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
