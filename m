Return-Path: <linux-kernel-owner+w=401wt.eu-S1755599AbXICIGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599AbXICIGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 04:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750714AbXICIGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 04:06:23 -0400
Received: from smtp2e.orange.fr ([80.12.242.112]:33776 "EHLO smtp2e.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbXICIFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 04:05:54 -0400
X-ME-UUID: 20070903080553271.4240E700009E@mwinf2e08.orange.fr
Subject: forget the noise (Re: very very strange simultaneous RAID resync
	on sep 2, 01:06 CEST (+2))
From: Xavier Bestel <xavier.bestel@free.fr>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1188806170.1131.479.camel@frg-rhel40-em64t-04>
References: <1188806170.1131.479.camel@frg-rhel40-em64t-04>
Content-Type: text/plain
Date: Mon, 03 Sep 2007 10:05:50 +0200
Message-Id: <1188806750.1131.483.camel@frg-rhel40-em64t-04>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-03 at 09:56 +0200, Xavier Bestel wrote:
> In itself, this event is already strange. But what's even stranger is
> that another guy had the same resync exactely at the same time

That mystery is solved, see /etc/cron.d/mdadm:

# By default, run at 01:06 on every Sunday, but do nothing unless the day of
# the month is less than or equal to 7. Thus, only run on the first Sunday of
# each month. crontab(5) sucks, unfortunately, in this regard; therefore this
# hack (see #380425).
6 1 * * 0 root [ -x /usr/share/mdadm/checkarray ] && [ $(date +\%d) -le 7 ] && /usr/share/mdadm/checkarray --cron --all --quiet

Sorry for the noise.

	Xav


