Return-Path: <linux-kernel-owner+w=401wt.eu-S1755048AbZCKKuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbZCKKuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 06:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbZCKKuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 06:50:07 -0400
Received: from main.gmane.org ([80.91.229.2]:50162 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155AbZCKKuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 06:50:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Dmitriy V'jukov" <dvyukov@gmail.com>
Subject: SRCU: Number of outstanding callbacks
Date: Wed, 11 Mar 2009 10:48:24 +0000 (UTC)
Message-ID: <loom.20090311T104615-980@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 209.3.12.206 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.7) Gecko/2009021910 Firefox/3.0.7)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've read Paul McKenney's article about SRCU:
http://lwn.net/Articles/202847

And I am curious as to why only single outstanding SRCU callback per
thread is allowed. The problem with RCU is that it allows basically
unbounded number of outstanding callbacks, so why just not bound
number of outstanding callbacks in SRCU? Memory blocks are frequently
quite small, so that subsystem can tolerate up to let's say 1000
pending memory blocks. Restriction on single pending callback looks
quite severe (may cause unnecessary blocking), so why not provide:
int init_srcu_struct(struct srcu_struct *sp, int
limit_of_pending_callbacks);
?
While limit is not reached call_srcu() is non blocking, otherwise it
waits for grace period (behaves like synchronize_srcu()). I think in
many situations call_srcu() will be practically non-blocking (in
common case), while still guaranteeing bounded memory consumption.
Note that currently number of outstanding SRCU callbacks is
"unbounded" anyway (equal to number_of_threads), so changing number_of_threads
to number_of_threads+N must not have any bad consequences.
Or it's just not worth doing (because of the additional implementation
complexity)?
Thanks.

--
Best regards,
Dmitriy V'jukov

