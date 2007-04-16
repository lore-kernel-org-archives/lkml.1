Return-Path: <linux-kernel-owner+w=401wt.eu-S1753083AbXDPRdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbXDPRdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 13:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbXDPRdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 13:33:50 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:45405 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbXDPRdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 13:33:49 -0400
Date: Mon, 16 Apr 2007 19:36:19 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg K-H <greg@kroah.com>,
       Tejun Heo <htejun@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [Patch -mm 0/3] RFC: module unloading vs. release function
Message-ID: <20070416193619.4659a847@gondolin.boeblingen.de.ibm.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

based on the discussion in "How should an exit routine wait for
release() callbacks?", I've cooked up some patches that make module
unload wait until the last reference for a kobject has been dropped.
This should plug the "release function in already deleted module" race;
however, if the last kobject_put() from the module containing the
release function is not in the module's exit function, there's still a
small window (not sure if and how to plug this).

This new refcounting still needs to be exploited (i. e. a driver
actually setting kobject->owner). Whether we need to set the owner for
kobject or if for device would be sufficient is also still open to
debate.

[1/3] Use module->mkobj even if !CONFIG_SYSFS.
[2/3] Expose module->mkobj reference count.
[3/3] Introduce kobject->owner for refcounting.

Patchset is only slightly tested, but comments are welcome :)
