Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbXJXBEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbXJXBEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 21:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbXJXBEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 21:04:13 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:42634 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953AbXJXBEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 21:04:12 -0400
Message-ID: <471E9A09.4030607@tiscali.nl>
Date: Wed, 24 Oct 2007 03:04:09 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] Fix unlock on error
References: <471E9322.1030408@tiscali.nl>
In-Reply-To: <471E9322.1030408@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Fix unlock on error
    Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/arch/mips/kernel/irixsig.c b/arch/mips/kernel/irixsig.c
index a0a9105..a6e6e78 100644
--- a/arch/mips/kernel/irixsig.c
+++ b/arch/mips/kernel/irixsig.c
@@ -426,6 +426,7 @@ asmlinkage int irix_sigprocmask(int how, irix_sigset_t __user *new,
 			break;
 
 		default:
+			spin_unlock_irq(&current->sighand->siglock);
 			return -EINVAL;
 		}
 		recalc_sigpending();
diff --git a/arch/mips/vr41xx/common/icu.c b/arch/mips/vr41xx/common/icu.c
index 1899601..11f5f72 100644
--- a/arch/mips/vr41xx/common/icu.c
+++ b/arch/mips/vr41xx/common/icu.c
@@ -525,6 +525,7 @@ static inline int set_sysint1_assign(unsigned int irq, unsigned char assign)
 		intassign1 |= (uint16_t)assign << 9;
 		break;
 	default:
+		spin_unlock_irq(&desc->lock);
 		return -EINVAL;
 	}
 
@@ -592,6 +593,7 @@ static inline int set_sysint2_assign(unsigned int irq, unsigned char assign)
 		intassign3 |= (uint16_t)assign << 12;
 		break;
 	default:
+                spin_unlock_irq(&desc->lock);
 		return -EINVAL;
 	}
 
