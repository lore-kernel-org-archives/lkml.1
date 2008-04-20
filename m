Return-Path: <linux-kernel-owner+w=401wt.eu-S1763107AbYDTCz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763107AbYDTCz6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 22:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbYDTCyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 22:54:40 -0400
Received: from smtp01.mtu.ru ([62.5.255.48]:55923 "EHLO smtp01.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434AbYDTCyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 22:54:38 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] x86_64: the standard_io_resources[] array can become static
Date: Sun, 20 Apr 2008 06:54:33 +0400
Message-Id: <1208660074-7324-4-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1208660074-7324-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1208660074-7324-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp01.mtu.ru 10002; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In arch/x86/kernel/setup_64.c, the standard_io_resources array
is needlessly defined as global. This patch makes this variable
static.

This patch was successfully build-tested using the defconfig
for x86_64. Runtime test was performed by booting a 64-bit x86
box up to the shell prompt.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 arch/x86/kernel/setup_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index cd245ef..0332ae2 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -117,7 +117,7 @@ extern int root_mountflags;
 
 char __initdata command_line[COMMAND_LINE_SIZE];
 
-struct resource standard_io_resources[] = {
+static struct resource standard_io_resources[] = {
 	{ .name = "dma1", .start = 0x00, .end = 0x1f,
 		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
 	{ .name = "pic1", .start = 0x20, .end = 0x21,
-- 
1.5.3

