Return-Path: <linux-kernel-owner+w=401wt.eu-S1752966AbYCMHtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbYCMHtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 03:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbYCMHtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 03:49:06 -0400
Received: from mga10.intel.com ([192.55.52.92]:32957 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751372AbYCMHtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 03:49:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,493,1199692800"; 
   d="scan'208";a="305832323"
Subject: hackbench regression since 2.6.25-rc
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=utf-8
Date: Thu, 13 Mar 2008 15:46:57 +0800
Message-Id: <1205394417.3215.85.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comparing with 2.6.24, on my 16-core tigerton, hackbench process mode has about
40% regression with 2.6.25-rc1, and more than 20% regression with kernel
2.6.25-rc4, because rc4 includes the reverting patch of scheduler load balance.

Command to start it.
#hackbench 100 process 2000
I ran it for 3 times and sum the values.

I tried to investiagte it by bisect.
Kernel up to tag 0f4dafc0563c6c49e17fe14b3f5f356e4c4b8806 has the 20% regression.
Kernel up to tag 6e90aa972dda8ef86155eefcdbdc8d34165b9f39 hasn't regression.

Any bisect between above 2 tags cause kernel hang. I tried to checkout to a point between
these 2 tags for many times manually and kernel always paniced.

All patches between the 2 tags are on kobject restructure. I guess such restructure
creates more cache miss on the 16-core tigerton.

Any idea?

-yanmin


