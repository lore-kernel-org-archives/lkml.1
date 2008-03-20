Return-Path: <linux-kernel-owner+w=401wt.eu-S1759889AbYCTWqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759889AbYCTWqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 18:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759330AbYCTWqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 18:46:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759196AbYCTWqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 18:46:15 -0400
Date: Thu, 20 Mar 2008 15:45:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, ketuzsezr@darnok.org
Subject: Re: [mmotm] iscsi_ibft build error
Message-Id: <20080320154555.2d74c0d5.akpm@linux-foundation.org>
In-Reply-To: <20080319115655.ff4cb67a.randy.dunlap@oracle.com>
References: <20080319115655.ff4cb67a.randy.dunlap@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2008 11:56:55 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> mmotm-2008-0318-1720/drivers/firmware/iscsi_ibft.c: In function 'ibft_show_attribute':
> mmotm-2008-0318-1720/drivers/firmware/iscsi_ibft.c:521: error: implicit declaration of function 'capable'
> mmotm-2008-0318-1720/drivers/firmware/iscsi_ibft.c:521: error: 'CAP_SYS_ADMIN' undeclared (first use in this function)
> mmotm-2008-0318-1720/drivers/firmware/iscsi_ibft.c:521: error: (Each undeclared identifier is reported only once
> mmotm-2008-0318-1720/drivers/firmware/iscsi_ibft.c:521: error: for each function it appears in.)
> make[3]: *** [drivers/firmware/iscsi_ibft.o] Error 1
> 

--- a/drivers/firmware/iscsi_ibft.c~scsi-add-iscsi-ibft-support-fix
+++ a/drivers/firmware/iscsi_ibft.c
@@ -65,6 +65,7 @@
 
 
 #include <linux/blkdev.h>
+#include <linux/capability.h>
 #include <linux/ctype.h>
 #include <linux/device.h>
 #include <linux/err.h>

should do the trick.

Does this driver actually need to run capable(CAP_SYS_ADMIN)?  Can we not
rely upon permissions of the reelvant sysfs file?
