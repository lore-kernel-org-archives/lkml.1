Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825AbZAKMHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbZAKMHm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 07:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbZAKMHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 07:07:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50816
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751411AbZAKMHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 07:07:31 -0500
Date: Sun, 11 Jan 2009 04:07:32 -0800 (PST)
Message-Id: <20090111.040732.196007749.davem@davemloft.net>
To: rol@witbe.net
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.29-rc1
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090111111825.49eaee0d@tux.DEF.witbe.net>
References: <alpine.LFD.2.00.0901101551420.6528@localhost.localdomain>
	<20090111111825.49eaee0d@tux.DEF.witbe.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Rolland (ポール・ロラン) <rol@witbe.net>
Date: Sun, 11 Jan 2009 11:18:25 +0100

> Hello,
> 
> On Sat, 10 Jan 2009 16:13:02 -0800 (PST)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > 
> > The merge window is over, and while it is quite possible that I missed a 
> > few merge requests in the crazy week that is behind us, apart from those 
> > we should now have most of the bulk of 2.6.29 merged up. And now it's
> > just a small matter of making sure it's all stable and ready to go.
> > 
> 
> Don't know if this is important or not, but I have :

I already have a fix for this pending in my tree:

net: fix section mismatch warnings in dccp/ccids/lib/tfrc.c

Removed the __exit annotation of tfrc_lib_exit(), in order to suppress the following section mismatch messages:

WARNING: net/dccp/dccp.o(.text+0xd9): Section mismatch in reference from the function ccid_cleanup_builtins() to the function .exit.text:tfrc_lib_exit()
The function ccid_cleanup_builtins() references a function in an exit section.
Often the function tfrc_lib_exit() has valid usage outside the exit section
and the fix is to remove the __exit annotation of tfrc_lib_exit.

WARNING: net/dccp/dccp.o(.init.text+0x48): Section mismatch in reference from the function ccid_initialize_builtins() to the function .exit.text:tfrc_lib_exit()
The function __init ccid_initialize_builtins() references
a function __exit tfrc_lib_exit().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __exit annotation of
tfrc_lib_exit() so it may be used outside an exit section.

Signed-off-by: Leonardo Potenza <lpotenza@inwind.it>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Gerrit Renker <gerrit@erg.abdn.ac.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/dccp/ccids/lib/tfrc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/dccp/ccids/lib/tfrc.c b/net/dccp/ccids/lib/tfrc.c
index 60c412c..4902029 100644
--- a/net/dccp/ccids/lib/tfrc.c
+++ b/net/dccp/ccids/lib/tfrc.c
@@ -36,7 +36,7 @@ out:
 	return rc;
 }
 
-void __exit tfrc_lib_exit(void)
+void tfrc_lib_exit(void)
 {
 	tfrc_rx_packet_history_exit();
 	tfrc_tx_packet_history_exit();
-- 
1.6.1.15.g159c88

