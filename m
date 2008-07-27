Return-Path: <linux-kernel-owner+w=401wt.eu-S1758918AbYG0SRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758918AbYG0SRb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 14:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751039AbYG0SRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 14:17:24 -0400
Received: from usul.saidi.cx ([204.11.33.34]:53900 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750982AbYG0SRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 14:17:23 -0400
Message-ID: <488CBBA0.2050106@overt.org>
Date: Sun, 27 Jul 2008 11:17:04 -0700
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, toshiba_acpi@memebeam.org,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org
Subject: [PATCH 0/1] toshiba_acpi: Add support for bluetooth toggling through
 rfkill
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As requested by Henrique, I have reworked this patch against wireless-testing
and it uses the new-style rfkill API and to report the input device as a switch.

I did some digging to try and find a usable gpe event but had only limited
success. From another look through the AML, it uses GPE08 for almost everything
- inspecting a bunch of state for each event and then sending notifications on
different objects. I couldn't find one for the hardware kill switch itself but I
did manage to find one that's emitted when the bluetooth device enters the
equivalent of the SOFT_BLOCKED state. This is useful for noticing that the
hardware switch has been released, but it also fires on transitions from UNBLOCKED
to SOFT_BLOCKED - so I had to try and avoid turning around and unblocking the
device! I'm not particularly happy with how I did it (ignore-the-next-event)
but I can't think of a better way.

--phil
