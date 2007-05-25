Return-Path: <linux-kernel-owner+w=401wt.eu-S1762589AbXEYNFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762589AbXEYNFR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 09:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbXEYNFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 09:05:05 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:52364 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbXEYNFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 09:05:03 -0400
X-Greylist: delayed 738 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 May 2007 09:05:02 EDT
Message-ID: <4656DEED.20202@hitachi.com>
Date: Fri, 25 May 2007 22:04:45 +0900
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, holt@sgi.com, alan@lxorguk.ukuu.org.uk,
       masami.hiramatsu.pt@hitachi.com, yumiko.sugita.yf@hitachi.com,
       soshima@redhat.com, haoki@redhat.com
Subject: [PATCH 1/7] bound suid_dumpable sysctl
References: <4656DBFB.2050501@hitachi.com>
In-Reply-To: <4656DBFB.2050501@hitachi.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch limits a value of suid_dumpable sysctl to the range of 0 to 2.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 kernel/sysctl.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6.22-rc2-mm1/kernel/sysctl.c
===================================================================
--- linux-2.6.22-rc2-mm1.orig/kernel/sysctl.c
+++ linux-2.6.22-rc2-mm1/kernel/sysctl.c
@@ -690,6 +690,7 @@ static ctl_table kern_table[] = {
 /* Constants for minimum and maximum testing in vm_table.
    We use these as one-element integer vectors. */
 static int zero;
+static int two = 2;
 static int one_hundred = 100;
 
 
@@ -1125,7 +1126,10 @@ static ctl_table fs_table[] = {
 		.data		= &suid_dumpable,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+		.extra2		= &two,
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,


