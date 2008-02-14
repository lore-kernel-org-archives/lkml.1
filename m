Return-Path: <linux-kernel-owner+w=401wt.eu-S1762851AbYBNLa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762851AbYBNLa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 06:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbYBNLaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 06:30:20 -0500
Received: from hpsmtp-eml14.KPNXCHANGE.COM ([213.75.38.114]:25741 "EHLO
	hpsmtp-eml14.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753919AbYBNLaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 06:30:19 -0500
From: Frans Pop <elendil@planet.nl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [stable 2.6.24] WARNING: at kernel/time/clockevents.c
Date: Thu, 14 Feb 2008 12:30:13 +0100
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       john stultz <johnstul@us.ibm.com>
References: <200802101440.22118.elendil@planet.nl> <200802132240.04357.elendil@planet.nl> <alpine.LFD.1.00.0802140029550.12988@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0802140029550.12988@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802141230.14625.elendil@planet.nl>
X-OriginalArrivalTime: 14 Feb 2008 11:30:15.0586 (UTC) FILETIME=[F840A820:01C86EFC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 February 2008, Thomas Gleixner wrote:
> futex_lock_pi is called with an absolute timeout, which is based on
> CLOCK_REALTIME. Nothing wrong with that, but the clockevents WARN_ON
> might trap over a false positive, when the expiry value is less than
> base->offset. This was intentional before we put the WARN_ON into the
> clockevents code.
>
> The patch below should fix this issue.

With these two patches on top of 2.6.24.2 I no longer get any warnings 
during a glibc compile:
- hrtimer: check relative timeouts for overflow
- hrtimer: fix abs clock realtime

Thanks Thomas.

Cheers,
FJP
