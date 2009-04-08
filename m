Return-Path: <linux-kernel-owner+w=401wt.eu-S1762536AbZDHGSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762536AbZDHGSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 02:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755139AbZDHGSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 02:18:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47602 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbZDHGSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 02:18:32 -0400
Date: Wed, 8 Apr 2009 08:18:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Christian Pellegrin <chripell@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [-rc1, build bug] Re: [PATCH 05/11] Add support for the MAX3100
	SPI UART.
Message-ID: <20090408061811.GA22767@elte.hu>
References: <20090407154715.18020.44616.stgit@t61.ukuu.org.uk> <20090407154840.18020.82549.stgit@t61.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090407154840.18020.82549.stgit@t61.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> From: Christian Pellegrin <chripell@gmail.com>
> 
> (akpm: queued pending confirmation of the new major number)
> 
> [randy.dunlap@oracle.com: select SERIAL_CORE]
> Signed-off-by: Christian Pellegrin <chripell@fsfe.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
> ---
> 
>  drivers/serial/Kconfig      |    7 +++++++
>  drivers/serial/Makefile     |    1 +
>  include/linux/serial_core.h |    3 +++
>  3 files changed, 11 insertions(+), 0 deletions(-)

This is now upstream as:

  1dcb884: Add support for the MAX3100 SPI UART.

i'm not sure whether it has been reported already, but the new 
driver does not even build:

   CHK     include/linux/compile.h
 make[2]: *** No rule to make target `drivers/serial/max3100.o', needed by `drivers/serial/built-in.o'.  Stop.
 make[1]: *** [drivers/serial] Error 2
 make[1]: *** Waiting for unfinished jobs....

... and it has no chance to build, because the commit adds no 
max3100.c driver file, at all.

The straight revert of 1dcb884 got the build going.

	Ingo
