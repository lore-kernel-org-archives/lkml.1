Return-Path: <linux-kernel-owner+w=401wt.eu-S1763098AbYETIle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763098AbYETIle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 04:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757768AbYETIl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 04:41:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48781 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758667AbYETIlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 04:41:24 -0400
Date: Tue, 20 May 2008 09:26:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Roland Dreier <rdreier@cisco.com>
Cc: corbet@lwn.net (Jonathan Corbet),
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH, RFC] Char dev BKL pushdown v2
Message-ID: <20080520092651.79766c94@core>
In-Reply-To: <aday7665469.fsf@cisco.com>
References: <19108.1211229722@vena.lwn.net>
	<aday7665469.fsf@cisco.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thanks.  Just to be super-explicit, ioctl() cannot be called on a given
> file until the open() for that particular file has returned, right?

Right. Or two ioctls against each other unless one sleepers, or against
random other parts of the kernel which still use the BKL - eg fasync,
bits of procfs ...

> And the point about driver initialization is that open() can be called
> as soon as the file operations are registered, even if the module_init
> function has not returned?

Exactly.

Alan
