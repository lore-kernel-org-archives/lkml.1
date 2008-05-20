Return-Path: <linux-kernel-owner+w=401wt.eu-S933824AbYETV1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933824AbYETV1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 17:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759738AbYETV1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 17:27:44 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:43162 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758213AbYETV1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 17:27:43 -0400
Date: Tue, 20 May 2008 17:27:35 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Tom Spink <tspink@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: UML fails to locate address space
Message-ID: <20080520212735.GA13319@c2.user-mode-linux.org>
References: <7b9198260805200408k1d6b70a8xc7e4c24106e5020f@mail.gmail.com> <20080520135238.GB6990@c2.user-mode-linux.org> <7b9198260805200659p6ed28403t9b0b0ea995f158d5@mail.gmail.com> <20080520161047.GA9598@c2.user-mode-linux.org> <7b9198260805200943x6fb15512o7ba35a40d006b215@mail.gmail.com> <20080520175624.GA10889@c2.user-mode-linux.org> <7b9198260805201101x5b0fabf8h4944a29c6a4cae96@mail.gmail.com> <20080520192436.GA12102@c2.user-mode-linux.org> <7b9198260805201242p1adf4651kb4c434d73884b6c1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b9198260805201242p1adf4651kb4c434d73884b6c1@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 08:42:54PM +0100, Tom Spink wrote:
> And this is what I did:

Looks OK, but I need a Signed-off-by.

Some style comments, which I can take care of if you don't feel like it:
	there's only one use of PROC_MMAP_MIN_ADDR, so you might as
well inline the filename
	the stat is unnecessary - open failing will tell you what you
need to know
	the strtoul needs some error checking
	I'd change the mmap_min_addr[8] to [sizeof("12345678")] to
make it clear what's expected to fit into it

On a less-stylistic note, this thing does have to work in the absence
of /proc since UML is commonly run inside chroot.  So, I'm thinking we
still need the loop looking for the bottom of the address space in
this case.  And, if you have it, you might as well use it, as that's
less code, and it makes sure the loop is exercised.  That grieves me a
little, as I'd like to just read mmap_min_addr and be done with it in
the normal case.

			Jeff

-- 
Work email - jdike at linux dot intel dot com
