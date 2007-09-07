Return-Path: <linux-kernel-owner+w=401wt.eu-S965694AbXIGNeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965694AbXIGNeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 09:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965168AbXIGNeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 09:34:08 -0400
Received: from smtp-105-friday.nerim.net ([62.4.16.105]:50854 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965417AbXIGNeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 09:34:07 -0400
Date: Fri, 7 Sep 2007 15:35:59 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Greg KH <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, David Brownell <david-b@pacbell.net>
Subject: Platform device id
Message-ID: <20070907153559.17faf9d1@hyperion.delvare>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, all,

While platform_device.id is a u32, platform_device_add() handles "-1" as
a special id value. This has potential for confusion and bugs. One such
bug was reported to me by David Brownell:

http://lists.lm-sensors.org/pipermail/i2c/2007-September/001787.html

And since then I've found two other drivers  affected (uartlite and
i2c-pxa).

Could we at least make platform_device.id an int so as to clear up the
confusion? I doubt that the id will ever be a large number anyway.

To go one step further, I am questioning the real value of this naming
exception for these "unique" platform devices. On top of the bugs I
mentioned above, it has potential for compatibility breakage: adding a
second device of the same type will rename the first one from "foo" to
"foo.0". It also requires specific checks in many individual platform
drivers. All this, as I understand it, for a purely aesthetic reason. I
don't think this is worth it. Would there be any objection to simply
getting rid of this exception and having all platform devices named
"foo.%d"?

-- 
Jean Delvare
