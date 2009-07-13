Return-Path: <linux-kernel-owner+w=401wt.eu-S1756745AbZGMTz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbZGMTz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 15:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756720AbZGMTz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 15:55:27 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:55454 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703AbZGMTz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 15:55:26 -0400
X-Greylist: delayed 1080 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jul 2009 15:55:26 EDT
X-ASG-Debug-ID: 1247513846-743402290000-xx1T2L
X-Barracuda-URL: http://10.68.76.222:80/cgi-bin/mark.cgi
Date: Mon, 13 Jul 2009 15:37:23 -0400 (EDT)
From: Nicolas Pitre <nico@marvell.com>
X-X-Sender: nico@xanadu.home
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Greg KH <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Lennert Buijtenhek <buytenh@marvell.com>,
       Saeed Bishara <saeed@marvell.com>,
       =?ISO-8859-15?Q?J=F6rn_Engel?= <joern@logfs.org>,
       Andrew Morton <akpm@linux-foundation.org>
X-ASG-Orig-Subj: Re: [PATCH] move orion_nand's probe function to .devinit.text
Subject: Re: [PATCH] move orion_nand's probe function to .devinit.text
In-Reply-To: <1247345591-22643-26-git-send-email-u.kleine-koenig@pengutronix.de>
Message-ID: <alpine.LFD.2.00.0907131536070.3138@xanadu.home>
References: <20090711170548.GC5205@suse.de> <1247345591-22643-14-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-15-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-16-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-17-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-18-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-19-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-20-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-21-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-22-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-23-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-24-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-25-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-26-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811582-1406693519-1247513846=:3138"
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1247513846
X-Barracuda-Virus-Scanned: by dakia2.marvell.com at marvell.com
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811582-1406693519-1247513846=:3138
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Sat, 11 Jul 2009, Uwe Kleine-König wrote:

> A pointer to orion_nand_probe is passed to the core via
> platform_driver_register and so the function must not disappear when the
> .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
> unbinding and binding a device to the driver via sysfs will result in an
> oops as does a device being registered late.
> 
> An alternative to this patch is using platform_driver_probe instead of
> platform_driver_register plus removing the pointer to the probe function
> from the struct platform_driver.

For those kind of platform devices I'd prefer the alternative.


Nicolas
---1463811582-1406693519-1247513846=:3138--
