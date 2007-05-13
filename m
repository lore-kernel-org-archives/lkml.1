Return-Path: <linux-kernel-owner+w=401wt.eu-S1758011AbXEMHNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011AbXEMHNu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 03:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757023AbXEMHNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 03:13:43 -0400
Received: from www.osadl.org ([213.239.205.134]:35486 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755109AbXEMHNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 03:13:43 -0400
Subject: Re: [patch] make pit clocksource continuous
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Stas Sergeev <stsp@aknet.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <46464B5C.2080302@aknet.ru>
References: <46464B5C.2080302@aknet.ru>
Content-Type: text/plain
Date: Sun, 13 May 2007 09:16:51 +0200
Message-Id: <1179040612.22481.237.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-13 at 03:18 +0400, Stas Sergeev wrote:
> Hello.
> 
> Without the attached patch, I wasn't able
> to get the PIT to work as a clocksource for
> high-res timers.
> I don't know whether the patch is correct,
> but I tested it and it works.
> Can someone please tell me what exactly
> does this flag mean? google reveals nothing
> sensible to me, sorry...
> 
> ---
> Set CLOCK_SOURCE_IS_CONTINUOUS flag for the PIT clocksource

Ouch no. The PIT has no continuous counter, especially not when we use
the PIT to generate the next event interrupt with variable length
intervals. 

The PIT can only be used as a clock source, when it is in periodic mode,
but it is never continuous. If we miss one PIT interrupt the time
keeping is hosed.

	tglx


