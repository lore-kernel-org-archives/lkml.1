Return-Path: <linux-kernel-owner+w=401wt.eu-S1751912AbZGaI4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbZGaI4u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 04:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbZGaI4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 04:56:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33659 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097AbZGaI4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 04:56:21 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: airlied@linux.ie, dri-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] gpu/drm: fix memory leak when radeon_driver_load_kms fails
Date: Fri, 31 Jul 2009 16:55:54 +0800
Message-Id: <1249030558-24143-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've noticed a bundle of kmemleak reports on drm. When I look into dmesg,
I found: "[drm:radeon_driver_load_kms] *ERROR* Failed to initialize radeon,
disabling IOCTL". 

In radeon_driver_load_kms, if radeon_device_init fails, rdev is not freed.
Then radeon_driver_load_kms as dev->driver->load, if load fails in
drm_get_dev, memories allocated in drm_fill_in_dev will not be freed.

This patchset fixes those memory leaks, after this patchset applied, I didn't
see those drm kmemleak report.
