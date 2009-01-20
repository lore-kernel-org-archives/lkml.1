Return-Path: <linux-kernel-owner+w=401wt.eu-S1758348AbZATNQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348AbZATNQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 08:16:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756344AbZATNPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 08:15:50 -0500
Received: from rv-out-0506.google.com ([209.85.198.226]:22949 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532AbZATNPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 08:15:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ldLitljfSKAYvlAYG868YnadgBM9riUPkJjM0r01Ikn5uGGYdMlMUnywejoi04BiCl
         dWTHaSL/Pk1ncPym9uZpwixBvuACLYxKLQzpEyCggKY+XCsZ2/FPqe0mwikCQJGwAjSU
         GgrNDZCFaapx6yYBUHfFupmebVOSH3lRt7AeM=
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 2/6] x86-64: Fix percpu_write with 64-bit constants
Date: Tue, 20 Jan 2009 08:15:41 -0500
Message-Id: <1232457345-12366-2-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com>
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The processor will sign-extend 32-bit immediate values in 64-bit
operations.  Use the 'e' constraint ("32-bit signed integer constant,
or a symbolic reference known to fit that range") for 64-bit constants.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/percpu.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index ce980db..0b64af4 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -75,7 +75,7 @@ do {							\
 	case 8:						\
 		asm(op "q %1,"__percpu_arg(0)		\
 		    : "+m" (var)			\
-		    : "r" ((T__)val));			\
+		    : "re" ((T__)val));			\
 		break;					\
 	default: __bad_percpu_size();			\
 	}						\
-- 
1.6.1

