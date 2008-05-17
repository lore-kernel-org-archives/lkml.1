Return-Path: <linux-kernel-owner+w=401wt.eu-S1757421AbYEQPBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421AbYEQPBi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 11:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754554AbYEQPBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 11:01:31 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:51112 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379AbYEQPBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 11:01:30 -0400
Date: Sun, 18 May 2008 00:02:42 +0900 (JST)
Message-Id: <20080518.000242.41199304.anemo@mba.ocn.ne.jp>
To: macro@linux-mips.org
Cc: a.zummo@towertech.it, hvr@gnu.org, akpm@linux-foundation.org,
       rtc-linux@googlegroups.com, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RTC: M41T80: Century Bit support
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <Pine.LNX.4.55.0805170057370.4049@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805170057370.4049@cliff.in.clinika.pl>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 May 2008 01:25:18 +0100 (BST), "Maciej W. Rozycki" <macro@linux-mips.org> wrote:
>  Make use of the Century Bit to support years in the range from 1970 to 
> 2169.  Enable toggling of the bit at the end of a century on a clock 
> update.
> ---
>  The clock is used with the Broadcom SWARM and the D-Link DNS-323 
> platform.
> 
>  I have verified correct operation with the SWARM -- the firmware assumes
> 19YY when CB is clear and 20YY otherwise.  Which means years 1900-1969
> will be shown as 2100-2169 in Linux.  I think this is a feature rather
> than a problem.  The firmware does not set the CEB bit itself and does not 
> care of what its state is.
> 
>  I will be happy to hear from a DNS-323 user to confirm or deny whether
> such an interpretation is compatible.

This patch enforces that all (including future) users of this device
must use same interpretation of CB bit.  I think this is too
intrusive.

And I have one (out-of-tree, and only one in the world) board with
this device and its firmware uses different interpretation.
Fortunately I can change this firmware, so this is not a serious
problem for me. ;)

How about doing like this?

1. If CEB was 0, keep current behavior. (does not touch CB bit)

2. If CEB was 1, detect polarity of CB bit on get_datetime, and set or
   clear CB bit on set_datetime based on the polarity.

Please look at "c_polarity" variable in rtc-pcf8563.c driver.

---
Atsushi Nemoto
