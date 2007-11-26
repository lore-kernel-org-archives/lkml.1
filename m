Return-Path: <linux-kernel-owner+w=401wt.eu-S1755536AbXKZRq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536AbXKZRq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 12:46:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbXKZRqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 12:46:22 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:32894 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbXKZRqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 12:46:21 -0500
Date: Mon, 26 Nov 2007 18:46:17 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Madhusudhan C <madhu_lkml@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmc select voltage functionality
Message-ID: <20071126184617.04029484@poseidon.drzeus.cx>
In-Reply-To: <655340.80743.qm@web44811.mail.sp1.yahoo.com>
References: <655340.80743.qm@web44811.mail.sp1.yahoo.com>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Nov 2007 05:34:11 -0800 (PST)
Madhusudhan C <madhu_lkml@yahoo.com> wrote:

> Hi Pierre,
> 
> I have a question on the mmc_select_voltage fn of the mmc core file drivers/mmc/core/core.c.
> 
> During the power up sequence the mmc_power_up fn sets the OCR bit to setup 3V. Subsequentely the mmc_select_voltage fn selects the lowest voltage
> the card can support.The host->ios.power_mode is not changed to MMC_POWER_UP before calling mmc_set_ios from this function hence the power_mode remains in MMC_POWER_ON state.So my question is, how should the controller driver handle this change in volatge. Under which case of power mode should the controller driver change the voltage again when a dual voltage card is detected?
> 

To be completely correct, the MMC layer should probably power down the card first, yes. Right now most drivers will handle all of these things as they see fit. Haven't seen a single bug report about it yet so...

Just change the voltage in whatever way makes sense for your controller.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
