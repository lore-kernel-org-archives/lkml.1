Return-Path: <linux-kernel-owner+w=401wt.eu-S1756438AbZDFMsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438AbZDFMsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 08:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbZDFMsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 08:48:15 -0400
Received: from brick.kernel.dk ([93.163.65.50]:50475 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601AbZDFMsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 08:48:14 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: tytso@mit.edu, torvalds@linux-foundation.org
Subject: [PATCH 0/8][RFC] IO latency/throughput fixes
Date: Mon,  6 Apr 2009 14:48:00 +0200
Message-Id: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.2.1.423.g442d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a set of patches that I worked on today in the hopes
of furthering the latency goals and at least fixing some of
the write regression with fwrite + fsync that current -git
is suffering from.

I haven't done any latency tests yet, I'm just tossing this
out there so we can collaborate on improving things. What I
did test was the silly fwrite() + fsync() loop test, which
is a LOT slower in current -git that it used to be. The test
is basically:

	while (nr--) {
		f = fopen();
		fprintf(f, "Some data here\n");
		fsync(fileno(f));
		fclose(f);
	}

which (for nr == 2000) takes 16 seconds in -git, completes
in 0.9s with the patches.

-- 
Jens Axboe

