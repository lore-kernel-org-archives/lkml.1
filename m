Return-Path: <linux-kernel-owner+w=401wt.eu-S1761972AbXLQW1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761972AbXLQW1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 17:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756145AbXLQW1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 17:27:38 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:2624 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbXLQW1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 17:27:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hVv8JbxPLaMvyYsfpcg8alYnMCnAra8ec2Oae92TmDaAX1i+uKcut2l3bm3nTNPk6p15Vomc//eb1oi2IQjqqD/Hp6oAB+8mZNk9pl3Rgc41O25xa0OnFR/n6z9fmKi02gjDkXSefPYqcWdckqosart3TMOMc0dbyzhZbrbuDrs=
Subject: [PATCH 3/4] x86: add kprobe-booster to X86_64
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Roland McGrath <roland@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 17 Dec 2007 14:27:44 -0800
Message-Id: <1197930464.23402.112.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry I missed an ifdef in this patch in the following hunk:

@@ -183,6 +185,9 @@ retry:
        }
 
        switch (opcode & 0xf0) {
+#ifdef X86_64
+       case 0x40:
+               goto retry; /* REX prefix is boostable */
        case 0x60:
                if (0x63 < opcode && opcode < 0x67)
                        goto retry; /* prefixes */

Just add the #ifdef to only catch case 0x40.

@@ -183,6 +185,10 @@ retry:
        }
 
        switch (opcode & 0xf0) {
+#ifdef X86_64
+       case 0x40:
+               goto retry; /* REX prefix is boostable */
+#endif
        case 0x60:
                if (0x63 < opcode && opcode < 0x67)
                        goto retry; /* prefixes */

Cheers,

Harvey

