Return-Path: <linux-kernel-owner+w=401wt.eu-S1761999AbZEAN5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761999AbZEAN5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 09:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759105AbZEAN4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 09:56:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54273 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760364AbZEAN4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 09:56:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 04/27] asm-generic: add legacy I/O header files
Date: Fri, 1 May 2009 15:56:38 +0200
User-Agent: KMail/1.9.9
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, Michal Simek <monstr@monstr.eu>,
       linux-arch@vger.kernel.org,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
References: <cover.1241105648.git.arnd@arndb.de> <200905011529.04774.arnd@arndb.de> <20090501144420.5a3e9c6e@lxorguk.ukuu.org.uk>
In-Reply-To: <20090501144420.5a3e9c6e@lxorguk.ukuu.org.uk>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905011556.39437.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18Q4JIJ5D7xC4NUoZ7RypawzWYGn1LeBT49Myz
 ImSMjngzrU+llOmrttxtCagMa9uuK0RQnvucobAaiZ1DN7uvVS
 tUhdwIPePXC4IbRsr4AxA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 May 2009, Alan Cox wrote:
> They shouldn't define it - we want those invalid cases to error. Stick
> CLOCK_TICK_RATE in the depths of the x86 arch includes and then we can
> fix the other cases properly. Either the device has an independant clock
> of the same frequency (some watchdogs do this), it relies upon a
> motherboard timer in which case the platform can define CLOCK_TICK_RATE
> (or a better name for it), or it doesn't have any meaning in which case
> we *want* it not to compile.

I just noticed that linux/jiffies.h does not compile without a definition
of CLOCK_TICK_RATE, so that's probably why every architecture defines it.
If I find a way to remove that dependency, I can simply leave out the
CLOCK_TICK_RATE from the generic header. I have not yet understood the
relation of jiffies to CLOCK_TICK_RATE, but my suspicion is that it's
not good for architectures that do not have a clock tick.

	Arnd <><
