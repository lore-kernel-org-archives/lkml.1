Return-Path: <linux-kernel-owner+w=401wt.eu-S1754055AbZF2Fdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbZF2Fdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 01:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750962AbZF2Fda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 01:33:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57381 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbZF2Fd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 01:33:29 -0400
Date: Mon, 29 Jun 2009 15:33:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: linux-next: manual merge of the percpu tree with Linus' tree
Message-Id: <20090629153329.309e0420.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the percpu tree got a conflict in
arch/mn10300/kernel/vmlinux.lds.S between commit
2e8b5a09ebf1f98f02c1988a48415e89d4c25168 ("MN10300: Fix the vmlinux
ldscript") from Linus' tree and commit
405d967dc70002991f8fc35c20e0d3cbc7614f63 ("linker script: throw
away .discard section") from the percpu tree.

Just context changes.  I fixed it up (see below) and can carry the fix
for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/mn10300/kernel/vmlinux.lds.S
index c96ba3d,5d9f2f9..0000000
--- a/arch/mn10300/kernel/vmlinux.lds.S
+++ b/arch/mn10300/kernel/vmlinux.lds.S
@@@ -117,7 -145,8 +117,8 @@@ SECTION
  
    /* Sections to be discarded */
    /DISCARD/ : {
 -	*(.exitcall.exit)
 +	EXIT_CALL
+ 	*(.discard)
  	}
  
    STABS_DEBUG
