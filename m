Return-Path: <linux-kernel-owner+w=401wt.eu-S1752304AbYKNPCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbYKNPCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 10:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbYKNPCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 10:02:11 -0500
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:49070 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751190AbYKNPCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 10:02:10 -0500
Message-ID: <491D92EB.2030200@lwfinger.net>
Date: Fri, 14 Nov 2008 09:02:03 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Dominik Brodowski <linux@dominikbrodowski.net>
CC: LKML <linux-kernel@vger.kernel.org>, linux-pcmcia@lists.infradead.org
Subject: Strange behavior since commit 5fef0e5c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In testing kernel version 2.6.28-rc4 on my server that was running kernel
2.6.27, an external IDE disk system connected via a PCCard interface failed to
start because module ide_disk would not load. The console output is as follows:

finger@sonylap:~> sudo modprobe -v ide-disk
WARNING: module 'ide_gd_mod' is unsupported
FATAL: Module ide_disk not found.

I did not bisect this problem, but I believe that the following commit
introduced this change:

commit 5fef0e5c0283949f95a7891c9424a9f84448116b
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Fri Oct 17 18:09:12 2008 +0200

My work-around has been to change 'modprobe ide-disk' to 'modprobe ide-gd_mod'
in my startup. Please note that one of the underscores is changed to a hyphen.

Thanks,

Larry

