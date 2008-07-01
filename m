Return-Path: <linux-kernel-owner+w=401wt.eu-S1762062AbYGBBEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762062AbYGBBEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 21:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759094AbYGBBCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 21:02:37 -0400
Received: from gw.goop.org ([64.81.55.164]:58694 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758273AbYGBBBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 21:01:52 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 0 of 8] x86/xen: updated physical mapping patches,
	and _PAGE_GLOBAL cleanup
Message-Id: <patchbomb.1214955989@localhost>
Date: Tue, 01 Jul 2008 16:46:29 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here's a revised series of the Xen-64 groundwork patches relating to
creating the physical memory mapping.  The first few patches are the
necessary changes to make it work without triggering CPA warnings, and
the last couple are cleanups of _PAGE_GLOBAL in the _PAGE_KERNEL
flags, and could probably happily live in another topic branch
(they're not at all Xen-specific or required for Xen to work).

Breakdown:

1 - x86_64: create global mappings in head_64.S

  Create global mappings in head_64.S for consistency,
  to avoid spurious CPA failures.

2-5: Map physical memory in a Xen-compatible way

  These superscede "x86, 64-bit: adjust mapping of physical pagetables
  to work with Xen".

6: Fold _PAGE_GLOBAL into _PAGE_KENREL mappings

  This reverts patch 1, by solving the problem in a more general way.

7: Remove __PAGE_KERNEL* from 32-bit

  Patch 7 makes the 32-bit kernel's __PAGE_KERNEL variables redundant,
  so remove them.

8: Make CPA testing use some other pte bit

  Use an unused bit to test CPA, rather than _PAGE_GLOBAL, so that
  testing will still work when _PAGE_GLOBAL isn't usable.

Thanks,
	J

