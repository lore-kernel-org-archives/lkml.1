Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbZICBk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbZICBk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 21:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752445AbZICBk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 21:40:58 -0400
Received: from mail.atheros.com ([12.36.123.2]:53912 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbZICBk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 21:40:58 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <catalin.marinas@arm.com>
CC: <linux-kernel@vger.kernel.org>, <penberg@cs.helsinki.fi>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/5] kmemleak: few small cleanups and clear command support
Date: Wed, 2 Sep 2009 18:40:54 -0700
Message-ID: <1251942059-21448-1-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Few patches after a quick review of kmemleak, adds clear command support
and fixes the sparse warnings. The only sparse warning I couldn't address
was this sparse warning which seems to be a false positive due to the way
the seq ops are used:

  CHECK   mm/kmemleak.c
mm/kmemleak.c:1207:13: warning: context imbalance in 'kmemleak_seq_start' - different lock contexts for basic block
mm/kmemleak.c:1261:17: warning: context imbalance in 'kmemleak_seq_stop' - unexpected unlock

I haven't tested this, nor do I know if the clear stuff will work, if you
can think of a better way please let me know. I'll test later when I get home.

Also, not sure who these patches go through, if welcomed.

Luis R. Rodriguez (5):
  kmemleak: use bool for true/false questions
  kmemleak: add clear command support
  kmemleak: move common painting code together
  kmemleak: fix sparse warning over overshadowed flags
  kmemleak: fix sparse warning for static declarations

 mm/kmemleak.c |   72 +++++++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 50 insertions(+), 22 deletions(-)

