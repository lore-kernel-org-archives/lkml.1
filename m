Return-Path: <linux-kernel-owner+w=401wt.eu-S1762984AbYBAFSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762984AbYBAFSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 00:18:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750838AbYBAFSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 00:18:20 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:24308 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbYBAFST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 00:18:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ldNAlMSElUuwpo4DrdIGkYEF734+KolgNbF6g6hvnbsru1df7HgU5jPCGdJWrmW4o+3NU+Z/g4COjEmmzWuce+vSofBHigOifFw92d0q6ERASA4ontXv0/zz88/HOrCIQN610auTCWlYYo3ckXB1nKrQ4DN3Xx9x1DxT6IxH2DA=
Subject: Re: Feature Removals for 2.6.25
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Jiri Slaby <jirislaby@gmail.com>,
       Pavel Machek <pavel@suse.cz>, Christoph Hellwig <hch@lst.de>,
       Dominik Brodowski <linux@brodo.de>, Andi Kleen <ak@suse.de>,
       Adrian Bunk <bunk@stusta.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       Nick Piggin <npiggin@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Len Brown <len.brown@intel.com>
In-Reply-To: <47A2A5D8.4080700@linux.intel.com>
References: <1201829922.23523.68.camel@brick>
	 <47A2A5D8.4080700@linux.intel.com>
Content-Type: text/plain
Date: Thu, 31 Jan 2008 21:18:11 -0800
Message-Id: <1201843092.23523.80.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-01-31 at 20:53 -0800, Arjan van de Ven wrote:
> > 
> > ---------------------------
> > 
> > What:	CONFIG_FORCED_INLINING
> > When:	June 2006
> > Why:	Config option is there to see if gcc is good enough. (in january
> >         2006). If it is, the behavior should just be the default. If it's not,
> > 	the option should just go away entirely.
> > Who:    Arjan van de Ven
> > 
> > Patch submitted to Arjan, maybe 2.6.25?
> 
> Ingo picked it up, but no rush for .25, .26 is fine for this as well
> 

OK, it shouldn't be any change from what's there now, but no rush.

> > 
> > What:	Unused EXPORT_SYMBOL/EXPORT_SYMBOL_GPL exports
> > 	(temporary transition config option provided until then)
> > 	The transition config option will also be removed at the same time.
> > When:	before 2.6.19
> > Why:	Unused symbols are both increasing the size of the kernel binary
> > 	and are often a sign of "wrong API"
> > Who:	Arjan van de Ven <arjan@linux.intel.com>
> 
> this is an ongoing work; symbols get marked unused and then garbage collected
> when they're due; for example akpm has several of that kind in his pile right now

How do they get marked?  As this is an ongoing effort, should this be
moved to the top of the file, and the actual symbols+date be listed?
That would make it easy to figure out what's going away.

Something like the following (grep found me two example symbols)

Harvey

---
From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH] feature-removal: document symbols going away

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 Documentation/feature-removal-schedule.txt |   25 +++++++++++++++----------
 1 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 3a46d1f..0c418e6 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -5,6 +5,21 @@ the work.  When the feature is removed from the kernel, it should also
 be removed from this file.
 
 ---------------------------
+What:	Unused EXPORT_SYMBOL/EXPORT_SYMBOL_GPL exports
+	(temporary transition config option provided until then)
+	The transition config option will also be removed at the same time.
+Why:	Unused symbols are both increasing the size of the kernel binary
+	and are often a sign of "wrong API"
+Who:	Arjan van de Ven <arjan@linux.intel.com>
+
+When: 2.6.25
+fs/open.c:sys_open
+fs/read_write.c:sys_read
+
+When: 2.6.26
+
+
+---------------------------
 
 What:	MXSER
 When:	December 2007
@@ -137,16 +152,6 @@ Who:    Adrian Bunk <bunk@stusta.de>
 
 ---------------------------
 
-What:	Unused EXPORT_SYMBOL/EXPORT_SYMBOL_GPL exports
-	(temporary transition config option provided until then)
-	The transition config option will also be removed at the same time.
-When:	before 2.6.19
-Why:	Unused symbols are both increasing the size of the kernel binary
-	and are often a sign of "wrong API"
-Who:	Arjan van de Ven <arjan@linux.intel.com>
-
----------------------------
-
 What:	USB driver API moves to EXPORT_SYMBOL_GPL
 When:	February 2008
 Files:	include/linux/usb.h, drivers/usb/core/driver.c
-- 
1.5.4.rc4.1142.gf5a97



