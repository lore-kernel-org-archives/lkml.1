Return-Path: <linux-kernel-owner+w=401wt.eu-S1759471AbYAVJyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759471AbYAVJyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 04:54:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756560AbYAVJy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 04:54:28 -0500
Received: from brick.kernel.dk ([87.55.233.238]:8774 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756288AbYAVJy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 04:54:27 -0500
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: knikanth@novell.com
Subject: [PATCH 0/6] IO context sharing
Date: Tue, 22 Jan 2008 10:49:15 +0100
Message-Id: <1200995361-24001-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.4.rc2.84.gf85fd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Today io contexts are per-process and define the (surprise) io context
of that process. In some situations it would be handy if several
processes share an IO context. With syslets it's especially crucial that
the threads working on behalf of the parent process are seen as the same
IO context. That goes from both a fairness and performance point of
view, since IO schedulers like AS and CFQ base decisions on what the
IO context state is. This patchset adds support for processes sharing a
single io context and also adds a CLONE_IO flag to denote sharing of
IO context.

In the block git repo here's a syslet-share branch that merges these
patches with the latest syslet patches posted from Zach and sets
CLONE_IO for syslet threads. The result is that performance of AS
and CFQ is as good as it would have been had a single process issued
the IO async through libaio.

This work was originally started by Nikanth Karthikesan
<knikanth@novell.com>, but then later completely reworked by me.

The patches are against latest -git.

-- 
Jens Axboe


