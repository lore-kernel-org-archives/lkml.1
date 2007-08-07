Return-Path: <linux-kernel-owner+w=401wt.eu-S1760371AbXHGTkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760371AbXHGTkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 15:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755007AbXHGTkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 15:40:37 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51711 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754558AbXHGTkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 15:40:36 -0400
Date: Tue, 7 Aug 2007 12:40:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH] msleep() with hrtimers
Message-Id: <20070807124009.9f6c2247.akpm@linux-foundation.org>
In-Reply-To: <15327.1186166232@lwn.net>
References: <15327.1186166232@lwn.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Aug 2007 12:37:12 -0600
Jonathan Corbet <corbet@lwn.net> wrote:

> 
> Here's the second (and probably final) posting of the msleep() with
> hrtimers patch.  The problem being addressed here is that the current
> msleep() will stop for a minimum of two jiffies, meaning that, on a
> HZ=100 system, msleep(1) delays for for about 20ms.  In a driver with
> one such delay for each of 150 or so register setting operations, the
> extra time adds up to a few seconds.
> 
> This patch addresses the situation by using hrtimers.  On tickless
> systems with working timers, msleep(1) now sleeps for 1ms, even with
> HZ=100.
> 
> Most comments last time were favorable.  The one dissenter was Roman,
> who worries about the overhead of using hrtimers for this operation; my
> understanding is that he would rather see a really_msleep() function for
> those who actually want millisecond resolution.  I'm not sure how to
> characterize what the cost could be, but it can only be buried by the
> fact that every call sleeps for some number of milliseconds.  On my
> system, the several hundred total msleep() calls can't cause any real
> overhead, and almost all happen at initialization time.

I'd be surprised if there was significant overhead - the maximum frequency
at which msleep() can be called is 1000Hz.  We'd need an awful lot of
overhead for that to cause problems, surely?

<thinks he's missing something again>
