Return-Path: <linux-kernel-owner+w=401wt.eu-S1757970AbYJQXMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970AbYJQXMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 19:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756941AbYJQXLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 19:11:48 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:3016 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755545AbYJQXLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 19:11:47 -0400
From: Andrey Mirkin <major@openvz.org>
To: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Pavel Emelyanov <xemul@openvz.org>, Andrey Mirkin <major@openvz.org>
Subject: [PATCH 0/10] OpenVZ kernel based checkpointing/restart (v2)
Date: Sat, 18 Oct 2008 03:11:28 +0400
Message-Id: <1224285098-573-1-git-send-email-major@openvz.org>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patchset introduces kernel based checkpointing/restart as it is 
implemented in OpenVZ project. This version (v2) supports multiple
processes with simple private memory and open files (regular files).

Todo:
 - Create processes with the same PID during restart
 - Add support for x86-64
 - Add support for shared objects

Changelog:

18 Oct 2008 (v2):
 - Add support for multiple processes
 - Cleanup and bug fixes

--

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
