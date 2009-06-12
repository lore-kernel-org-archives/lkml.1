Return-Path: <linux-kernel-owner+w=401wt.eu-S1758153AbZFLLpD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153AbZFLLpD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 07:45:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbZFLLoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 07:44:54 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:15334 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbZFLLox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 07:44:53 -0400
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <4A323FB4.1090404@tremplin-utc.net>
Date: Fri, 12 Jun 2009 13:44:52 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090319 Mandriva/2.0.0.21-1mdv2009.1 (2009.1) Thunderbird/2.0.0.21 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Daniel Mack <daniel@caiaq.de>
CC: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] lis3: add click function
References: <20090612101805.GC18682@elf.ucw.cz> <1244803042-2913-1-git-send-email-daniel@caiaq.de>
In-Reply-To: <1244803042-2913-1-git-send-email-daniel@caiaq.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 12-06-09 12:37, Daniel Mack schreef:
> The LIS3 accelerometer chip has a 'click' feature which can be used to
> detect sudden motion on any of the three axis. Configuration data is
> passed via spi platform_data and no action is taken if that's not
> specified, so it won't harm any existing platform.
> 
> To make the configuration effective, the IRQ lines need to be set up
> appropriately. This patch also adds a way to do that from board support
> code.
> 
> The DD_* definitions were removed because I couldn't find any reference
> of them in the datasheet and the overlapped with the CLICK_ register
> space.
Hello,
It's not so simple. The driver supports both LIS302xx and LIS3LV02xx.
The LIS302xx (whoami == 0x3A) has CLICK_* registers, and the LIS3LV02xx
(whoami == 0x3B) has DD_* registers. So first of all, you should not
remove the references to DD_*, just add the CLICK_* definitions after
them. Moreover, the usage of those registers should therefore be
conditioned to whoami == 0x3A.

Also, I did not follow all the black magic happening with platform_data.
Could you explain how much would be needed to have the same feature in
the ACPI side?

Also, it seems to only set up the "click" feature, without ever using
it. How do you access this information from userspace? Is it specific to
SPI? Maybe it could also generate button events in the joystick interface?

See you,
Eric


