Return-Path: <linux-kernel-owner+w=401wt.eu-S1762595AbYESSWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762595AbYESSWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 14:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758625AbYESSWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 14:22:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50683 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756128AbYESSWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 14:22:01 -0400
Date: Mon, 19 May 2008 11:21:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, wim@iguana.be
Subject: Re: [PATCH 00/57] watchdog: Giant scrub
Message-Id: <20080519112148.4d078ad4.akpm@linux-foundation.org>
In-Reply-To: <20080519124659.31722.51847.stgit@core>
References: <20080519124659.31722.51847.stgit@core>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008 14:04:40 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

>  drivers/watchdog/acquirewdt.c          |  119 ++++-----
>  drivers/watchdog/advantechwdt.c        |  133 ++++------
>  drivers/watchdog/alim1535_wdt.c        |  186 +++++++------
>  drivers/watchdog/alim7101_wdt.c        |  224 +++++++++-------
>  drivers/watchdog/ar7_wdt.c             |   29 +-
>  drivers/watchdog/at32ap700x_wdt.c      |    7 -
>  drivers/watchdog/at91rm9200_wdt.c      |  108 ++++----
>  drivers/watchdog/bfin_wdt.c            |  147 +++++------
>  drivers/watchdog/booke_wdt.c           |   57 ++--
>  drivers/watchdog/cpu5wdt.c             |  144 +++++-----
>  drivers/watchdog/davinci_wdt.c         |   11 -
>  drivers/watchdog/ep93xx_wdt.c          |   17 +
>  drivers/watchdog/eurotechwdt.c         |   57 +++-
>  drivers/watchdog/hpwdt.c               |    4 
>  drivers/watchdog/i6300esb.c            |  342 ++++++++++++-------------
>  drivers/watchdog/iTCO_vendor.h         |   15 +
>  drivers/watchdog/iTCO_vendor_support.c |   53 ++--
>  drivers/watchdog/iTCO_wdt.c            |  294 ++++++++++-----------
>  drivers/watchdog/ib700wdt.c            |  103 ++++---
>  drivers/watchdog/ibmasr.c              |  149 ++++++-----
>  drivers/watchdog/indydog.c             |  114 ++++----
>  drivers/watchdog/iop_wdt.c             |   46 ++-
>  drivers/watchdog/it8712f_wdt.c         |   77 ++----
>  drivers/watchdog/ixp2000_wdt.c         |   50 ++--
>  drivers/watchdog/ixp4xx_wdt.c          |   41 +--
>  drivers/watchdog/ks8695_wdt.c          |  119 ++++-----
>  drivers/watchdog/machzwd.c             |  108 +++-----
>  drivers/watchdog/mixcomwd.c            |  133 +++++-----
>  drivers/watchdog/mpc5200_wdt.c         |   20 +
>  drivers/watchdog/mpc83xx_wdt.c         |   19 +
>  drivers/watchdog/mpc8xx_wdt.c          |   37 +--
>  drivers/watchdog/mpcore_wdt.c          |   53 ++--
>  drivers/watchdog/mtx-1_wdt.c           |  107 ++++----
>  drivers/watchdog/mv64x60_wdt.c         |   20 +
>  drivers/watchdog/omap_wdt.c            |   35 ++-
>  drivers/watchdog/pc87413_wdt.c         |  211 ++++++---------
>  drivers/watchdog/pcwd.c                |  179 +++++++------
>  drivers/watchdog/pnx4008_wdt.c         |   18 +
>  drivers/watchdog/rm9k_wdt.c            |   21 +-
>  drivers/watchdog/s3c2410_wdt.c         |  148 ++++++-----
>  drivers/watchdog/sa1100_wdt.c          |   32 +-
>  drivers/watchdog/sb_wdog.c             |   78 +++---
>  drivers/watchdog/sbc60xxwdt.c          |  223 ++++++++--------
>  drivers/watchdog/sbc7240_wdt.c         |   16 +
>  drivers/watchdog/sbc8360.c             |   30 +-
>  drivers/watchdog/sbc_epx_c3.c          |   12 -
>  drivers/watchdog/sc1200wdt.c           |  203 ++++++++-------
>  drivers/watchdog/sc520_wdt.c           |  163 ++++++------
>  drivers/watchdog/scx200_wdt.c          |   59 ++--
>  drivers/watchdog/shwdt.c               |  139 ++++++----
>  drivers/watchdog/smsc37b787_wdt.c      |  442 ++++++++++++++++----------------
>  drivers/watchdog/softdog.c             |   87 +++---
>  drivers/watchdog/txx9wdt.c             |   31 +-
>  drivers/watchdog/w83627hf_wdt.c        |  175 ++++++-------
>  drivers/watchdog/w83697hf_wdt.c        |  141 +++++-----
>  drivers/watchdog/w83877f_wdt.c         |  199 +++++++-------
>  drivers/watchdog/w83977f_wdt.c         |  225 ++++++++--------
>  drivers/watchdog/wafer5823wdt.c        |   80 +++---
>  drivers/watchdog/wdrtas.c              |  103 +++----
>  drivers/watchdog/wdt.c                 |  176 +++++++------
>  drivers/watchdog/wdt285.c              |   31 +-
>  drivers/watchdog/wdt977.c              |  148 +++++------
>  drivers/watchdog/wdt_pci.c             |  300 ++++++++++++----------
>  65 files changed, 3479 insertions(+), 3396 deletions(-)

eek.

This comes at a time when git-watchdog has

 drivers/watchdog/Kconfig              |   38 +++-
 drivers/watchdog/Makefile             |    5 +
 drivers/watchdog/bfin_wdt.c           |  111 +++++---
 drivers/watchdog/core/Kconfig         |   33 +++
 drivers/watchdog/core/Makefile        |    7 +
 drivers/watchdog/core/watchdog_core.c |  200 ++++++++++++++
 drivers/watchdog/core/watchdog_dev.c  |  465 +++++++++++++++++++++++++++++++++
 drivers/watchdog/geodewdt.c           |  309 ++++++++++++++++++++++
 drivers/watchdog/hpwdt.c              |   27 +-
 drivers/watchdog/iTCO_wdt.c           |  247 +++++-------------
 drivers/watchdog/it8712f_wdt.c        |   21 ++
 drivers/watchdog/rc32434_wdt.c        |  344 ++++++++++++++++++++++++
 drivers/watchdog/rdc321x_wdt.c        |  285 ++++++++++++++++++++
 drivers/watchdog/w83697hf_wdt.c       |   38 +++-
 include/linux/watchdog.h              |   49 ++++
 15 files changed, 1934 insertions(+), 245 deletions(-)

and hasn't had a commit in six weeks, missed the merge window and the
most recent commit is titled "[WATCHDOG] rc32434_wdt: critical
bugfixes".

Wim, come back!

(Happily there appears to be little overlap between the two diffstats there)
