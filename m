Return-Path: <linux-kernel-owner+w=401wt.eu-S933397AbZDHMSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397AbZDHMSw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933736AbZDHMSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:18:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35867 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933641AbZDHMSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:18:20 -0400
Date: Wed, 8 Apr 2009 14:17:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] early-quirks: remove duplicate #ifdef
Message-ID: <20090408121757.GA18581@elte.hu>
References: <49DA7E18.1050209@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49DA7E18.1050209@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> "#if defined(CONFIG_ACPI) && defined(CONFIG_X86_IO_APIC)" was repeated
> twice.
>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

hm, this was due to the patch below. Your patch essentially reverts 
that patch?

	Ingo

--------------->
>From a59dacfdc9ba06903652fa4883bf1106278b18ec Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 17 Oct 2008 14:38:08 +0200
Subject: [PATCH] x86 early quirks: eliminate unused function
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Impact: cleanup

this warning:

  arch/x86/kernel/early-quirks.c:99: warning: ‘ati_ixp4x0_rev’ defined but not used

triggers because ati_ixp4x0_rev() is only used in the
ACPI && X86_IO_APIC case.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/early-quirks.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 76b8cd9..ebdb85c 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -97,6 +97,7 @@ static void __init nvidia_bugs(int num, int slot, int func)
 }
 
 #if defined(CONFIG_ACPI) && defined(CONFIG_X86_IO_APIC)
+#if defined(CONFIG_ACPI) && defined(CONFIG_X86_IO_APIC)
 static u32 __init ati_ixp4x0_rev(int num, int slot, int func)
 {
 	u32 d;
@@ -114,6 +115,7 @@ static u32 __init ati_ixp4x0_rev(int num, int slot, int func)
 	d &= 0xff;
 	return d;
 }
+#endif
 
 static void __init ati_bugs(int num, int slot, int func)
 {
