Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbYJGKKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbYJGKKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 06:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbYJGKKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 06:10:37 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:56193 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbYJGKKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 06:10:37 -0400
From: Rodolfo Giometti <giometti@enneenne.com>
To: linux-kernel@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>
Date: Tue,  7 Oct 2008 12:10:29 +0200
Message-Id: <1223374230-18413-1-git-send-email-giometti@enneenne.com>
X-Mailer: git-send-email 1.5.4.3
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH V3] led: Backlight trigger for led subsystem
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds a new led trigger which emulates the backlight
behaviour: the leds are turned off and on each time the display blanks
and unblacks.

Since backlights are usually implemented with leds this patch set is
useful for those drivers whose manage leds controller used as
backlight controller.

The driver simply registers itself into the led subsystem and then the
user may get backlight emulation by setting the "backlight"
trigger. Moreover a driver, which usually manages more than one led,
can use some leds as "led" and the others as "backlights" at user
request.

Rodolfo

---

CHANGELOG:

V2 ---> V3:

* Avoid that two consecutive blank commands as follow:

        echo 1 > /sys/class/graphics/fb0/blank
        echo 1 > /sys/class/graphics/fb0/blank

  may vanish unblank led intensity status.


