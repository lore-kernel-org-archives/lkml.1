Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbZD1VA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbZD1VA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 17:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbZD1VAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 17:00:48 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:61467 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbZD1VAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 17:00:47 -0400
Message-ID: <49F76E8C.3070808@oracle.com>
Date: Tue, 28 Apr 2009 14:01:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: "J. Bruce Fields" <bfields@fieldses.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH v2] lockd: fix FILE_LOCKING=n build error
References: <20090428165343.2e357d7a.sfr@canb.auug.org.au>	 <49F71F4A.3080908@oracle.com> <20090428172137.GA22451@fieldses.org>	 <49F7421A.1090709@oracle.com> <1240942554.7376.38.camel@heimdal.trondhjem.org>
In-Reply-To: <1240942554.7376.38.camel@heimdal.trondhjem.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010209.49F76E45.000B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust wrote:
> Until someone finds time to go through the code and add in all the
> CONFIG_FILE_LOCKING special cases, the above needs to be a 'depends on
> INET && FILE_LOCKING'.

That seems to work.  Thanks.




From: Randy Dunlap <randy.dunlap@oracle.com>

lockd without FILE_LOCKING doesn't make sense, so make LOCKD and
LOCKD_V4 depend on FILE_LOCKING, and make NFS depend on FILE_LOCKING.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/Kconfig     |    2 ++
 fs/nfs/Kconfig |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- linux-next-20090428.orig/fs/Kconfig
+++ linux-next-20090428/fs/Kconfig
@@ -226,10 +226,12 @@ source "fs/nfsd/Kconfig"
 
 config LOCKD
 	tristate
+	depends on FILE_LOCKING
 
 config LOCKD_V4
 	bool
 	depends on NFSD_V3 || NFS_V3
+	depends on FILE_LOCKING
 	default y
 
 config EXPORTFS
--- linux-next-20090428.orig/fs/nfs/Kconfig
+++ linux-next-20090428/fs/nfs/Kconfig
@@ -1,6 +1,6 @@
 config NFS_FS
 	tristate "NFS client support"
-	depends on INET
+	depends on INET && FILE_LOCKING
 	select LOCKD
 	select SUNRPC
 	select NFS_ACL_SUPPORT if NFS_V3_ACL
