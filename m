Return-Path: <linux-kernel-owner+w=401wt.eu-S1751379AbXCHD1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379AbXCHD1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 22:27:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbXCHD1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 22:27:12 -0500
Received: from ozlabs.org ([203.10.76.45]:55106 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbXCHD1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 22:27:11 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17903.33399.786962.498809@cargo.ozlabs.ibm.com>
Date: Thu, 8 Mar 2007 14:26:47 +1100
From: Paul Mackerras <paulus@samba.org>
To: Bill Huey (hui) <billh@gnuppy.monkey.org>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Tsutomu OWA <tsutomu.owa@toshiba.co.jp>, linuxppc-dev@ozlabs.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/6 -rt] powerpc 2.6.20-rt8: to convert spinlocks to raw ones.
In-Reply-To: <20070308004344.GA23200@gnuppy.monkey.org>
References: <yyi8xe925vg.wl@toshiba.co.jp>
	<yyi649d25qz.wl@toshiba.co.jp>
	<45EECE5C.6030100@ru.mvista.com>
	<17902.60669.945986.186995@cargo.ozlabs.ibm.com>
	<45EEF6A4.9090807@ru.mvista.com>
	<17903.4302.502364.126701@cargo.ozlabs.ibm.com>
	<45EF2CD8.3050804@ru.mvista.com>
	<17903.12035.781782.317694@cargo.ozlabs.ibm.com>
	<20070308004344.GA23200@gnuppy.monkey.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Huey (hui) writes:

> The places that need to be reverted to raw spinlocks are generally either
> acquired by function calls that allocate the spinlock at a terminal of the
> kernel's lock graph or isolated from other callers completely (parts of the
> timer for logic for instance). It's all about the collision of various lock
> (preemptive and non-preemptive) subtrees and how to avoid scheduling within
> atomic violations that lead to deadlocks. The -rt patch gets arbitrary
> preemption abilities by shrinking the non-preemptive sub-tree bit to the bare
> essentials of what will let a system to run yet still preserve all of
> the expected locking semantics of a critical section.

Thanks; that's an interesting explanation.

It misses the point of what I was saying to Sergei, though, which was
*not* "I don't understand your patch", it was "if this patch goes into
a git tree, someone coming along in 3 years time won't understand the
patch."  In other words I was ranting about the need for a decent
description to accompany the patch itself, so it would go into the
permanent record.

Regards,
Paul.
