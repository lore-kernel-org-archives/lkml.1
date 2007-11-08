Return-Path: <linux-kernel-owner+w=401wt.eu-S1758360AbXKHFgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360AbXKHFgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 00:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750738AbXKHFgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 00:36:16 -0500
Received: from ozlabs.org ([203.10.76.45]:47260 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbXKHFgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 00:36:15 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18226.41032.912666.467900@cargo.ozlabs.ibm.com>
Date: Thu, 8 Nov 2007 16:36:08 +1100
From: Paul Mackerras <paulus@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml@davidb.org, linux-kernel@vger.kernel.org, drepper@redhat.com,
       mtk-manpages@gmx.net
Subject: Re: compat_sys_times() bogus until jiffies >= 0.
In-Reply-To: <20071107212005.f039c279.akpm@linux-foundation.org>
References: <20071107224722.GA20204@old.davidb.org>
	<20071107152833.6f302c2a.akpm@linux-foundation.org>
	<20071107161853.044b6e8f.akpm@linux-foundation.org>
	<18226.27701.782268.375231@cargo.ozlabs.ibm.com>
	<20071107190714.9c404e28.akpm@linux-foundation.org>
	<18226.38816.486372.52353@cargo.ozlabs.ibm.com>
	<20071107212005.f039c279.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes:

> Yup.  But userspace will already have a fit if either the start or end time
> advanced into the glibc-thought-that-was-an-error range.

Not nearly as much of a fit.  The effect on x86 is that values between
-4095 and -1 are reported as -1, so the end-start difference will be
out by less than 41 seconds.  That's not nearly as dramatic as a
difference of 21 million seconds (over 16 years). :)

I really think that wrapping at 0x7fffffff makes the situation worse,
not better.

Paul.
