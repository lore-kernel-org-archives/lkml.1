Return-Path: <linux-kernel-owner+w=401wt.eu-S1752555AbYJRRMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbYJRRMK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 13:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750892AbYJRRL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 13:11:57 -0400
Received: from server.drzeus.cx ([85.8.24.28]:49711 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750812AbYJRRL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 13:11:56 -0400
Date: Sat, 18 Oct 2008 19:11:47 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Yauhen Kharuzhy <jekhor@gmail.com>
Cc: linux-kernel@vger.kernel.org, Yauhen Kharuzhy <jekhor@gmail.com>
Subject: Re: [PATCH] MMC: Fix race condition in resume/card detect code
Message-ID: <20081018191147.00327019@mjolnir.drzeus.cx>
In-Reply-To: <1224173376-25829-1-git-send-email-jekhor@gmail.com>
References: <1224173376-25829-1-git-send-email-jekhor@gmail.com>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008 19:09:36 +0300
Yauhen Kharuzhy <jekhor@gmail.com> wrote:

> When device wakes up by card change interrupt and MMC_UNSAFE_RESUME is
> enabled then race condition between mmc_rescan() and
> mmc_resume()/mmc_sd_resume() appeared.
> 
> Resume functions can sleep into mmc_remove_card() and at this time
> mmc_rescan() can be called by delayed work handler. Double-free of
> kobject or double-remove of host->card can be result of this.
> 
> This patch adds an mutex which deny simultaneous executing of
> mmc_sd_resume()/mmc_resume() and mmc_rescan() functions. Probably, it is
> not right way.
> 
> Signed-off-by: Yauhen Kharuzhy <jekhor@gmail.com>
> ---

Can't we just ask the PM layer if this device is currently resuming,
and if so ignore card notifications from the driver?

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
