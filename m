Return-Path: <linux-kernel-owner+w=401wt.eu-S1423472AbXD3QM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423472AbXD3QM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423544AbXD3QM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:12:56 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52734 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423737AbXD3QMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:12:12 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <ak@suse.de>
Cc: virtualization <virtualization@lists.linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 07/12] i386: Add missing !X86_PAE dependincy to the 2G/2G split.
References: <m1d51l6f1y.fsf@ebiederm.dsl.xmission.com>
	<m18xc96eyq.fsf@ebiederm.dsl.xmission.com>
	<m14pmx6ewk.fsf_-_@ebiederm.dsl.xmission.com>
	<m1zm4p509a.fsf_-_@ebiederm.dsl.xmission.com>
	<m1vefd4zyj.fsf_-_@ebiederm.dsl.xmission.com>
	<m1r6q14zow.fsf_-_@ebiederm.dsl.xmission.com>
	<m1mz0p4zfc.fsf_-_@ebiederm.dsl.xmission.com>
Date: Mon, 30 Apr 2007 10:10:49 -0600
In-Reply-To: <m1mz0p4zfc.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Mon, 30 Apr 2007 10:09:11 -0600")
Message-ID: <m1irbd4zcm.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When in PAE mode we require that the user kernel divide to be
on a 1G boundary.  The 2G/2G split does not have that property
so require !X86_PAE

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/i386/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
index 1a94a73..80003de 100644
--- a/arch/i386/Kconfig
+++ b/arch/i386/Kconfig
@@ -570,6 +570,7 @@ choice
 		depends on !HIGHMEM
 		bool "3G/1G user/kernel split (for full 1G low memory)"
 	config VMSPLIT_2G
+		depends on !X86_PAE
 		bool "2G/2G user/kernel split"
 	config VMSPLIT_1G
 		bool "1G/3G user/kernel split"
-- 
1.5.1.1.181.g2de0

