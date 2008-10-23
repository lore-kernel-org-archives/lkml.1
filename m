Return-Path: <linux-kernel-owner+w=401wt.eu-S1757195AbYJWQJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195AbYJWQJM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 12:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755064AbYJWQIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 12:08:54 -0400
Received: from styx.suse.cz ([82.119.242.94]:51659 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753239AbYJWQIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 12:08:53 -0400
Subject: [PATCH V2 0/2] enable irqs when waiting for rwlocks
From: Petr Tesarik <ptesarik@suse.cz>
To: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org
Cc: tee@sgi.com, Robin Holt <holt@sgi.com>
Content-Type: text/plain
Organization: SUSE LINUX
Date: Thu, 23 Oct 2008 17:57:31 +0200
Message-Id: <1224777451.11530.52.camel@elijah.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New in V2:
 * get rid of ugly #ifdef's in kernel/spinlock.h
 * convert __raw_{read|write}_lock_flags to an inline func

SGI has observed that on large systems, interrupts are not serviced for
a long period of time when waiting for a rwlock. The following patch
series re-enables irqs while waiting for the lock, resembling the code
which is already there for spinlocks.

I only made the ia64 version, because the patch adds some overhead to
the fast path. I assume there is currently no demand to have this for
other architectures, because the systems are not so large. Of course,
the possibility to implement raw_{read|write}_lock_flags for any
architecture is still there.

Petr Tesarik


