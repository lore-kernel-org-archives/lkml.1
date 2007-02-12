Return-Path: <linux-kernel-owner+w=401wt.eu-S1030192AbXBLWIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030192AbXBLWIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 17:08:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030202AbXBLWII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 17:08:08 -0500
Received: from ip-216-152-249-241.servata.com ([216.152.249.241]:47978 "EHLO
	servata.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030192AbXBLWIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 17:08:07 -0500
Subject: shared memory is over-counted N times when calculating badness()
From: Jeff Davis <linux@j-davis.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 12 Feb 2007 14:08:04 -0800
Message-Id: <1171318084.10824.113.camel@dogma.v10.wvs>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In oom_kill.c, badness() counts half the total_vm of all the children
against the parent.

The problem with this calculation is that, if the parent and children
share memory, the shared memory is over-counted N/2 times where N is the
number of children.

There's already a hard limit on the amount of shared memory, so it's
unlikely that process is runaway due to shared memory consumption, and
shouldn't add to a process's badness() score.

Shouldn't it just use (total_vm - shared_vm) instead, and never even
count shared memory?

Regards,
	Jeff Davis

