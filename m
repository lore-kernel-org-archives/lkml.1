Return-Path: <linux-kernel-owner+w=401wt.eu-S1763917AbYETNw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763917AbYETNw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 09:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754739AbYETNwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 09:52:50 -0400
Received: from [198.99.130.12] ([198.99.130.12]:39992 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754354AbYETNwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 09:52:50 -0400
Date: Tue, 20 May 2008 09:52:38 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Tom Spink <tspink@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: UML fails to locate address space
Message-ID: <20080520135238.GB6990@c2.user-mode-linux.org>
References: <7b9198260805200408k1d6b70a8xc7e4c24106e5020f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b9198260805200408k1d6b70a8xc7e4c24106e5020f@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 12:08:24PM +0100, Tom Spink wrote:
> I've just recently pulled the latest GIT and compiled UML, however,
> when I run it a message appears saying "Locating the top of the
> address space... Address 0x0 no good?" and the program exits.

Can you strace it and send me the output?

> After some digging, it appears that page_ok is returning false when
> checking 'bottom', in os_get_task_size
> (arch/um/os-Linux/sys-i386/task_size.c:96).  After running through
> GDB, it seems that in line 31 of that file is where the segfault
> occurs:
> 
> n = *address;
> 
> i.e. when trying to read from the address space (at address zero).

The segfaults are on purpose - it will trap SIGSEGV and longjmp out of
the handler and mark the affected address as not-usable.

    	       	  Jeff

-- 
Work email - jdike at linux dot intel dot com
