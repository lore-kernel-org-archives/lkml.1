Return-Path: <linux-kernel-owner+w=401wt.eu-S1762530AbZEAODH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762530AbZEAODH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 10:03:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760394AbZEAOCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:02:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33502 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758429AbZEAOCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:02:51 -0400
Date: Fri, 1 May 2009 15:03:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, Michal Simek <monstr@monstr.eu>,
       linux-arch@vger.kernel.org,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/27] asm-generic: add legacy I/O header files
Message-ID: <20090501150319.192f6dce@lxorguk.ukuu.org.uk>
In-Reply-To: <200905011556.39437.arnd@arndb.de>
References: <cover.1241105648.git.arnd@arndb.de>
	<200905011529.04774.arnd@arndb.de>
	<20090501144420.5a3e9c6e@lxorguk.ukuu.org.uk>
	<200905011556.39437.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I just noticed that linux/jiffies.h does not compile without a definition
> of CLOCK_TICK_RATE, so that's probably why every architecture defines it.

It should do so just fine what errors are you seeing ?

CLOCK_TICK_RATE produces ACTHZ and LATCH

ACTHZ is specific to the jiffies timer (and requires CLOCK_TICK_RATE
represents the input frequency that is divided to generate the target HZ
value for the system), LATCH is used in a couple of ugly bits of x86 code
and can probably now go away.

So we now have at least two conflicting meanings for CLOCK_TICK_RATE
which again says it needs fixing not wallpapering over.

Alan
