Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab0BIAQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 19:16:10 -0500
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.61]:58369 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab0BIAQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 19:16:08 -0500
X-Greylist: delayed 1593 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Feb 2010 19:16:08 EST
Message-ID: <9464d2ed24ffe806f30c73018dfe471b.squirrel@webmail.andrew.cmu.edu>
Date: Mon, 8 Feb 2010 18:49:32 -0500
Subject: Bizzare issue resuming from suspend
From: "Josh Watzman" <jwatzman@andrew.cmu.edu>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.5.2 [SVN]
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.2.8.233621
X-SMTP-Spam-Clean: 8% (
 BODY_SIZE_1900_1999 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, TO_NO_NAME 0, WEBMAIL_SOURCE 0, WEBMAIL_USER_AGENT 0, __C230066_P3_5 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __PHISH_SPEAR_HTTP_RECEIVED 0, __PHISH_SPEAR_STRUCTURE_1 0, __PHISH_SPEAR_STRUCTURE_2 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm having some weird issues where my MacBook Pro fails to resume from
suspend. The failure mode is: backlight on, cdrom drive does its "reset"
noise thing, but nothing other than that -- no response to keyboard, for
example, when Control-Alt-F1 then Control-Alt-Delete should reboot.

The following kernels consistently FAIL when resuming:
 - 2.6.32.7 built from kernel.org 2.6.32 tarball + 2.6.32.7 patch
 - 2.6.32.6 built from
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.32.y.git
 - 2.6.32.7 built from
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.32.y.git

The following kernel consistently SUCCEEDS when resuming:
 - 2.6.32.6 built from kernel.org 2.6.32 tarball + 2.6.32.6 patch

Note that 2.6.32.6 either fails or succeeds depending upon how I build it!
To make sure, I built the two variations of .6 on the same day, no system
changes in between, with the same .config, and did a diff -- everything
was the same AFAICT, but the git one fails and the tarball one is fine!

Google suggested to turn on the PM debug options and try a couple of
things; I did the following on the tty of a 2.6.32.6 git build with
.config modified only to turn on PM debugging:
 - run through the /sys/power/pm_test options; it resumes successfully
from everything except "none"
 - echo 1 > /sys/power/pm_trace and use the magic number. dmesg on the
next boot reported the number as "0:168:740" corresponding to
"drivers/base/power/main.c:430" -- it did not report a device

I have no idea how to debug this further -- I'm not (yet ;)) much of a
kernel hacker. If someone wants to help me track it down, I'd love to
help.

Specs:
MacBookPro2,2; Debian sid (not quite up-to-date as I keep things
consistent to track this down); Core 2 Duo 2.33Ghz; 2G ram; 1G swapfile

Thanks! Please CC me on replies, I'm not subscribed.
jwatzman

Sent from webmail -- not digitally signed

