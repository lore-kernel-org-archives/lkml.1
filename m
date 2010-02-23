Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab0BWU2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 15:28:05 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38271 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab0BWU2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 15:28:01 -0500
Date: Tue, 23 Feb 2010 21:27:59 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>
Subject: Re: [PATCH 02/10] ARM: ftrace: document mcount formats
Message-ID: <20100223202759.GC20792@pengutronix.de>
References: <1266090518-31120-1-git-send-email-rabin@rab.in> <1266090518-31120-3-git-send-email-rabin@rab.in> <20100213203748.GC16528@pengutronix.de> <20100222180624.GA4061@debian> <20100222192009.GA13527@pengutronix.de> <20100223194253.GB6325@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100223194253.GB6325@debian>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rabin,

> OK.  How about this for the last paragraph:
> 
>  mcount can be thought of as a function called in the middle of a
>  subroutine call.  As such, it needs to be transparent for both the
>  caller and the callee: the original lr needs to be restored when
>  leaving mcount, and no registers should be clobbered.  (In the
>  __gnu_mcount_nc implementation, we clobber the ip register.  This
>  is OK because the ARM calling convention allows it to be clobbered
>  in subroutines and doesn't use it to hold parameters.)
I rechecked the document describing the calling convention.  It writes
about ip:

Both the ARM- and Thumb-state BL instructions are unable to address the
full 32-bit address space, so it may be necessary for the linker to
insert a veneer between the calling routine and the called subroutine.
Veneers may also be needed to support ARM-Thumb inter-working or dynamic
linking.  Any veneer inserted must preserve the contents of all
registers except IP (r12) and the condition code flags; a conforming
program must assume that a veneer that alters IP may be inserted at any
branch instruction that is exposed to a relocation that supports inter-
working or long branches.

So the last sentence isn't completly accurate.  But describing the
actual situation is a bit overkill, so I'm OK with your suggestion.

Best regards and thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
