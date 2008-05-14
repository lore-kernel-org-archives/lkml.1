Return-Path: <linux-kernel-owner+w=401wt.eu-S1761520AbYENFHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761520AbYENFHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 01:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758200AbYENFHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 01:07:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42032
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760504AbYENFHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 01:07:00 -0400
Date: Tue, 13 May 2008 22:06:52 -0700 (PDT)
Message-Id: <20080513.220652.24245811.davem@davemloft.net>
To: mingo@elte.hu
CC: acme@redhat.com, srostedt@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2]: Add sparc64 ftrace support.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This was a lot more trivial than I expected, about a 20 minute
hack.  Most of the time was spent on test boots :)

The first patch removes the packed attribute from the ftrace_page
blob of dynamic ftrace entries, because not only does it cause
unaligned accesses on sparc64 it's also totally useless.

The second patch adds sparc64 ftrace support.

One thing I noticed is that sparc64 uses an mcount implementation
already for a quick-and-dirty stack usage checker.  I tried to
make them live alongside eachother.

Next, I think the mcount symbol export needs some tweaking.  On sparc,
the symbol _mcount is what the compiler references (this seems to be a
sparc sysv4'ism) whereas on x86 it appears that plain "mcount" is
used.  I provide both symbols and we already have a local export of
"_mcount" to take care of this.  I think architectures should deal
with this symbol exporting since it is different on every system.

Signed-off-by: David S. Miller <davem@davemloft.net>
