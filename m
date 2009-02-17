Return-Path: <linux-kernel-owner+w=401wt.eu-S1754611AbZBQTn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbZBQTn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 14:43:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbZBQTnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 14:43:47 -0500
Received: from cmpxchg.org ([85.214.51.133]:38456 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092AbZBQTnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 14:43:46 -0500
Message-Id: <20090217182615.897042724@cmpxchg.org>
User-Agent: quilt/0.47-1
Date: Tue, 17 Feb 2009 19:26:15 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Chas Williams <chas@cmf.nrl.navy.mil>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [patch 0/7] kzfree() v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series introduces kzfree() and converts callsites which do
memset() + kzfree() explicitely.

The caller intention is to ensure that security-sensitive data are
cleared from slab objects before they are passed back to the
allocator.

This also removes the last modular ksize() user (crypto/api.c) again
by converting it to kzfree() which figures out the length of the
memory region to zero internally.

I left out drivers/w1/w1{,_int}.c and dropped the conversion of
drivers/atm/mpoa_caches.c in this iteration as I think they don't
strictly need the zeroeing and the memsetting should probably be
removed [ added Chas Williams and Evgeniy Polyakov to Cc ].

v2:
  - EXPORT_SYMBOL(kzfree), thanks linker
  - remove superfluous NULL checks, thanks Pekka
  - mention `security' in the description

	Hannes

 arch/s390/crypto/prng.c             |    3 +--
 crypto/api.c                        |    5 +----
 drivers/md/dm-crypt.c               |    6 ++----
 drivers/s390/crypto/zcrypt_pcixcc.c |    3 +--
 drivers/usb/host/hwa-hc.c           |    3 +--
 drivers/usb/wusbcore/cbaf.c         |    3 +--
 fs/cifs/connect.c                   |    6 +-----
 fs/cifs/misc.c                      |   10 ++--------
 fs/ecryptfs/keystore.c              |    3 +--
 fs/ecryptfs/messaging.c             |    3 +--
 include/linux/slab.h                |    1 +
 mm/util.c                           |   20 ++++++++++++++++++++
 12 files changed, 33 insertions(+), 33 deletions(-)

