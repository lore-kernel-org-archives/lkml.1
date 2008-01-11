Return-Path: <linux-kernel-owner+w=401wt.eu-S1762158AbYAKVb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762158AbYAKVb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 16:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760396AbYAKVbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 16:31:53 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760296AbYAKVbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 16:31:52 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm] x86_64 save_i387_ia32 snafu
In-Reply-To: Ingo Molnar's message of  Friday, 11 January 2008 11:49:32 +0100 <20080111104932.GA1589@elte.hu>
References: <4786A9CA.2090008@zytor.com>
	<20080111004422.2B3F926F9A6@magilla.localdomain>
	<4786BE15.6040604@zytor.com>
	<20080111024929.37FDB26F9A9@magilla.localdomain>
	<4786DB3B.8070808@zytor.com>
	<20080111104357.8364826F9A9@magilla.localdomain>
	<20080111104932.GA1589@elte.hu>
X-Windows: it was hard to write; it should be hard to use.
Message-Id: <20080111213147.EBE0C26F9A9@magilla.localdomain>
Date: Fri, 11 Jan 2008 13:31:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> thanks, applied. Does this explain the crash/hang problems with 32-bit 
> apps on 64-bit kernels? What was the exact failure mode?

It does.  Any 32-bit process trying to run a signal handler when it had
used the FPU, would clobber "current" with FP bits.  The observed failure
mode was shortly after this in the signal handler setup code, when it
crashed due to current->mm being zero (current->pid also being zero, and
the whole first 512 bytes of the task_struct being garbage).


Thanks,
Roland
