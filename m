Return-Path: <linux-kernel-owner+w=401wt.eu-S1757173AbZIOVhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbZIOVhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 17:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbZIOVhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 17:37:11 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:51346 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751090AbZIOVhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 17:37:10 -0400
X-Trace: 258461203/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.84.74/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.84.74
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoYHAKmlr0pPRVRK/2dsb2JhbACBU45rAc91hBcF
X-IronPort-AV: E=Sophos;i="4.44,392,1249254000"; 
   d="scan'208";a="258461203"
Date: Tue, 15 Sep 2009 22:36:26 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Ben Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Subject: mmotm on powerpc: walk_memory_resource?
Message-ID: <Pine.LNX.4.64.0909152224400.29857@sister.anvils>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1939220403-1253050586=:29857"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1939220403-1253050586=:29857
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

Recent mmotm builds on powerpc have been failing with

arch/powerpc/mm/mem.c:169: error: =E2=80=98walk_memory_resource=E2=80=99 un=
declared here (not in a function)
cc1: warnings being treated as errors
arch/powerpc/mm/mem.c:169: error: type defaults to =E2=80=98int=E2=80=99 in=
 declaration of =E2=80=98walk_memory_resource=E2=80=99
make[1]: *** [arch/powerpc/mm/mem.o] Error 1

because walk-system-ram-range.patch renames walk_memory_resource()
but leaves the EXPORT_SYMBOL_GPL(walk_memory_resource).  I couldn't
tell from the patch description whether it's a matter of changing
the EXPORT_SYMBOL_GPL or removing the patch to arch/powerpc/mm/mem.c
or something else.  (I change the EXPORT to get my build working,
but there appears to be something in drivers/infiniband which still
wants a walk_memory_resource.)

Hugh
--8323584-1939220403-1253050586=:29857--
