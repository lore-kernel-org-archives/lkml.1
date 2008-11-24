Return-Path: <linux-kernel-owner+w=401wt.eu-S1752756AbYKXJv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbYKXJv4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 04:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788AbYKXJvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 04:51:47 -0500
Received: from mail.gmx.net ([213.165.64.20]:38140 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751612AbYKXJvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 04:51:47 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX197Oy4yzxZ7v9LlT28Y4VxNwkZQom/FocNgtV11OD
	ROAV+pMdShGsvt
Date: Mon, 24 Nov 2008 10:51:51 +0100 (CET)
From: Guennadi Liakhovetski <lg@denx.de>
X-X-Sender: lyakh@axis700.grange
To: rpurdie@rpsys.net
cc: linux-kernel@vger.kernel.org
Subject: leds/leds-pca9532.c: sleeping function called in .brightness_set()
Message-ID: <Pine.LNX.4.64.0811241041130.4148@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this seems to explicitly violate the API as documented in 
include/linux/leds.h:

	/* Set LED brightness level */
	/* Must not sleep, use a workqueue if needed */
	void		(*brightness_set)(struct led_classdev *led_cdev,
					  enum led_brightness brightness);

and also contradicts some other drivers, e.g., pca955x, which do use a 
workqueue as suggested: leds-pca9532.c::pca9532_set_brightness uses a 
mutex for locking and calls i2c_smbus functions directly. Needs to be 
fixed (if it hasn't been fixed yet), probably, also vor 2.6.27-stable.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.

DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
