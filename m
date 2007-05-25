Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbXEYMPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbXEYMPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 08:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760843AbXEYMP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 08:15:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45633 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758376AbXEYMP1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 08:15:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 0/4] swsusp: Fix hibernation/restore code ordering
Date: Fri, 25 May 2007 14:09:54 +0200
User-Agent: KMail/1.9.5
Cc: Alexey Starikovskiy <aystarik@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705251409.55644.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In the face of the recent change of suspend code ordering
(cf. http://marc.info/?l=linux-acpi&m=117938245931603&w=2) we should also
modify the code ordering in swsusp so that hibernation_ops->prepare() is
executed after device_suspend().

However, for this purpose it seems reasonable to eliminate the code duplication
between kernel/power/disk.c and kernel/power/user.c first.  By eliminating it
we can reduce the size of user.c quite substantially and remove the
maintenance difficulty with making essentially the same changes in two
different places.

Moreover, we should also remove the calls to "platform" functions from the
restore code path, since it doesn't carry out any power transition of the
system, but we generally need to disable the GPEs before the restore if the
'platform' hibernation mode has been used.  To do this, we can introduce
two new hibernation_ops to be used in the restore code.

Greetings,
Rafael

