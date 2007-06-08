Return-Path: <linux-kernel-owner+w=401wt.eu-S969688AbXFHQD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969688AbXFHQD7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965798AbXFHQDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:03:48 -0400
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:7979 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965945AbXFHQDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:03:47 -0400
X-IronPort-AV: i="4.16,400,1175497200"; 
   d="scan'208"; a="378073894:sNHT50874600"
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Cc: "Adrian Bunk" <bunk@stusta.de>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       jcm@jonmasters.org, "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Andy Whitcroft" <apw@shadowen.org>, "Andrew Morton" <akpm@osdl.org>,
       "Randy Dunlap" <rdunlap@xenotime.net>,
       "Joel Schopp" <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.03
X-Message-Flag: Warning: May contain useful information
References: <0a25fd03117c678f17006c5fcefaaed0@pinky>
	<9a8748490706060205y1fc8e354p4af7426fd76dd816@mail.gmail.com>
	<Pine.LNX.4.64.0706071622280.8762@fbirervta.pbzchgretzou.qr>
	<20070607193413.GR5500@stusta.de>
	<20070607232248.332edee8@the-village.bc.nu>
	<20070607232152.GU5500@stusta.de>
	<20070608004117.57868755@the-village.bc.nu>
	<20070608000455.GW5500@stusta.de>
	<20070608115219.694c642d@the-village.bc.nu>
	<20070608123942.GZ5500@stusta.de>
	<9a8748490706080734h6ce5959fq6e7cb802d9a555cc@mail.gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 08 Jun 2007 09:03:36 -0700
In-Reply-To: <9a8748490706080734h6ce5959fq6e7cb802d9a555cc@mail.gmail.com> (Jesper Juhl's message of "Fri, 8 Jun 2007 16:34:01 +0200")
Message-ID: <adawsyebfhj.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Jun 2007 16:03:36.0354 (UTC) FILETIME=[92300020:01C7A9E6]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > ./drivers/infiniband/core/multicast.c:                    UTF-8 Unicode C program text
 > ./drivers/infiniband/core/sa.h:                           UTF-8 Unicode C program text
 > ./drivers/infiniband/core/sa_query.c:                     UTF-8 Unicode C program text

These three seem to be caused by bogus 0xa0 characters that snuck in
somehow.  I'll push the patch below for 2.6.23:

diff --git a/drivers/infiniband/core/multicast.c b/drivers/infiniband/core/multicast.c
index 1e13ab4..15b4c4d 100644
--- a/drivers/infiniband/core/multicast.c
+++ b/drivers/infiniband/core/multicast.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2006 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2006 Intel Corporation.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
diff --git a/drivers/infiniband/core/sa.h b/drivers/infiniband/core/sa.h
index 24c93fd..b1d4bbf 100644
--- a/drivers/infiniband/core/sa.h
+++ b/drivers/infiniband/core/sa.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004 Topspin Communications.  All rights reserved.
- * Copyright (c) 2005 Voltaire, Inc.  All rights reserved.
+ * Copyright (c) 2005 Voltaire, Inc.  All rights reserved.
  * Copyright (c) 2006 Intel Corporation.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 6469406..9d3797f 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004 Topspin Communications.  All rights reserved.
- * Copyright (c) 2005 Voltaire, Inc.  All rights reserved.
+ * Copyright (c) 2005 Voltaire, Inc.  All rights reserved.
  * Copyright (c) 2006 Intel Corporation.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
