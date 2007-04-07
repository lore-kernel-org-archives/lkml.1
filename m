Return-Path: <linux-kernel-owner+w=401wt.eu-S965743AbXDGKTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965743AbXDGKTw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 06:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965745AbXDGKTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 06:19:52 -0400
Received: from smtp.osdl.org ([65.172.181.24]:49955 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965743AbXDGKTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 06:19:51 -0400
Date: Sat, 7 Apr 2007 03:19:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com, mingo@elte.hu
Subject: Re: [PATCH] timekeeping: drop irq-context clocksource polling
Message-Id: <20070407031922.ee49478f.akpm@linux-foundation.org>
In-Reply-To: <20070405210316.785839431@mvista.com>
References: <20070405210316.785839431@mvista.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Apr 2007 14:03:16 -0700 Daniel Walker <dwalker@mvista.com> wrote:

> Before this change the timekeeping code would poll the clocksource
> list every interrupt. This changes that so the clocksource list is
> only checked when there has been and update, and no longer checks
> in interrupt context.

I get a complete lockup on i386 SMP - before the kernel has printed anything.

I'm suspecting a recursive taking of xtime_lock.
