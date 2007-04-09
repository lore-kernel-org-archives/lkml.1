Return-Path: <linux-kernel-owner+w=401wt.eu-S1751572AbXDIM0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbXDIM0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 08:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbXDIM0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 08:26:23 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:32531 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572AbXDIM0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 08:26:22 -0400
Message-ID: <461A3010.90403@sw.ru>
Date: Mon, 09 Apr 2007 16:22:40 +0400
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>, Paul Menage <menage@google.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>
CC: devel@openvz.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@sw.ru>, Chandra Seetharaman <sekharan@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rohit Seth <rohitseth@google.com>,
       Linux Containers <containers@lists.osdl.org>
Subject: [PATCH 0/8] RSS controller based on process containers (v2)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adds RSS accounting and control within a container.

Major change: current scanner code reuse.

Tasks and files accounting is not included as these containers
are simple enough to be implemented later.

Based on top of Paul Menage's container subsystem v8.
Note, that only first three patches from Paul's patchset should
be used as BeanCounters, CPU accounting etc are not needed for
RSS container.

RSS container includes the per-container RSS accounting and
reclamation, and out-of-memory killer. The container behaves like
a standalone machine - when it runs out of resources, it tries to
reclaim some pages, and if it doesn't succeed, kills some task
which mm_struct belongs to the container in question.

Changes from previous version:
* reclamation code reuse. I.e. the scanner code used to reclaim
  pages on global memory shortage is used as-is in per-container
  page reclamation;
* active/inactive per-container lists (a bit reworked patch
  from Balbir);
* more elegant top container creation (thanks Paul for clarifying).
