Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbZD0HTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbZD0HTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 03:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbZD0HSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 03:18:55 -0400
Received: from web32602.mail.mud.yahoo.com ([68.142.207.229]:28564 "HELO
	web32602.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751696AbZD0HSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 03:18:55 -0400
Message-ID: <967985.28657.qm@web32602.mail.mud.yahoo.com>
X-YMail-OSG: X.js7nIVM1l5SJYwyojSYhEzG65OYsxNt1ejwoJzVAsnAmASnZWCAPLASG0RlE7d2y4B.CFPorAHq6_fRJKKh_8G_JtI7OLXvx19uTRTBQVofyT77NAPlt2cJLRUjWkIRGqgee22MIaBu89hynpCvt_e6EMihoDzFle38f86tmZQMTpgT2RbtUP7Z8m.J7ayQxb4WuTHLtsHHbaeqP8T.Mzzlytg17l7ZE9iTWOW3IFXuJpDOoLFat5zwTrrc_RR0OOFQsC63dq9OMrIFGkI2VtxppcgVNzPXwcf6eqtQhl34mqMhw--
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1277.35 YahooMailWebService/0.7.289.1
References: <tur5OtdUm3E.A.r2B.7oE9JB@chimera> <egHshlwQQFE.A.ZNC.DpE9JB@chimera>
Date: Mon, 27 Apr 2009 00:18:53 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: [Bug #13178] Booting very slow
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <egHshlwQQFE.A.ZNC.DpE9JB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message ----

> From: Rafael J. Wysocki <rjw@sisk.pl>
> To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> Cc: Kernel Testers List <kernel-testers@vger.kernel.org>; Martin Knoblauch <spamtrap@knobisoft.de>
> Sent: Sunday, April 26, 2009 11:46:31 AM
> Subject: [Bug #13178] Booting very slow
> 
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.28 and 2.6.29.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry    : http://bugzilla.kernel.org/show_bug.cgi?id=13178
> Subject        : Booting very slow
> Submitter    : Martin Knoblauch 
> Date        : 2009-04-24 12:45 (3 days old)
> References    : http://marc.info/?l=linux-kernel&m=124057716231773&w=4

 Not really sure whether this is a real regression. Between 2.6.28 and 2.6.29 the content of /proc/mounts for sysfs changed from

/sys /sys sysfs rw 0 0

to

none /sys sysfs rw 0 0


 This breaks RHEL-4.3 userland which parses /proc/mounts in the firmware hotplug agent to find the mount-point for sysfs. As a result firmware loading started to fail in 2.6.29. There is a simple fix in the /etc/hotplug/firmware.agent script (just assume /sys as it is done elsewhere).

 Your call.

Cheers
Martin
