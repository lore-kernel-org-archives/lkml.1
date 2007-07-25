Return-Path: <linux-kernel-owner+w=401wt.eu-S1761987AbXGYUqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761987AbXGYUqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 16:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754523AbXGYUqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 16:46:36 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:31401 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753352AbXGYUqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 16:46:35 -0400
Date: Wed, 25 Jul 2007 14:54:01 -0600
From: dougthompson@xmission.com
To: greg@kroah.com, ralf@linux-mips.org, egor@pasemi.com,
       dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 0/4] drivers edac fix misc rc1 issues
Message-ID: <46a7b869.B9+GCdU0ymLKXy4w%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.1 6/15/06
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Doug Thompson <dougthompson@xmission.com>

This EDAC patch set was applied against: 2.6.23-rc1

4 Patches in this set

1) Fixed workq reset undefined problem and found missing workq
   value reset and possible deadlock as we found in edac_device code.
   Each edac_mc control structure is scanned by a workq trigger event
   and that period valu can be modified by a sysfs control.
   This control didn't update the workq value. Now it does

2) Fixed the sysfs of the edac_pci scanning devices. Removed
   Old incorrect code and now reference counters are used on the kobjects
   and reference count on the edac_core.ko module, to keep it in
   memory until all references have cleared

3) Fixed the missing include/asm-mips/edac.h for MIPS which required
   for proper operation on MIPS

4) Fixed a 'depends on' state for the PPC_PASEMI driver.
   Was originally just PPC, but that was incorrect, and would compile
   on all PPC. Now just PPC_PASEMI builds will build this driver.

Signed-off-by:  Doug Thompson <dougthompson@xmission.com>
