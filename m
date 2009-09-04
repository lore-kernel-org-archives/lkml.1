Return-Path: <linux-kernel-owner+w=401wt.eu-S933230AbZIDH7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230AbZIDH7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 03:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933023AbZIDH7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 03:59:35 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:32467 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932803AbZIDH7f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 03:59:35 -0400
Message-Id: <4AA0E50702000078000136D8@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Fri, 04 Sep 2009 08:59:35 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <vandrove@vc.cvut.cz>
Cc: <linware@sh.cvut.cz>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] ncpfs: fix selection of NLS
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order for nls_base to really be compilable as a module, the select
from ncpfs needs to be corrected: Boolean sub-options of tristate
options selecting another tristate option should not do the select
themselves, as that forces the selected option to Y. Instead, a
conditional select in the base tristate option is needed.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 fs/ncpfs/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.31-rc8/fs/ncpfs/Kconfig	2009-03-24 00:12:14.000000000 +0100
+++ 2.6.31-rc8-ncpfs-nls-select/fs/ncpfs/Kconfig	2009-09-02 13:56:05.000000000 +0200
@@ -4,6 +4,7 @@
 config NCP_FS
 	tristate "NCP file system support (to mount NetWare volumes)"
 	depends on IPX!=n || INET
+	select NLS if NCPFS_NLS
 	help
 	  NCP (NetWare Core Protocol) is a protocol that runs over IPX and is
 	  used by Novell NetWare clients to talk to file servers.  It is to
@@ -86,7 +87,6 @@ config NCPFS_SMALLDOS
 config NCPFS_NLS
 	bool "Use Native Language Support"
 	depends on NCP_FS
-	select NLS
 	help
 	  Allows you to use codepages and I/O charsets for file name
 	  translation between the server file system and input/output. This



