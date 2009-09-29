Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbZI2Pcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbZI2Pcu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 11:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbZI2Pct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 11:32:49 -0400
Received: from mail09.linbit.com ([212.69.161.110]:38899 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbZI2Pct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 11:32:49 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: drbd-dev@lists.linbit.com
Subject: Re: [Drbd-dev] [PATCH -next] drbd: trace depends on TRACING
Date: Tue, 29 Sep 2009 17:32:50 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       akpm <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <20090925133830.1ba29584.sfr@canb.auug.org.au> <4ABD4C28.9070202@oracle.com>
In-Reply-To: <4ABD4C28.9070202@oracle.com>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909291732.51383.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 September 2009 01:03:04 Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> DRBD_TRACE should depend on TRACING.
> It's also possible that TRACEPOINTS should depend on TRACING.
>

Hi Randy,

I tried to figure out in which way that should be done. By looking
at "BLK_DEV_IO_TRACE" I got the impression that this should
be done by adding "select GENERIC_TRACER".

I will further examine this tomorrow. I just wanted to let you know
that this did not fall off the table...

-Phil

diff --git a/drivers/block/drbd/Kconfig b/drivers/block/drbd/Kconfig
index 4e6f90f..7b35287 100644
--- a/drivers/block/drbd/Kconfig
+++ b/drivers/block/drbd/Kconfig
@@ -7,7 +7,7 @@ comment "DRBD disabled because PROC_FS, INET or CONNECTOR not 
selected"

 config BLK_DEV_DRBD
        tristate "DRBD Distributed Replicated Block Device support"
-       depends on PROC_FS && INET && CONNECTOR
+       depends on BLOCK && PROC_FS && INET && CONNECTOR
        select LRU_CACHE
        default n
        help
@@ -42,6 +42,7 @@ config DRBD_TRACE
        tristate "DRBD tracing"
        depends on BLK_DEV_DRBD
        select TRACEPOINTS
+       select GENERIC_TRACER
        default n
        help
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.

