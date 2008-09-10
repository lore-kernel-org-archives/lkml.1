Return-Path: <linux-kernel-owner+w=401wt.eu-S1753524AbYIJJ2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbYIJJ2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 05:28:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbYIJJ1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 05:27:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32950 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbYIJJ1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 05:27:53 -0400
Subject: [BUG?] sendfile / distcc
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 10 Sep 2008 11:27:51 +0200
Message-Id: <1221038871.2442.86.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 (2.23.91-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been seeing this for a while now, but its still present with -rc5+
kernels. Its always the local machine failing, never the remotes.

[root@twins linux-2.6-rt]# nice ./k opteron build
time distmake x86_64 O=opteron-build ARCH=x86_64
testing twins:    distccd running
testing opteron:  DOWN
testing taijtu:   distccd running
testing dyad:     distccd running
testing lappy:    host running
testing ubuntu:   host running
DISTCC_HOSTS= twins/8 taijtu/32 dyad/32
DISTCC_DIR=/dev/shm/distcc
DISTCC_SLOTS=72

...

distcc[9931] (dcc_writex) ERROR: failed to write: Connection reset by peer
distcc[9931] Warning: failed to distribute /mnt/build/linux-2.6-rt/kernel/fork.c to twins/8, running locally instead

...

distcc[12078] (dcc_pump_sendfile) ERROR: sendfile failed: Connection reset by peer
distcc[12078] (dcc_readx) ERROR: unexpected eof on fd4
distcc[12078] (dcc_r_token_int) ERROR: read failed while waiting for token "DONE"
distcc[12078] Warning: failed to distribute /mnt/build/linux-2.6-rt/init/version.c to twins/8, running locally instead



