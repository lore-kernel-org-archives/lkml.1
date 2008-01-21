Return-Path: <linux-kernel-owner+w=401wt.eu-S1758510AbYAUWQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510AbYAUWQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 17:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756243AbYAUWPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 17:15:50 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:6371 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751727AbYAUWPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 17:15:48 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ijc@hellion.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>,
       =?utf-8?q?Mika=20Penttil=C3=A4?= <mika.penttila@kolumbus.fi>
Date: Mon, 21 Jan 2008 22:15:18 +0000
Message-Id: <1200953721-3815-1-git-send-email-ijc@hellion.org.uk>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: 479510CE.7010706@zytor.com
References: 479510CE.7010706@zytor.com
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: [0/3] x86_32: Construct 32 bit boot time page tables in native format.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches change x86_32 to use native format for the boot
time page tables. The first two are taken directly from Eric
Biederman's older patch series
http://marc.info/?l=linux-kernel&m=117794868309910&w=2 and
http://marc.info/?l=linux-kernel&m=117794868819193&w=2 while the final
patch is http://marc.info/?l=linux-kernel&m=117795243926186&w=2
updated for the current tree (much of it was already in, the rest has
been extensively modified).

Changes since v1:
 - Grabbed Eric's patches for enabling PAE in head_32.S -- I think
   they are cleaner than what I had.
 - Use native_* accessors instead of #undef CONFIG_PARAVIRT. This
   approach seem cleaner and also allows the code to live in init_32.c
   instead of creating a new file.
 - Ensure we map enough pages to create a full 4G mapping of
   lowmem. This now includes the space for the initial page tables
   rather than being in addition too.
 - Continue to map extra pages for CONFIG_DEBUG_PAGEALLOC and some
   extra pages for slack, per the original assembly code.

Cheers,
Ian.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Mika Penttilä <mika.penttila@kolumbus.fi>
