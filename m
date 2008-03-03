Return-Path: <linux-kernel-owner+w=401wt.eu-S1753339AbYCCL4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbYCCL4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 06:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbYCCL4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 06:56:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34644 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbYCCL4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 06:56:03 -0500
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Should a x86 gdb work under an x86_64 kernel?
From: Andi Kleen <andi@firstfloor.org>
References: <E1JTeeF-0005dk-Nv@closure.thunk.org>
Date: Mon, 03 Mar 2008 12:56:00 +0100
In-Reply-To: <E1JTeeF-0005dk-Nv@closure.thunk.org> (Theodore Ts'o's message of "Mon\, 25 Feb 2008 09\:49\:43 -0500")
Message-ID: <p73zltg6my7.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Theodore Ts'o" <tytso@mit.edu> writes:

> Hi,
>
> 	I've noticed that if I try to use a 32-bit x86 gdb to debug a
> 32-bit program under a 64-bit x86_64 kernel, gdb (version 6.6-debian,
> from Ubuntu Gutsy) immediately core dumps as soon as I run the test
> program under the debugger.  Is this normal/expected/known bug?

It's clearly a bug. x86-64 compat user space should be 99+% compatible
and running full 32bit user land with a 64bit kernel is supposed to work.

The main exceptions are a few programs that rely on the 3GB address space
(these can be used with linux32 --3gb), some programs which
make bogus assumptions about /proc,/sys which cannot be fixed
and a few programs which use obscure driver specific ioctls with
no compat wrapper.

-Andi
