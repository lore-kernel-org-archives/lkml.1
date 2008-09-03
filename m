Return-Path: <linux-kernel-owner+w=401wt.eu-S1751625AbYICKzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625AbYICKzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 06:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbYICKzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 06:55:11 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:38240 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbYICKzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 06:55:09 -0400
From: Andrey Mirkin <major@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: containers@lists.linux-foundation.org, Andrey Mirkin <major@openvz.org>
Subject: [PATCH 0/9] OpenVZ kernel based checkpointing/restart
Date: Wed,  3 Sep 2008 14:57:47 +0400
Message-Id: <1220439476-16465-1-git-send-email-major@openvz.org>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces kernel based checkpointing/restart as it is
implemented in OpenVZ project. This patchset has limited functionality and
are able to checkpoint/restart only single process. Recently Oren Laaden
sent another kernel based implementation of checkpoint/restart. The main
differences between this patchset and Oren's patchset are:

* In this patchset checkpointing initiated not from the process
(right now we do not have a container, only namespaces), Oren's patchset
performs checkpointing from the process context.

* Restart in this patchset is initiated from process, which restarts a new
process (in new namespaces) with saved state. Oren's patchset uses the same
process from which restart was initiated and restore saved state over it.

* Checkpoint/restart functionality in this patchset is implemented as a kernel
module


As checkpointing is initiated not from the process which state should be saved
we should freeze a process before saving its state. Right now Container Freezer
from Matt Helsley can be used for this.

This patchset introduce only a concept how kernel based checkpointing/restart
can be implemented and are able to checkpoint/restart only a single process
with simple VMAs. 

I've tried to split my patchset in small patches to make review more easier.
