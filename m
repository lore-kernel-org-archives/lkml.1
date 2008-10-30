Return-Path: <linux-kernel-owner+w=401wt.eu-S1753816AbYJ3Cza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbYJ3Cza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 22:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbYJ3CzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 22:55:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:54503 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257AbYJ3CzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 22:55:18 -0400
Message-ID: <49092208.9060909@kernel.org>
Date: Thu, 30 Oct 2008 11:55:04 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: linux-scsi <linux-scsi@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Jens Axboe <jens.axboe@oracle.com>
Subject: why does udev set timeout for all SCSI devices?
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 30 Oct 2008 02:55:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kay.

As the $SUBJ says, why does udev set timeout for all SCSI devices?
It's the following two rules.

50-udev-default.rules:SUBSYSTEM=="scsi", KERNEL=="[0-9]*:[0-9]*",
ACTION=="add", ATTR{type}=="0|7|14", ATTR{timeout}="60"
50-udev-default.rules:SUBSYSTEM=="scsi", KERNEL=="[0-9]*:[0-9]*",
ACTION=="add", ATTR{type}=="1", ATTR{timeout}="900"

The appropriate default timeout differs depending on the transport and
the type of the attached device, so the above two rules harm more than
help.  The affect of the above two rules weren't visible for some
reason but with recent block layer timeout update, they actually work
and cause problems.

Thanks.

-- 
tejun
