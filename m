Return-Path: <linux-kernel-owner+w=401wt.eu-S1753659AbYJVIds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbYJVIds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 04:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbYJVIdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 04:33:38 -0400
Received: from styx.suse.cz ([82.119.242.94]:34625 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752142AbYJVIdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 04:33:35 -0400
Subject: [PATCH 0/2] enable irqs when waiting for rwlocks
From: Petr Tesarik <ptesarik@suse.cz>
To: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org
Cc: tee@sgi.com
Content-Type: text/plain
Organization: SUSE LINUX
Date: Wed, 22 Oct 2008 10:33:34 +0200
Message-Id: <1224664414.4430.33.camel@elijah.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

SGI has observed that on large systems, interrupts are not serviced for
a long period of time when waiting for a rwlock. The following patch
series re-enables irqs while waiting for the lock, resembling the code
which is already there for spinlocks.

I only made the ia64 version, because the patch adds some overhead to
the fast path. In particular, I wasn't able to make a reasonably
lightweight implementation for x86, so I assume there are not such large
systems based on x86(_64). Of course, the possibility to implement
raw_{read|write}_lock_flags for any architecture is still there.

Petr Tesarik


