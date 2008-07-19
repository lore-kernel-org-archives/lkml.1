Return-Path: <linux-kernel-owner+w=401wt.eu-S1756275AbYGSViO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbYGSViO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 17:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbYGSVh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 17:37:58 -0400
Received: from senator.holtmann.net ([87.106.208.187]:60627 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912AbYGSVh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 17:37:57 -0400
Subject: Re: [PATCH] Bluetooth: fix oops in rfcomm tty code (v2)
From: Marcel Holtmann <marcel@holtmann.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Maxim Krasnyansky <maxk@qualcomm.com>,
       Dave Young <hidave.darkstar@gmail.com>,
       Soeren Sonnenburg <kernel@nn7.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080719211227.GA14173@localhost.localdomain>
References: <20080719211227.GA14173@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 19 Jul 2008 23:38:20 +0200
Message-Id: <1216503500.8411.110.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vegard,

> This is a resend of a patch I sent earlier. It fixes a reproducible
> oops (see http://lkml.org/lkml/2008/7/13/89 for test case), and I'd
> be very happy for some feedback from Bluetooth people. Can this be
> included for testing somewhere? I don't have any bluetooth devices
> myself, so all my testing is limited to creating/releasing devices
> with ioctl (I'm not sure that's good enough).
> 
> Dave: I have extended the rfcomm_dev_lock to include all the setup and
> teardown of a single device. On second thought, it doesn't really make
> sense to use a separate lock for that. May I have your opinion on this
> second version? (I've fixed the comments/BUG_ON that you pointed out.)

it seems it is the actually the first time, I see this one. Anyway, so
holding that lock is a bad idea. Fixing this the right way might be
tricky since the TTY layer is involved here and own the kobject. So I
would say we have to make sure that the RFCOMM TTY will hangup when
calling RELEASEDEV or otherwise fail.

Regards

Marcel


