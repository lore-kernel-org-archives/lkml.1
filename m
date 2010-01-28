Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550Ab0A1W1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab0A1W1b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 17:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307Ab0A1W1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 17:27:30 -0500
Received: from ozlabs.org ([203.10.76.45]:44383 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741Ab0A1W13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 17:27:29 -0500
Date: Fri, 29 Jan 2010 09:27:13 +1100
From: Paul Mackerras <paulus@samba.org>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] perf: Add util/include/linux/config.h for including
 generated autoconf.h of kernel
Message-ID: <20100128222713.GC2585@brick.ozlabs.ibm.com>
References: <4B6133DF.9080207@dcl.info.waseda.ac.jp>
 <1264688928-12861-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264688928-12861-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 11:28:48PM +0900, Hitoshi Mitake wrote:

> I'd like to add util/include/linux/config.h,
> this header file includes autoconf.h which is generated
> by build phase of kernel.
> 
> This makes building of perf depend on building of kernel.
> It's a little dirty. But perf has tight relation
> of its kernel, so I don't think that it is a serious problem.
> 
> My original purpose of making this patch is
> knowing size of void *.
> If config.h is available,
> CONFIG_ARCH_PHYS_ADDR_T_64BIT will be provided for source of perf,
> we can know size of void * by this config.
> 
> How do you think?

How will this work if I built the kernel in a separate object
directory (e.g., using "make O=../builddir vmlinux")?  I think that
trying to include generated files will fail in that case.

In general I think that tying perf to the kernel config is a bad idea.

Paul.
