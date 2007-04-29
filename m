Return-Path: <linux-kernel-owner+w=401wt.eu-S1754287AbXD2DMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbXD2DMk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 23:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754291AbXD2DMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 23:12:40 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:41579 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754251AbXD2DMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 23:12:39 -0400
Date: Sat, 28 Apr 2007 20:12:29 -0700
From: Paul Jackson <pj@sgi.com>
To: menage@google.com
Cc: akpm@linux-foundation.org, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       vatsa@in.ibm.com, ebiederm@xmission.com, haveblue@us.ibm.com,
       svaidy@linux.vnet.ibm.com, balbir@in.ibm.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, rohitseth@google.com,
       devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 1/9] Containers (V9): Basic container
 framework
Message-Id: <20070428201229.3f437826.pj@sgi.com>
In-Reply-To: <20070427111300.015604000@menage.corp.google.com>
References: <20070427104607.252541000@menage.corp.google.com>
	<20070427111300.015604000@menage.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

+static ssize_t container_read_uint(struct container *cont, struct cftype *cft,
+				   struct file *file,
+				   char __user *buf, size_t nbytes,
+				   loff_t *ppos)
+{
+	char tmp[64];
+	u64 val = cft->read_uint(cont, cft);
+	int len = sprintf(tmp, "%llu", val);


This sprintf is giving me the following compiler warnings:

kernel/container.c: In function 'container_read_uint':
kernel/container.c:1025: warning: format '%llu' expects type 'long long unsigned int', but argument 3 has type 'u64'
kernel/container.c:1025: warning: format '%llu' expects type 'long long unsigned int', but argument 3 has type 'u64'  

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
