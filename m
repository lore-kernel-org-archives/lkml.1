Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbYEGVXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbYEGVXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 17:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbYEGVXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 17:23:01 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:1936 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbYEGVXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 17:23:00 -0400
Subject: futex: priority wakeup miss ordering
From: Daniel Walker <dwalker@mvista.com>
To: Pierre Peiffer <pierre.peiffer@bull.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Wed, 07 May 2008 14:22:58 -0700
Message-Id: <1210195378.17132.237.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



from commit ec92d08292d3e9b0823eba138a4564d2d39f25c7

The wakeup ordering should be in priority order. However if the priority
of a task is modified while it's waiting on the futex you will get an
out of order wakeup.

If you use a priority inheriting mutex this is correct. It's because the
rtmutex hooks into sched_setscheduler to catch any priority changes,
then re-queues with the new priority.. But the futex doesn't have this
hook.

Was this intentionally left out of this priority wake up patch? I
thought I would let you know in case you had a specific reason for not
handling this.. 

Daniel

