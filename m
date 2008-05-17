Return-Path: <linux-kernel-owner+w=401wt.eu-S1757176AbYEQPaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbYEQPaz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 11:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754235AbYEQPas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 11:30:48 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:52016 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657AbYEQPar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 11:30:47 -0400
Date: Sun, 18 May 2008 00:31:57 +0900 (JST)
Message-Id: <20080518.003157.126143021.anemo@mba.ocn.ne.jp>
To: macro@linux-mips.org
Cc: khali@linux-fr.org, a.zummo@towertech.it, akpm@linux-foundation.org,
       dwmw2@infradead.org, ralf@linux-mips.org, tglx@linutronix.de,
       rtc-linux@googlegroups.com, i2c@lm-sensors.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] RTC: SMBus support for the M41T80, etc. driver (#2)
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <Pine.LNX.4.55.0805131752340.7267@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805130254420.535@cliff.in.clinika.pl>
	<20080513140444.49d7a044@hyperion.delvare>
	<Pine.LNX.4.55.0805131752340.7267@cliff.in.clinika.pl>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2008 17:57:52 +0100 (BST), "Maciej W. Rozycki" <macro@linux-mips.org> wrote:
> > You will do this even if all the registers were read as a block and the
> > RTC latched the register values so they have to be correct. Isn't it a
> > bit unfair / inefficient? If client->adapter has the
> > I2C_FUNC_SMBUS_READ_I2C_BLOCK functionality you can skip the comparison
> > and retry mechanism completely, saving some time and CPU cycles.
> 
>  Well, actually there is a reason beyond that.  It may change if we
> support subsecond resolution, but we currently do not.  The reason is if
> we return the original timestamp and the seconds register changes while
> the timestamp is being read, then effectively we return a value that is
> off by one second.  This is why for seconds I decided to return the second
> value read all the time.

I suppose the "off by one second" issue is not the matter each driver
should take care of.  This race is common for most RTC chip.

I do not have strong opinion for optimization suggested by Jean.  It
might be better, but I'm OK with current your patch.

---
Atsushi Nemoto
