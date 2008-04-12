Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbYDLPnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbYDLPnr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 11:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbYDLPni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 11:43:38 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:34101 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113AbYDLPnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 11:43:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=kwjOicsBhcz8bSzTElJ/xp2FAapA7G78pD8Y6GlDYOhailBzJEiS7+Pl+wE7K75+6GfmhNSbbXxtzh2lNf+RyneryskkYBwIzUnoQI6lA8I0W2zHyCU/fzQQ/pgquzD1o0jrfNHbBN7t4ja/aexvkks2ciwj67biwj/cBBXdhvo=
Message-ID: <4800D7CD.6060504@gmail.com>
Date: Sat, 12 Apr 2008 17:39:57 +0200
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de
Subject: [PATCH 2/3] x86: uniq_ioapic_id - fix section mismatch warning
References: <4800D743.3000405@gmail.com>
In-Reply-To: <4800D743.3000405@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix folowing warning:
WARNING: arch/x86/kernel/built-in.o(.text+0x10799): Section mismatch in reference from the function uniq_ioapic_id()

uniq_ioapic_id() is only used by __init mp_register_ioapic(). Annotate uniq_ioapic_id() with __init.

Signed-off-by: Jacek Luczak <luczak.jacek@gmail.com>

---
 mpparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 70744e3..d885f8f 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -820,7 +820,7 @@ static int mp_find_ioapic(int gsi)
 	return -1;
 }
 
-static u8 uniq_ioapic_id(u8 id)
+static u8 __init uniq_ioapic_id(u8 id)
 {
 #ifdef CONFIG_X86_32
 	if ((boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) &&

