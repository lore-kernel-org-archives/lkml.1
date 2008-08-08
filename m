Return-Path: <linux-kernel-owner+w=401wt.eu-S1755317AbYHHG3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbYHHG3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 02:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbYHHG3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 02:29:41 -0400
Received: from gw.goop.org ([64.81.55.164]:48836 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbYHHG3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 02:29:40 -0400
Message-ID: <489BE7C5.6000806@goop.org>
Date: Thu, 07 Aug 2008 23:29:25 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Michael Davidson <md@google.com>
CC: mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: prevent binaries from making system calls using
 the wrong syscall interface
References: <20080807003459.37CC629624@localhost>
In-Reply-To: <20080807003459.37CC629624@localhost>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Davidson wrote:
> Prevent binaries from making system calls using other than one
> of the "normal" system call interfaces for that binary type.
>
> Currently there is nothing to prevent 64 bit binaries from
> attempting to make system calls using the 32 bit system call
> interfaces and vice versa.
>   

No.  While I'm not sure it's been used, it would definitely be useful to 
be able to invoke 32-bit int 0x80 syscalls in 64-bit bit process for 
something like Valgrind.

Issuing 64-bit syscalls from a 32-bit process would be... interesting.

> Since the 32 bit and 64 bit system call numbers are different
> this means that a binary could attempt to obfuscate which system
> calls it was actually making by using the "wrong" system call
> interface. In particular, the call to audit_syscall_entry()
> relies on checking the TIF_IA32 flag to determine whether it is
> dealing with a 32 or 64 bit system call without regard to the
> actual type of system call that was made.

Or just have separate 32-compat vs 64 bit audit paths which can clearly 
make the distinction.

    J
