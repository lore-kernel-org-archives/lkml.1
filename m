Return-Path: <linux-kernel-owner+w=401wt.eu-S1753266AbXF3CfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbXF3CfJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 22:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbXF3Ce5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 22:34:57 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:56607 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbXF3Ce4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 22:34:56 -0400
Date: Sat, 30 Jun 2007 05:34:51 +0300
From: Dan Aloni <da-x@monatomic.org>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: [RFC] automatic CC generation for patch submission
Message-ID: <20070630023451.GA21593@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'd like to present a suggestion for automatic generation of 
carbon copy fields in the E-Mails of posted patches.

Basically, instead of manually figuring out who to add to CC
when sending a patch to LKML by looking at MAINTAINERS, a 
script can look at '.maintainers' files spread across the
source tree and automatically generate a proper list of CCs
for a patch.

To illustrate: If a patch affects a file under 
drivers/net/e1000, the CC script will look at these files

  drivers/net/e1000/.maintainers
  drivers/net/.maintainers
  drivers/.maintainers
  .maintainers

... to gather up the mailing list addresses or an individual 
maintainer inbox address.

A posssible format for this file could be a newline-separated
list of:

  [filename wildcard]:e-mail

For example, drivers/scsi/.maintainers would contain:

  libiscsi.*:open-iscsi@googlegroups.com
  scsi_*.c:scsi-devel@vger.kernel.org

  etc...

Or, instead (or in addition) of having a '.maintainers' file 
each directory we can modify source files by adding parsable 
'/* MAINTAINER: name@domain */' comments. 

Some extensions to the popular E-Mail clients might be needed 
here. Also, a bot reading LKML would automatically send links 
about posted patches to the other mailing lists whenever 
someone forgets to add a CC.

Any comments?

-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
