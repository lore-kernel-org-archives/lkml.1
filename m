Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591AbZB1LVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbZB1LVm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 06:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbZB1LVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 06:21:33 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:42003 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbZB1LVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 06:21:32 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49A91DE8.7000700@s5r6.in-berlin.de>
Date: Sat, 28 Feb 2009 12:20:08 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: me@felipebalbi.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: lockdep and threaded IRQs
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <20090227123344.33196e99.akpm@linux-foundation.org> <20090227203717.GL16801@frodo> <200902271350.32380.david-b@pacbell.net>
In-Reply-To: <200902271350.32380.david-b@pacbell.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> The other is that Linux needs real support for threaded
> interrupts.  Almost every I2C (or SPI) device that raises
> an IRQ needs its IRQ handler to run in a thread, and most
> of them have the same type of workqueue-based hack to
> get such a thread.  (Some others have bugs instead...)

Since when is having an IRQ handler scheduling a workqueue job a hack?
In kernels whose IRQ handlers don't sleep, we don't pretend that they
could; instead we defer sleeping work to a context which can sleep.

Or from another angle:  If a driver requires a kernel with sleeping IRQ
handlers, why submit it for inclusion into a kernel which does not
provide nonatomic context to IRQ handlers?
-- 
Stefan Richter
-=====-==--= --=- ===--
http://arcgraph.de/sr/
