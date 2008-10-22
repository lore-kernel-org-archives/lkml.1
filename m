Return-Path: <linux-kernel-owner+w=401wt.eu-S1753716AbYJVCK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbYJVCK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 22:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbYJVCKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 22:10:14 -0400
Received: from mail.windriver.com ([147.11.1.11]:48290 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbYJVCKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 22:10:12 -0400
Message-ID: <48FE8B6F.3050406@windriver.com>
Date: Tue, 21 Oct 2008 21:09:51 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: kgdb 2.6.28 merge plans
References: <1224616493-23237-1-git-send-email-jason.wessel@windriver.com> <20081021234911.3813f17d@lxorguk.ukuu.org.uk>
In-Reply-To: <20081021234911.3813f17d@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Oct 2008 02:09:51.0807 (UTC) FILETIME=[449A64F0:01C933EB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> * kgdboc will request/allocate a tty so as to sync with
>>   the user space with respect to having only one
>>   invocation of the low level start up code.
>
> The tty stuff for this is not 2.6.28 material
>

Anything related to tty allocation has been removed from the merge
request queue, and regression testing is taking place on the revised
patch set at:

git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git
for_linus

The rx_poll callback support is still on the docket to request a
merge for 2.6.28.

Cheers,
Jason.

---
Atsushi Nemoto (1):
      kgdb: kgdboc console poll hooks for serial_txx9 uart

Jason Wessel (5):
      kgdb: Add the ability to schedule a breakpoint via a tasklet
      tty: Fix sparse static warning for tty_driver_lookup_tty
      kgdboc, tty: Add the rx polling call back capability
      kgdboc, 8250: rx polling hook for the 8250 driver
      kgdboc, amba-pl011: rx polling hook for the amba-pl011 driver

Sonic Zhang (1):
      kgdb: Make mem access function weak in kgdb.c and kgdb.h

 Documentation/DocBook/kgdb.tmpl |   49 ++++++++++++++---
 drivers/char/tty_io.c           |    9 +---
 drivers/serial/8250.c           |    4 ++
 drivers/serial/amba-pl011.c     |    5 ++-
 drivers/serial/kgdboc.c         |   72 ++++++++++++++++++++++++-
 drivers/serial/serial_core.c    |   24 ++++++++-
 drivers/serial/serial_txx9.c    |  113
+++++++++++++++++++++++++++++++-------
 include/linux/kgdb.h            |   43 ++++++++++++++-
 include/linux/serial_core.h     |    3 +
 include/linux/tty_driver.h      |    3 +-
 kernel/kgdb.c                   |   33 ++++++++++-
 11 files changed, 312 insertions(+), 46 deletions(-)


