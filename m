Return-Path: <linux-kernel-owner+w=401wt.eu-S1754557AbYLIQyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbYLIQyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 11:54:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbYLIQy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 11:54:29 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46170 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751921AbYLIQy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 11:54:28 -0500
Date: Tue, 9 Dec 2008 16:54:40 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: New library code
Message-ID: <20081209165440.64501e00@lxorguk.ukuu.org.uk>
In-Reply-To: <20081209161425.GE32662@infomag.infomag.iguana.be>
References: <20081204155250.59a1d30c@lxorguk.ukuu.org.uk>
	<20081209161425.GE32662@infomag.infomag.iguana.be>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Dec 2008 17:14:25 +0100
Wim Van Sebroeck <wim@iguana.be> wrote:

> Hi Alan,
> 
> The flue changed my weekend :-(. I do however have 2 general questions first:
> 
> > - Handles the temperature device
> Why don't we treat the temperature part not as a hwmon?

Because the temperature interface was there first and is part of the
existing kernel to user space API. Now that the device is abstracted I
agree entirely that it should also appear in hwmon and the support
library code can be extended to do this along with multiple watchdogs.
> 
> > - It does all the reboot, nowayout and module locking and housekeeping
> Why don't we use the shutdown methods of our platform and other devices instead of the reboot notifier setup?

As and when watchdogs are all platform devices we probably should. Right
now most of them are not and we don't really have a proper 'isa_device'
object yet. I see that as a migration path or an 'aspiration', but having
it in one place will make that easier to achieve after we have the common
API.

Likewise sysfs, classes and multiple watchdogs all want addressing but
that gets a lot easier once everything is using a common framework and a
passed 'struct watchdog' to make multiple instances just work.

Alan
