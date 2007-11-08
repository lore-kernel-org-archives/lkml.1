Return-Path: <linux-kernel-owner+w=401wt.eu-S1760633AbXKHGZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760633AbXKHGZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 01:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbXKHGZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 01:25:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59462
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751346AbXKHGZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 01:25:30 -0500
Date: Wed, 07 Nov 2007 22:25:30 -0800 (PST)
Message-Id: <20071107.222530.156152513.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: paulus@samba.org, lkml@davidb.org, linux-kernel@vger.kernel.org,
       drepper@redhat.com, mtk-manpages@gmx.net
Subject: Re: compat_sys_times() bogus until jiffies >= 0.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071107212005.f039c279.akpm@linux-foundation.org>
References: <20071107190714.9c404e28.akpm@linux-foundation.org>
	<18226.38816.486372.52353@cargo.ozlabs.ibm.com>
	<20071107212005.f039c279.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 7 Nov 2007 21:20:05 -0800

> Yup.  But userspace will already have a fit if either the start or end time
> advanced into the glibc-thought-that-was-an-error range.

On x86 only.  We could use force_successful_syscall_return()
to make sure the condition codes get set correctly on
other platforms.

But even in that case we'd still be broken when the return
value is exactly -1 and that's what the application is going
to compare against to test for errors.
