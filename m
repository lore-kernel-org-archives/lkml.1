Return-Path: <linux-kernel-owner+w=401wt.eu-S1751152AbZHRWYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751152AbZHRWYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 18:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750926AbZHRWYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 18:24:35 -0400
Received: from www.tglx.de ([62.245.132.106]:55249 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbZHRWYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 18:24:35 -0400
Date: Wed, 19 Aug 2009 00:24:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Kumar Gala <galak@kernel.crashing.org>
cc: Linux-Kernel List <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: spin_is_locked() broken for uniprocessor?
In-Reply-To: <DE9C9034-D2CE-4D21-93D9-A10FE2580920@kernel.crashing.org>
Message-ID: <alpine.LFD.2.00.0908190022570.3361@localhost.localdomain>
References: <DE9C9034-D2CE-4D21-93D9-A10FE2580920@kernel.crashing.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Aug 2009, Kumar Gala wrote:
> I just want to validate that what I'm seeing (for UP, non-debug features):
> 
> spin_is_locked() is defined as:
> 
> include/linux/spinlock.h:#define spin_is_locked(lock)
> __raw_spin_is_locked(&(lock)->raw_lock)
> 
> for UP that should get us:
> 
> include/linux/spinlock_up.h:#define __raw_spin_is_locked(lock)  ((void)(lock),
> 0)
> 
> which implies to me that spin_is_locked() will always return false.  Is this
> expected behavior.

That's wrong. spin_is_locked should always return true on UP.

Thanks,

	tglx
