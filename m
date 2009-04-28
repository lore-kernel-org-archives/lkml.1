Return-Path: <linux-kernel-owner+w=401wt.eu-S1759321AbZD1CnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321AbZD1CnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 22:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757809AbZD1CnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 22:43:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:24780 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469AbZD1CnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 22:43:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,258,1239001200"; 
   d="scan'208";a="407451045"
Subject: Re: acpi 'video' driver, and issues with
	'brightness_switch_enabled=0'
From: Zhang Rui <rui.zhang@intel.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <1240855052.11237.7.camel@maxim-laptop>
References: <1240855052.11237.7.camel@maxim-laptop>
Content-Type: text/plain; charset=utf-8
Date: Tue, 28 Apr 2009 10:43:24 +0800
Message-Id: <1240886605.4639.19.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-28 at 01:57 +0800, Maxim Levitsky wrote:
> I have a notebook which handles brightness keys in hardware, but tells
> loudly when it does so.
> 
if you boot into console mode w/o ACPI video driver, does the brightness
still change when you press the hotkeys?

> Currently, acpi 'video' also sets the brightness, which result in double
> setting, and on top of that it emits a key that makes gpm set brightness
> again.
> 
we need to support the brightness control in console mode.
and "﻿brightness_switch_enabled" should be cleared in graphics mode to
prevent the ACPI video driver action upon hotkey events.

> And (yes...) on top of that keyboard emits a brightness up/down even,
> which (you guessed...) sets brightness again.
> 
> I found out that it is possible to tell gnome-power-manager not to set
> brightness, but yet in kernel driver still sets it.
> 
> I found out even earlier that I can use brightness_switch_enabled=0,
> which supposed to make inkernel driver not touch the brightness.
> But I found out that this driver won't update the brightness, in /sys
> interface when I set this param.
> 
No, when ﻿"﻿brightness_switch_enabled" is cleared, gdm should still use
the ACPI backlight sysfs I/F if available to change the backlight,
i.e. /sys/class/backlight/acpi_video0/...

what's the model name of your laptop?
are you using Intel graphics?
please attach the output of acpidump and lspci.
It would be great if you can file a bug report about this issue at
bugzilla.kernel.org.

thanks,
rui

