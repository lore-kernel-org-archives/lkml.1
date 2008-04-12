Return-Path: <linux-kernel-owner+w=401wt.eu-S1755201AbYDLPmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbYDLPmj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 11:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbYDLPmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 11:42:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:3181 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbYDLPmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 11:42:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=QmgvvixgEE7E5uVVcRvHh2Yt/FJ0GGQ5FO95VHqhDjQ25qxHe5shsdjqHgtUcUEjaXVt07aL5gnPbewXmGvGi1jlr6UJtc7Dr88bZ+Lr7OqLHgVVvvN4WOhdJfe0VD4TwwnHe7qB+Rrk4S8Tns463p8JnD0qDX+scV54/ReBdwg=
Message-ID: <4800D78C.907@gmail.com>
Date: Sat, 12 Apr 2008 17:38:52 +0200
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de
Subject: [PATCH 1/3] x86: trampoline_32.S - switch to .cpuinit.data
References: <4800D743.3000405@gmail.com>
In-Reply-To: <4800D743.3000405@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes section mismatch warnings of __cpuinit setup_trampoline() on 32-bit host.

Signed-off-by: Jacek Luczak <luczak.jacek@gmail.com>

---
 trampoline_32.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
 
diff --git a/arch/x86/kernel/trampoline_32.S b/arch/x86/kernel/trampoline_32.S
index 6458067..d8ccc3c 100644
--- a/arch/x86/kernel/trampoline_32.S
+++ b/arch/x86/kernel/trampoline_32.S
@@ -33,7 +33,7 @@
 
 /* We can free up trampoline after bootup if cpu hotplug is not supported. */
 #ifndef CONFIG_HOTPLUG_CPU
-.section ".init.data","aw",@progbits
+.section ".cpuinit.data","aw",@progbits
 #else
 .section .rodata,"a",@progbits
 #endif
