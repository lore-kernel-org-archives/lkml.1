Return-Path: <linux-kernel-owner+w=401wt.eu-S1755084AbZHDH6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbZHDH6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 03:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754577AbZHDH6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 03:58:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753174AbZHDH6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:58:17 -0400
Date: Tue, 4 Aug 2009 00:57:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] posix-timers: fix oops in clock_nanosleep() with
 CLOCK_MONOTONIC_RAW
Message-Id: <20090804005753.99e21163.akpm@linux-foundation.org>
In-Reply-To: <4A77E62D.8070803@ct.jp.nec.com>
References: <4A764FF3.50607@ct.jp.nec.com>
	<20090804002226.2972cf47.akpm@linux-foundation.org>
	<4A77E62D.8070803@ct.jp.nec.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Aug 2009 16:41:33 +0900 Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> Userspace program is like this;
> 
> #include <time.h>
> 
> int main(void)
> {
> 	struct timespec ts;
> 
> 	ts.tv_sec = 1;
> 	ts.tv_nsec = 0;
> 
> 	return clock_nanosleep(4, 0, &ts, NULL);
> }
> 
> and it will cause oops;
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000001

Well that's not very good.

How far back does this go?  posix-timers.c hasn't changed in several
kernel versions.

