Return-Path: <linux-kernel-owner+w=401wt.eu-S1760414AbXKHGW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760414AbXKHGW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 01:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbXKHGWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 01:22:50 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36606
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751329AbXKHGWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 01:22:49 -0500
Date: Wed, 07 Nov 2007 22:22:48 -0800 (PST)
Message-Id: <20071107.222248.29361088.davem@davemloft.net>
To: paulus@samba.org
Cc: akpm@linux-foundation.org, lkml@davidb.org, linux-kernel@vger.kernel.org,
       drepper@redhat.com, mtk-manpages@gmx.net
Subject: Re: compat_sys_times() bogus until jiffies >= 0.
From: David Miller <davem@davemloft.net>
In-Reply-To: <18226.38816.486372.52353@cargo.ozlabs.ibm.com>
References: <18226.27701.782268.375231@cargo.ozlabs.ibm.com>
	<20071107190714.9c404e28.akpm@linux-foundation.org>
	<18226.38816.486372.52353@cargo.ozlabs.ibm.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mackerras <paulus@samba.org>
Date: Thu, 8 Nov 2007 15:59:12 +1100

> Not on powerpc.  On powerpc the error indication is carried separately
> in a condition register bit.  So a force_successful_syscall_return()
> call will make glibc automatically do the right thing without any
> glibc changes on powerpc.

It still won't fix the problem.

When the return value is (clock_t) -1, all the
force_successful_syscall_return() calls and glibc condition
codes checks in the world are not going to fix the application
code which checks for error using -1.
