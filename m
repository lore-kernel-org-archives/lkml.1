Return-Path: <linux-kernel-owner+w=401wt.eu-S1751821AbZAKFgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbZAKFgS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 00:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750959AbZAKFgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 00:36:09 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:37372 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbZAKFgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 00:36:07 -0500
Subject: Re: How to access a regular file from within a module ?
From: Jon Masters <jonathan@jonmasters.org>
To: joseluismarchetti@yahoo.com.br
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <888012.80064.qm@web34402.mail.mud.yahoo.com>
References: <888012.80064.qm@web34402.mail.mud.yahoo.com>
Content-Type: text/plain
Organization: World Organi[sz]ation of Broken Dreams
Date: Sun, 11 Jan 2009 00:35:46 -0500
Message-Id: <1231652146.4235.6.camel@perihelion.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-10 at 19:44 -0800, Jose Luis Marchetti wrote:

> I would like to open/read/write/close a regular file from my device
> driver.

No, you probably wouldn't :) Generally, this is recommended against
because there are many better ways to do it:

* Create an interface and have userspace set the parameter (ethtool,
ifconfig - the latter can already set MAC addresses)

* Create entries in sysfs and have uevents cause various activities,
including having the response being some file gets loaded (firmware).

Since it looks like you just want to set the MAC address, I suggest
looking at how this is already done, then rely upon users using ifconfig
correctly to set the desired address. There should be no reason to have
a kernel-side network driver reading from a file.

[NOTE: If you're doing embedded development and you don't have an EEPROM
on your board, and you're asking this because someone told you to find
the cheapest and nastiest solution in software, then look at passing in
the desired MAC via the firmware, as many embedded boards already do. ]

Jon.


