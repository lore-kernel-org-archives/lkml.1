Return-Path: <linux-kernel-owner+w=401wt.eu-S1756594AbYHHLQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594AbYHHLQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 07:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754282AbYHHLQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 07:16:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46494 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179AbYHHLQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 07:16:34 -0400
To: md@google.com (Michael Davidson)
Cc: mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: prevent binaries from making system calls using the wrong syscall interface
From: Andi Kleen <andi@firstfloor.org>
References: <20080807003459.37CC629624@localhost>
Date: Fri, 08 Aug 2008 13:16:32 +0200
In-Reply-To: <20080807003459.37CC629624@localhost> (Michael Davidson's message of "Wed,  6 Aug 2008 17:34:59 -0700 (PDT)")
Message-ID: <87ljz74uzz.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

md@google.com (Michael Davidson) writes:

> Prevent binaries from making system calls using other than one
> of the "normal" system call interfaces for that binary type.
>
> Currently there is nothing to prevent 64 bit binaries from
> attempting to make system calls using the 32 bit system call
> interfaces and vice versa.

nack. That was allowed intentionally because there are some
use cases for 32bit syscalls from 64bit (e.g. 64bit JIT running 
32bit executable). I believe it is used in production in 
a few cases.

>
> Since the 32 bit and 64 bit system call numbers are different
> this means that a binary could attempt to obfuscate which system
> calls it was actually making by using the "wrong" system call
> interface. In particular, the call to audit_syscall_entry()
> relies on checking the TIF_IA32 flag to determine whether it is
> dealing with a 32 or 64 bit system call without regard to the
> actual type of system call that was made.While this specific issue
> could be addressed by checking the TS_COMPAT flag in threadinfo_status
> it seems preferable to simply disallow this situation altogether.

audit is wrong to assume this and should be just fixed 

-Andi
