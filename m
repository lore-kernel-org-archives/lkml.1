Return-Path: <linux-kernel-owner+w=401wt.eu-S933956AbZJGIk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933956AbZJGIk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757733AbZJGIkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:40:55 -0400
Received: from mxout-08.mxes.net ([216.86.168.183]:49780 "EHLO
	mxout-08.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756594AbZJGIky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:40:54 -0400
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: mingo@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: printk: fix loglevels as used by x86 stack dump code
Date: Wed,  7 Oct 2009 09:39:40 +0100
Message-Id: <1254904787-11323-1-git-send-email-alan-jenkins@tuffmail.co.uk>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following commit 5fd29d6 "printk: clean up handling of log-levels and newlines",
I noticed some loglevel oddities in my crash logs -

 Stack:
  00000020 dbe23e7c dbe23f8c c01a62bd 00000001 d759c400 dbc61840 00000000
  <0> 08088728 08088750 00000000 dbe23e74 dbe23ea4 00000000 00000000 00000000
  <0> dbe23c18 00c7afc0 c01a6eb1 ffffffff 00000000 dbc61840 00000000 00000000


This series is the result of my investigation.  The main fixes are

[PATCH 6/7] x86 dumpstack: fix printing of stack dump loglevels
 - fixes the problem shown above

[PATCH 5/7] printk: fix printk(KERN_EMERG) followed by printk("emergency message\n")
 - make sure the call trace which follows the stack dump is logged as KERN_EMERG,
   and not KERN_DEFAULT.

Regards
Alan
