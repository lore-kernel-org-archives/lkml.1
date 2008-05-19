Return-Path: <linux-kernel-owner+w=401wt.eu-S1759408AbYESMcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408AbYESMcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 08:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756767AbYESMbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 08:31:46 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:58576 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756603AbYESMbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 08:31:45 -0400
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <20080519231.561421028@firstfloor.org>
To: corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: [PATCH] [0/11] Repost of old VFS BKL patchkit
Date: Mon, 19 May 2008 14:31:09 +0200 (CEST)
X-OriginalArrivalTime: 19 May 2008 12:24:07.0625 (UTC) FILETIME=[3BF0EB90:01C8B9AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since BKL removal seems to be en-vogue again here's the repost
of the unapplied parts of my older VFS BKL patchkit.

Main difference is port to 2.6.26-rc2  and more fasync conversins.

- Converts remote_llseek to be BKL less. This will either eliminate
or push it down in a couple of network file systems (SMBFS, CIFS, OCFS2, 
NCPFS, NFS)
- Converts file flags handling to i_mutex
[BTW while looking over the tree I think there are a few
races in this regard in there anyways. Not all people who modify
that take BKL. Auditing all of them is a separate project.
No difference before/after my patch]
- Adds unlocked_fasync
- Converts lots of fasync users to unlocked_fasync

-Andi
