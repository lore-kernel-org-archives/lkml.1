Return-Path: <linux-kernel-owner+w=401wt.eu-S932339AbZHCQdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339AbZHCQdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 12:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932161AbZHCQdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 12:33:17 -0400
Received: from mail.free-electrons.com ([88.191.76.200]:42575 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152AbZHCQdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 12:33:17 -0400
Date: Mon, 3 Aug 2009 18:33:04 +0200
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>
To: Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH V2] au1xmmc: dev_pm_ops conversion
Message-ID: <20090803163304.GF5002@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 25, 2009, Frans Pop wrote:
> Yes, I see that in drivers/base/platform.c (legacy) .suspend resp. .resume
> also got called for those cases?
> Ouch :-(

This really looks like it's error-prone (I made this mistake for atmel_serial
and wouldn't have noticed if Frans hadn't told me), and AFAICS, for a number of
drivers we'll have suspend = freeze = poweroff and resume = thaw = restore.
Maybe putting something like this in pm.h would help ?

#define PM_OPS(name, suspend, resume) \
struct dev_pm_ops name = { \
	.suspend = suspend, \
	.resume = resume, \
	.freeze = suspend, \
	.thaw = resume, \
	.poweroff = suspend, \
	.restore = resume, \
};

Cheers,
-- 
Albin Tonnerre, Free Electrons
Kernel, drivers and embedded Linux development,
consulting, training and support.
http://free-electrons.com
