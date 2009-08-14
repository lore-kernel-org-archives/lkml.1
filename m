Return-Path: <linux-kernel-owner+w=401wt.eu-S1753504AbZHNJql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbZHNJql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 05:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753158AbZHNJqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 05:46:40 -0400
Received: from www.lumino.de ([85.159.12.10]:49068 "HELO imap.lumino.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752473AbZHNJqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 05:46:39 -0400
Message-ID: <4A85327D.2040003@lumino.de>
Date: Fri, 14 Aug 2009 11:46:37 +0200
From: Michael Schnell <mschnell@lumino.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: implementing Futex
References: <4A842B32.5030401@lumino.de> <200908131839.41803.arnd@arndb.de>
In-Reply-To: <200908131839.41803.arnd@arndb.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:

>
> The sh version just disables interrupts to get atomicity.
>

Looking at the sh - code it seem that there is no real difference (but
the operation itself) between "futex_atomuic_op_inuser" and
"futex_atomic_cmp_inatomic".

Does that mean that both in fact do run in the same mode (I suppose
Kernel Mode and thus the CPU's "System Mode" rather than the CPU's "User
Mode".

With that - and supposing that as of Kernel 2.6.31 the sh code I see in
Kernel 2.6.30 is used in /asm/generic, I would be able to just use the
"generic" case for "implementing" a working Futex syscall for the NIOS).

This given, I could concentrate on the User part (pthread_mutex_XXX() in
glibc). What a nice option :)

-Michael
