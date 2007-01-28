Return-Path: <linux-kernel-owner+w=401wt.eu-S932711AbXA1SPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711AbXA1SPW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 13:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbXA1SPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 13:15:22 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:50793 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbXA1SPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 13:15:21 -0500
Date: Sun, 28 Jan 2007 10:09:56 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: akuster <akuster@mvista.com>, linux-pm@lists.osdl.org
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] PM: fast power off - driver
Message-Id: <20070128100956.77509585.randy.dunlap@oracle.com>
In-Reply-To: <45BBB09C.7020509@mvista.com>
References: <45BBB09C.7020509@mvista.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Jan 2007 10:05:48 -1000 akuster wrote:

> My apologies, I cc'd the wrong list the first time around.


+config FAST_POWER_DOWN
+	tristate "Fast power of profile"
---------------------------> off
	What does that mean?  especially the "profile" part?

+	depends on FAST_POWER_OFF


+	printk(KERN_INFO "PM: Fastpoweroff, %s profile added\n",fpo_default.name);

Space after "," please.


OK, let me see if I understand fsd_default_off().

+static int fsd_default_off(void)
+{
+	/*
+	 * Actions taken:
+	 *
+	 *    1. Freeze all user processes.
+	 *
+	 *    2. Power off
+	 *
+	 *    3. Power off devices
+	 */
+
+	printk(KERN_EMERG "Fast Power Off initiated.\n");
+	fastpoweroff_prepare();
+	fastpoweroff();
+	fastpoweroff_standby();
+	return 1;
+}

Does this say (2) power off the system and then (3) power off devices?
How does it power off devices after calling fastpoweroff()?
Or is fastpoweroff() only setting the stage for something to
happen later?

Thanks,
---
~Randy
