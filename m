Return-Path: <linux-kernel-owner+w=401wt.eu-S1759858AbYCGGqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759858AbYCGGqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 01:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755400AbYCGGqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 01:46:11 -0500
Received: from mga10.intel.com ([192.55.52.92]:2545 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754470AbYCGGqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 01:46:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,460,1199692800"; 
   d="scan'208";a="530181990"
Subject: git bisect in 2.6.25-rc1 looks weird
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=utf-8
Date: Fri, 07 Mar 2008 14:42:43 +0800
Message-Id: <1204872163.17994.44.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am tracking a performance issue of volanoMark with kernel 2.6.25-rc1.

As reverting patch have conflictions, I decided to bisect between:
Good tag:       6b2d7700266b9402e12824e11e0099ae6a4a6a79
and
Bad tag:        550ade8432a2a6fbfb48ba7018750b0e8c81e8d0.

#git bisect start
#git bisect good 6b2d7700266b9402e12824e11e0099ae6a4a6a79
#git bisect bad 550ade8432a2a6fbfb48ba7018750b0e8c81e8d0
Bisecting: 910 revisions left to test after this
[50d9a126240f9961cfdd063336bbeb91f77a7dce] Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6

By "git log", I could see 50d9a126240f9961cfdd063336bbeb91f77a7dce is committed
between 6b2d7700266b9402e12824e11e0099ae6a4a6a79 and 550ade8432a2a6fbfb48ba7018750b0e8c81e8d0. 
Then,
#git bisect bad
Bisecting: 429 revisions left to test after this
[95af8a26cba55222d6a1beda7970431b4fbbbdd6] V4L/DVB (6958): tda18271: clean up function tda18271_set_analog_params

By "git log", I couldn't find commit of 6b2d7700266b9402e12824e11e0099ae6a4a6a79 and
550ade8432a2a6fbfb48ba7018750b0e8c81e8d0. I find patch 6b2d7700266b9402e12824e11e0099ae6a4a6a79
isn't applied at this time. So bisect in this step looks jumping out of the original range.


If I just manually checkout to the commit point of 95af8a26cba55222d6a1beda7970431b4fbbbdd6, I
find 6b2d7700266b9402e12824e11e0099ae6a4a6a79 isn't applied. Command is: #git checkout -b test1 95afXXX.
If I just manually checkout to the commit point of 6b2d7700266b9402e12824e11e0099ae6a4a6a79 , I
find 95af8a26cba55222d6a1beda7970431b4fbbbdd6 isn't applied.

Are the patches committed in line? or there are many paths crossing?

It looks weird.

-yanmin


