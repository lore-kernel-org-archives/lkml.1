Return-Path: <linux-kernel-owner+w=401wt.eu-S1757022AbYLaTKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbYLaTKZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 14:10:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756275AbYLaTKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 14:10:13 -0500
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:40282 "EHLO
	QMTA09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756241AbYLaTKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 14:10:12 -0500
From: Peter W Morreale <pmorreale@novell.com>
Subject: [PATCH 0/2] fix pdflush races and enhancement v2
To: pmorreale@novell.com, akpm@linux-foundation.org, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, spamtrap@knobisoft.de
Date: Wed, 31 Dec 2008 12:10:09 -0700
Message-ID: <20081231190755.30792.24205.stgit@hermosa.site>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update of pdflush series, changes since last post:

o Change upper bound patch to include update of last_empty_jifs to throttle 
thread creation to one per second.

o Change new sysctls to use CTL_UNNUMBERED per Andrew Morton

o Use proc_dointvec_minmax and tie bounds of min and max threads to 
the current min/max.  Otherwise the possible combinations of actual
threads makes my head hurt.

o Update Documentation/sysctl/vm.txt with the new entries


Peter W Morreale (2):
      Add /proc controls for pdflush threads
      Fix pdflush thread creation upper bound.


 Documentation/sysctl/vm.txt |   28 ++++++++++++++++++++++++++
 include/linux/writeback.h   |    2 ++
 kernel/sysctl.c             |   25 +++++++++++++++++++++--
 mm/pdflush.c                |   47 ++++++++++++++++++++++++++++++++++---------
 4 files changed, 90 insertions(+), 12 deletions(-)


Best,
-PWM

