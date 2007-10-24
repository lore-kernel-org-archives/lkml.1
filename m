Return-Path: <linux-kernel-owner+w=401wt.eu-S1756519AbXJXTU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbXJXTU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 15:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbXJXTUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 15:20:19 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:54376 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbXJXTUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 15:20:18 -0400
Date: Wed, 24 Oct 2007 15:17:44 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: CONFIG variables:  defined but unused
Message-ID: <Pine.LNX.4.64.0710241512330.1108@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  at the moment, i'm running a quick-and-dirty script that identifies
Kconfig variables that are defined in a Kconfig file somewhere but
don't appear to be used.  this will take a while to run, but here's
the first few variables printed:


>>>>> 64BIT_CONTEXT
arch/mips/Kconfig:config 64BIT_CONTEXT
>>>>> ACPI_DEBUG_FUNC_TRACE
drivers/acpi/Kconfig:config ACPI_DEBUG_FUNC_TRACE
>>>>> ADB_KEYBOARD
arch/m68k/Kconfig:config ADB_KEYBOARD
drivers/macintosh/adbhid.c:#define ADB_KEYBOARD_UNKNOWN 0
drivers/macintosh/adbhid.c:#define ADB_KEYBOARD_ANSI    0x0100
drivers/macintosh/adbhid.c:#define ADB_KEYBOARD_ISO     0x0200
drivers/macintosh/adbhid.c:#define ADB_KEYBOARD_JIS     0x0300
drivers/macintosh/adbhid.c:     case ADB_KEYBOARD:
drivers/macintosh/adbhid.c:                     input_dev->id.version = ADB_KEYBOARD_UNKNOWN;
drivers/macintosh/adbhid.c:                     input_dev->id.version = ADB_KEYBOARD_ANSI;
drivers/macintosh/adbhid.c:                     input_dev->id.version = ADB_KEYBOARD_ISO;
drivers/macintosh/adbhid.c:                     input_dev->id.version = ADB_KEYBOARD_JIS;
drivers/macintosh/adbhid.c:     if (default_id == ADB_KEYBOARD) {
drivers/macintosh/adbhid.c:     adb_register(ADB_KEYBOARD, 0, &keyboard_ids, adbhid_keyboard_input);
include/linux/adb.h:#define ADB_KEYBOARD        2
>>>>> AEDSP16_MSS
sound/oss/Kconfig:config AEDSP16_MSS
sound/oss/aedsp16.c:#if defined(CONFIG_SOUND_AEDSP16_SBPRO) && defined(CONFIG_SOUND_AEDSP16_MSS)
>>>>> AEDSP16_SBPRO
sound/oss/Kconfig:config AEDSP16_SBPRO
sound/oss/aedsp16.c:#if defined(CONFIG_SOUND_AEDSP16_SBPRO) && defined(CONFIG_SOUND_AEDSP16_MSS)
>>>>> ALPHA_EV7
arch/alpha/Kconfig:config ALPHA_EV7
... etc etc ...


  just from the above, you can see the variety of results:

* both 64BIT_CONTEXT and ACPI_DEBUG_FUNC_TRACE are defined but are
apparently never referenced anywhere
* ADB_KEYBOARD is defined but apparently ignored in favour of some
hard-coded constants
* AEDSP16_MSS and AEDSP16_SBPRO appear to be typoes, but they're part
of OSS which is going away so who cares?
* ALPHA_EV7 appears to be unused

   ... and on and on, and i'm not even out of the A's yet.  i suspect
the script will finish by this evening sometime.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
