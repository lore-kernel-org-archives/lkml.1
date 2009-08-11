Return-Path: <linux-kernel-owner+w=401wt.eu-S1754293AbZHKMmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbZHKMmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754244AbZHKMmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:42:00 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37490 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243AbZHKMl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:41:56 -0400
To: linux-kernel@vger.kernel.org
Content-Disposition: inline
From: Juergen Beisert <jbe@pengutronix.de>
Organization: Pengutronix - Linux Solutions for Science and Industry
Date: Tue, 11 Aug 2009 10:00:00 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200908111000.01316.jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: jbe@pengutronix.de
Subject: CMOS time jumps when ntpd ist running
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

anybody here who saw such CMOS clock behaviour when ntpd is running?
I synced system and CMOS time and after that I ran a simple
  'watch -t -n 300 "date; hwclock -u" > /logfile'
(note: When the ntpd daemon is not running, the CMOS clock does not show this 
behaviour):

[...]
    Mon Aug 10 03:53:20 CEST 2009              <-- system time
    Mon Aug 10 03:53:20 2009  0.000000 seconds <-- CMOS time

    Mon Aug 10 03:58:20 CEST 2009
    Mon Aug 10 03:58:20 2009  0.000000 seconds

    Mon Aug 10 04:03:20 CEST 2009
    Sun Aug  9 22:03:20 2009  0.000000 seconds <----- BANG !!!!!!111!1!!

    Mon Aug 10 04:08:20 CEST 2009
    Sun Aug  9 22:08:20 2009  0.000000 seconds
[...]

It seems its always -6 hours the CMOS clock jumps. And sometimes -(6h + n * 
24h) with n from 1 to 3 I saw.

Is my CMOS clock broken? (BTW: x86 arch, 32 bit, Linux kernel 2.6.28.10 and 
there is no SMM code in the system, it runs coreboot)

Regards
Juergen
