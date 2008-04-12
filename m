Return-Path: <linux-kernel-owner+w=401wt.eu-S1757717AbYDMKgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757717AbYDMKgG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 06:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755100AbYDMKfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 06:35:55 -0400
Received: from saeurebad.de ([85.214.36.134]:50576 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755032AbYDMKfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 06:35:54 -0400
X-Mailbox-Line: From hannes@symbol.fehenstaub.lan Sun Apr 13 00:58:50 2008
Message-Id: <20080412223319.372887160@symbol.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Sun, 13 Apr 2008 00:33:19 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>
Subject: [patch 0/2] bootmem: Fix node-setup agnostic free_bootmem()
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[the first send didn't make it to lkml, so here it is again]

Hi,

as I was doing some clean-ups in the bootmem allocator, I noticed the
patch

    5a982cbc7b3fe6cf72266f319286f29963c71b9e
    mm: fix boundary checking in free_bootmem_core

which seems to implement the opposite of what the subject promises.

It makes input arguments acceptable if they are `a bit wrong' and
silently aborts if they are completely off the whack.

Please have a look at the two patches I propose: one to revert the
original and the other one to reimplement what the whole thing was
really about: having free_bootmem() itself look up the node holding
the specified address range.

Note also that the reverted patch changed a helper function and
therefore also affected free_bootmem_node(), making the latter paper
over bugs as well.

	Hannes

Original version:

 mm/bootmem.c |   25 +++++++++++++++++++------
 1 files changed, 19 insertions(+), 6 deletions(-)

New version:

 bootmem.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)
