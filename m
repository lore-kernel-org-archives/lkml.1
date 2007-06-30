Return-Path: <linux-kernel-owner+w=401wt.eu-S1753734AbXF3CwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734AbXF3CwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 22:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbXF3CwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 22:52:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:40640 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbXF3CwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 22:52:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,477,1175497200"; 
   d="scan'208";a="260617287"
Message-ID: <4685C549.3020602@intel.com>
Date: Fri, 29 Jun 2007 19:51:53 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070623)
MIME-Version: 1.0
To: Dan Aloni <da-x@monatomic.org>
CC: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] automatic CC generation for patch submission
References: <20070630023451.GA21593@localdomain>
In-Reply-To: <20070630023451.GA21593@localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Aloni wrote:
> Hello,
> 
> I'd like to present a suggestion for automatic generation of 
> carbon copy fields in the E-Mails of posted patches.
> 
> Basically, instead of manually figuring out who to add to CC
> when sending a patch to LKML by looking at MAINTAINERS, a 
> script can look at '.maintainers' files spread across the
> source tree and automatically generate a proper list of CCs
> for a patch.
> 
> To illustrate: If a patch affects a file under 
> drivers/net/e1000, the CC script will look at these files
> 
>   drivers/net/e1000/.maintainers
>   drivers/net/.maintainers
>   drivers/.maintainers
>   .maintainers
> 
> ... to gather up the mailing list addresses or an individual 
> maintainer inbox address.
> 
> A posssible format for this file could be a newline-separated
> list of:
> 
>   [filename wildcard]:e-mail
> 
> For example, drivers/scsi/.maintainers would contain:
> 
>   libiscsi.*:open-iscsi@googlegroups.com
>   scsi_*.c:scsi-devel@vger.kernel.org
> 
>   etc...
> 
> Or, instead (or in addition) of having a '.maintainers' file 
> each directory we can modify source files by adding parsable 
> '/* MAINTAINER: name@domain */' comments. 
> 
> Some extensions to the popular E-Mail clients might be needed 
> here. Also, a bot reading LKML would automatically send links 
> about posted patches to the other mailing lists whenever 
> someone forgets to add a CC.
> 
> Any comments?

an easier way to implement this is to add an extra field in the MAINTAINERS 
file, something like below. All the contact info would stay the same, closely 
where applicable and it would allow you to also specify specific files as well.

Auke

(horribly whitespace-mutilated copy+paste from thunderbird below)

---
diff --git a/MAINTAINERS b/MAINTAINERS
index 4c3277c..e55be49 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -69,6 +69,7 @@ L: Mailing list that is relevant to this area
  W: Web-page with status/info
  T: SCM tree type and location.  Type is one of: git, hg, quilt.
  S: Status, one of the following:
+F: Directory tree or Files belonging to this subsystem

         Supported:      Someone is actually paid to look after this.
         Maintained:     Someone actually looks after it.
@@ -1880,6 +1881,7 @@ M:        auke-jan.h.kok@intel.com
  L:     e1000-devel@lists.sourceforge.net
  W:     http://sourceforge.net/projects/e1000/
  S:     Supported
+F:     drivers/net/e100.c

  INTEL PRO/1000 GIGABIT ETHERNET SUPPORT
  P:     Jeb Cramer
@@ -1895,6 +1897,7 @@ M:        auke-jan.h.kok@intel.com
  L:     e1000-devel@lists.sourceforge.net
  W:     http://sourceforge.net/projects/e1000/
  S:     Supported
+F:     drivers/net/e1000/

  INTEL PRO/10GbE SUPPORT
  P:     Jeff Kirsher
@@ -1910,6 +1913,7 @@ M:        auke-jan.h.kok@intel.com
  L:     e1000-devel@lists.sourceforge.net
  W:     http://sourceforge.net/projects/e1000/
  S:     Supported
+F:     drivers/net/ixgb/

  INTEL PRO/WIRELESS 2100 NETWORK CONNECTION SUPPORT
  P:     Yi Zhu
