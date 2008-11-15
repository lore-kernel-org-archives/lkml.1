Return-Path: <linux-kernel-owner+w=401wt.eu-S1753406AbYKOPmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbYKOPmp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 10:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbYKOPmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 10:42:36 -0500
Received: from mail.gmx.net ([213.165.64.20]:52989 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751447AbYKOPmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 10:42:35 -0500
X-Authenticated: #34473864
X-Provags-ID: V01U2FsdGVkX1/g5oUB57zgOqxmBsT3l/yxaNbpt5DJ5wnQCqbzIl
	DQ+zcfAXPfkkmV
Message-ID: <491EEDE8.5080508@gmx.de>
Date: Sat, 15 Nov 2008 16:42:32 +0100
From: Philipp Kohlbecher <xt28@gmx.de>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: alternative identifier for Phoenix BIOS
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My laptop (a Samsung X20) contains a Phoenix BIOS and would benefit from 
patch 1e22436eba84edfec9c25e5a25d09062c4f91ca9 (x86: reserve low 64K on 
AMI and Phoenix BIOS boxen).

However, according to /sys/class/dmi/id/bios_vendor, the BIOS identifies
its vendor as "Phoenix Technologies LTD" (sans the comma).

This patch adds the approptiate identifier to the bad_bios_dmi_table in
arch/x86/kernel/setup.c.

The patch compiles cleanly and has been tested successfully on my machine.

Signed-off-by: Philipp Kohlbecher <xt28@gmx.de>

---

Please CC me, I am not on the list.

  arch/x86/kernel/setup.c |    7 +++++++
  1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 0fa6790..b88fdbe 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -767,6 +767,13 @@ static struct dmi_system_id __initdata
bad_bios_dmi_table[] = {
              DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies, LTD"),
          },
      },
+    {
+        .callback = dmi_low_memory_corruption,
+        .ident = "Phoenix BIOS",
+        .matches = {
+            DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies LTD"),
+        },
+    },
  #endif
      {}
  };

