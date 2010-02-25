Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab0BYHpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 02:45:42 -0500
Received: from ernst.netinsight.se ([194.16.221.21]:10155 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752908Ab0BYHpl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 02:45:41 -0500
Date: Thu, 25 Feb 2010 08:45:35 +0100
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: =?ISO-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iTCO_wdt: Don't double the requested timeout
Message-ID: <20100225084535.4658cbf9@marrow.netinsight.se>
In-Reply-To: <4B854F58.4050907@draigBrady.com>
References: <20100223164019.60a6de1a@marrow.netinsight.se>
	<4B840154.1010501@draigBrady.com>
	<4B840BC6.9090809@draigBrady.com>
	<20100224101618.39c3468b@marrow.netinsight.se>
	<4B84FD15.9020803@draigBrady.com>
	<20100224124730.6958b2c0@marrow.netinsight.se>
	<4B8545D1.8000302@draigBrady.com>
	<20100224165526.61cdd169@marrow.netinsight.se>
	<4B854F58.4050907@draigBrady.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(taking back lkml on CC. The discussion is about stopping watchdogs
before rebooting).

On Wed, 24 Feb 2010 16:10:00 +0000
Pádraig Brady <P@draigBrady.com> wrote:
> > Returning to the initial issue (my patch to avoid stopping the watchdog
> > before reboot): What is the preferred behavior? I've looked in other
> > drivers, and see multiple ways being used. Some do as in my patch, some
> > leave it on unconditionally and some stop it unconditionally.
> >
> Well nowayout to me means userspace should have no way out,
> but when rebooting the system the watchdog should be reset.
> But in saying that I'm not sure what to do. At least there
> should be some way to select the operation you want above,
> so as to protect the reboot process itself.

Well, from the drives I saw that had this behavior (not that I checked
all of them), they did look at nowayout to determine whether to stop it
or not.

> In general, I wonder could an order be specified so that
> the watchdog is disabled as the very last thing by the kernel,
> right before it does the reboot?

Many other drivers use reboot notifiers, but unfortunately it seems
that these are called before device shutdown (kernel/sys.c), so it
wouldn't help here.


I guess it would be good to have defined and uniform behavior across
different watchdogs, and at least an option to specify
nowayout-also-when-rebooting.

// Simon
