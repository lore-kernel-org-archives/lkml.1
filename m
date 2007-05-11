Return-Path: <linux-kernel-owner+w=401wt.eu-S966287AbXEKWAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966287AbXEKWAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 18:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759742AbXEKWAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 18:00:00 -0400
Received: from mailrelay1.nijmegen.internl.net ([217.149.192.44]:46497 "EHLO
	hatert.nijmegen.internl.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759670AbXEKV77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 17:59:59 -0400
Message-Id: <20070511172326.008944330@caffeinetrip.com>
User-Agent: quilt/0.46-1
Date: Fri, 11 May 2007 19:23:26 +0200
From: Giel de Nijs <giel@caffeinetrip.com>
To: linux-kernel@vger.kernel.org
Cc: Vojtech Pavlik <vojtech@suse.cz>,
       Dimitry Torokhov <dmitry.torokhov@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Matt Domsch <matt_domsch@dell.com>,
       Rezwanul Kabir <rezwanul_kabir@dell.com>,
       linux-input@atrey.karlin.mff.cuni.cz
Subject: [patch 0/2] [PATCH] input: correctly handle keys without hardware release event
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch adds a soft release key mask to input_dev, to enable keyboard
drivers to determine which keys never generate a hardware release event and
hence add a release event after every press event of such keys. The mask is
controlled by ioctls.

The Fn+F? key combinations of Dell Latitude series laptops (and possibly other
Dells or other brands) only generate a key press event and never a key release
event, which is most probable a hardware flaw (or feature?). Due to this flaw,
combinations like Fn+F1 for hibernate and Fn-F3 for showing battery status
cannot be used. Ubuntu has probably fixed this by patching the X input layer
and HAL, but other distributions (like Debian) cannot use these keys. This
patch adds a generic method to signal if keys with certain scancodes never
generate release events, so the keyboard driver can add those events right
after a key press event.

The ioctls used to read and write to this bitmask might be used in a program
like setkeycodes, which is normally used to map certain scancodes to keycodes.
With a command line option, this program could also set the soft release bit
for a certain scancode if desired. Patches for setkeycodes and getkeycodes
against the Debian console-tools can be found at
http://giel.operation0.org/keyboard-soft-release

This patch also uses the infrastructure for generating release events for
KEY_HANGEUL and KEY_HANJA, something which was already done in atkbd.c.

See also this thread: http://thread.gmane.org/gmane.linux.kernel/401378

Greetings,
Giel
-- 

