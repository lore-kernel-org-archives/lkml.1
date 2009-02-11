Return-Path: <linux-kernel-owner+w=401wt.eu-S1755360AbZBKIsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbZBKIsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 03:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbZBKIsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 03:48:05 -0500
Received: from viefep17-int.chello.at ([62.179.121.37]:30509 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbZBKIsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 03:48:04 -0500
X-SourceIP: 213.46.9.244
Subject: Re: 2.6.29-rc3: BUG: scheduling while atomic: udevd/917/0x10000100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090211083217.GC21105@elte.hu>
References: <19f34abd0902110009g4cdb1754na1cbf0acb6a93cce@mail.gmail.com>
	 <20090211083217.GC21105@elte.hu>
Content-Type: text/plain
Date: Wed, 11 Feb 2009 09:49:49 +0100
Message-Id: <1234342189.23438.113.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-11 at 09:32 +0100, Ingo Molnar wrote:

> There's a fourth possibility:
> 
>  - Given that it's udevd that does it - maybe we leaked a softirq preempt
>    count in some rare sysfs file, and it did not get discovered until the
>    next innocent piece of kernel code preempted?
> 
> But i thought lockdep would already warn if we exited a syscall with locks
> held or with a preempt count elevated - Peter?

>From a quick look it only checks task->lockdep_depth, in
lockdep_sys_exit().



