Return-Path: <linux-kernel-owner+w=401wt.eu-S1757049AbXGEMD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049AbXGEMD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 08:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757946AbXGEMDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 08:03:41 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:43118 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760957AbXGEMDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 08:03:40 -0400
Message-Id: <20070705110744.564273000@sipsolutions.net>
User-Agent: quilt/0.46-1
Date: Thu, 05 Jul 2007 13:07:44 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/2] workqueue lockup debugging
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I recently experienced a lockup in the wireless code due to the
scenario described in patch 1 and wanted to have lockdep warn
about such scenarios as a way to catch such bugs in other
subsystems as well as to make sure we wouldn't get such things
ever again.

In discussions with Oleg and Ingo it turned out that there's
another possible deadlock with the now-recommended API of
cancel_work_sync() and I also found a way to make lockdep
catch that; it is addressed by patch 2.

Ingo thinks this could also have caught a similar lockup in the
DVB subsystem (I haven't found a patch for it yet) and would
like to see it in .23 early on.

johannes

