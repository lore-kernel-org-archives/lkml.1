Return-Path: <linux-kernel-owner+w=401wt.eu-S1756977AbXHRQVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977AbXHRQVh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 12:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbXHRQV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 12:21:29 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:51328 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868AbXHRQV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 12:21:28 -0400
Date: Sat, 18 Aug 2007 18:21:27 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Marty Leisner <leisner@rochester.rr.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: power off disk drives while running
In-Reply-To: <200708181608.l7IG8Jmm006141@dell2.home>
Message-ID: <Pine.LNX.4.64.0708181815070.5186@fbirervta.pbzchgretzou.qr>
References: <200708181608.l7IG8Jmm006141@dell2.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 18 2007 12:08, Marty Leisner wrote:
>
>In embedded system design, it may be useful to poweroff the disks (as opposed
>to merely spinning them down).  We want to leave the system running while
>the disk is powered down, and let the disk powerup when it needs to be 
>spun up.

That means you also have to power it on...

>While the "power off mechanism" would be platform dependent, is there a
>generic path to announce "prepare for power going away"?

I do not see why that would be needed from a software point of view. Just make
sure that the disk does not needlessy emergency-park when pulling power. When
someone wants to write to disk, the request goes to the device driver, which
hands it to the controller, which hands it to the disk. And your controller
should be able to handle it (e.g. wait until reconnect) when there is a request
for a disk that is powered off.


	Jan
-- 
