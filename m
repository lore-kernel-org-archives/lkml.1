Return-Path: <linux-kernel-owner+w=401wt.eu-S1754784AbYIKIbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbYIKIbt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 04:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbYIKIbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 04:31:41 -0400
Received: from gw.goop.org ([64.81.55.164]:33250 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383AbYIKIbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 04:31:40 -0400
Message-ID: <48C8D76B.10901@goop.org>
Date: Thu, 11 Sep 2008 01:31:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alex Nixon <alex.nixon@citrix.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] Globally defining phys_addr_t
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

This is a repost of a little 3-patch series which Andrew has been
carrying in -mm.  It cleans up the definition of phys_addr_t to make it
kernel-wide rather than x86-specific, and fixes up PFN_PHYS() to use it
to avoid address truncation.

We currently have a few workarounds for this problem in the tree, but
Alex found another bug caused by PFN_PHYS(), so it's probably better if
you bring these patches into tip.git for now.

PowerPC also defines a phys_addr_t with the same meaning as x86; the
powerpc arch maintainers are happy with these patches.

The third patch in the series is not necessary to fix any bug, but it
removes the separate definition of resource_size_t to define it in terms
of phys_addr_t.  I include it for competeness.

Thanks,
    J
