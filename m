Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478AbYISPBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbYISPBD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 11:01:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbYISPAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 11:00:53 -0400
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:57162 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbYISPAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 11:00:52 -0400
Message-Id: <20080919145859.062069850@quilx.com>
User-Agent: quilt/0.46-1
Date: Fri, 19 Sep 2008 07:58:59 -0700
From: Christoph Lameter <cl@linux-foundation.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
CC: linux-mm@kvack.org
Cc: jeremy@goop.org
Cc: ebiederm@xmission.com
Cc: travis@sgi.com
Cc: herbert@gondor.apana.org.au
Cc: xemul@openvz.org
Cc: penberg@cs.helsinki.fi
Subject: [patch 0/4] Cpu alloc V5: Replace percpu allocator in modules.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just do the bare mininum to establish a per cpu allocator. Later patchsets
will gradually build out the functionality.

The most critical issue that came up on the last round is how to configure
the size of the percpu area. Here we simply use a kernel parameter and use
the static size of the existing percpu allocator for modules as a default.

The effect of this patchset is to make the size of percpu data for modules
configurable. Its no longer fixed at 8000 bytes.

Changes:
V4->V5:
- Fix various things pointed out by Pekka.
- Remove page alignment check from module.c and put it into cpu_alloc.c

V3->V4:
- Gut patches to the bare essentials: Only replace modules.c percpu alloocator
- Make percpu reserve area configurable via a kernel parameter


-- 
