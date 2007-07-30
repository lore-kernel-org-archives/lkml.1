Return-Path: <linux-kernel-owner+w=401wt.eu-S1763883AbXG3XAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763883AbXG3XAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 19:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbXG3XAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 19:00:07 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35232 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751964AbXG3XAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 19:00:05 -0400
Date: Mon, 30 Jul 2007 15:59:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Christian P. Schmidt" <charlie@digadd.de>
Cc: linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
Subject: Re: ttyS1: LSR safety check engaged! - misidentification?
Message-Id: <20070730155939.9bf43314.akpm@linux-foundation.org>
In-Reply-To: <46ACB1C2.6030701@digadd.de>
References: <46ACB1C2.6030701@digadd.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jul 2007 18:26:58 +0300
"Christian P. Schmidt" <charlie@digadd.de> wrote:

> Hi all,
> 
> Ever since Kernel 2.6.21(rc) or so I'm plagued with this message,
> disabling my serial ports that have been working perfectly from 2.6.14
> till that day (and are still doing so, given that I continuously remove
> the code from the source).
> Actually I cannot blame the code, but it seems that on both of my
> laptops the LSR is actually not readable. So, is there any plan to
> remove that piece of code again, or at least change it so it can be
> disabled conditionally?
> 

afaict this code:

	/*
	 * At this point, there's no way the LSR could still be 0xff;
	 * if it is, then bail out, because there's likely no UART
	 * here.
	 */
	if (!(up->port.flags & UPF_BUGGY_UART) &&
	    (serial_inp(up, UART_LSR) == 0xff)) {
		printk("ttyS%d: LSR safety check engaged!\n", up->port.line);
		return -ENODEV;
	}

is unchanged since 2.6.1, so I'm unsure what change you're proposing here?

