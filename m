Return-Path: <linux-kernel-owner+w=401wt.eu-S932328AbZLJIzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328AbZLJIzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 03:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757990AbZLJIzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 03:55:51 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55180 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757712AbZLJIzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 03:55:50 -0500
Date: Thu, 10 Dec 2009 09:55:54 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Julia Lawall <julia@diku.dk>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
       David Vrabel <dvrabel@arcom.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: return value of platform_get_irq
Message-ID: <20091210085554.GB6255@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Julia,

in commit 305b3228 the return value indicating failure in
platform_get_irq was changed.

I tried to create a semantic patch for that, but I have failed as spatch
always says something like:

	Fatal error: exception Failure("minus: parse error: ...

Actually what is needed is that (probably) all usages of:

	ret = platform_get_irq(dev, num);
	if (!ret) {
		...

and equivalent are converted to

	ret = platform_get_irq(dev, num);
	if (ret <= 0) {
		...

(Actually I think "ret < 0" would be more correct in most situations,
but as 0 was handled as error before it's more conservative to keep it
this way.)

I assume it's easy for you to come up with a patch.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
