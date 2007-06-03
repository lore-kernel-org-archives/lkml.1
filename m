Return-Path: <linux-kernel-owner+w=401wt.eu-S1752777AbXFCUpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbXFCUpo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 16:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbXFCUpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 16:45:12 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:54181 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbXFCUpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 16:45:10 -0400
X-IronPort-AV: i="4.16,378,1175497200"; 
   d="scan'208"; a="158235323:sNHT44714169"
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: thockin@google.com, Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Kconfig variable "COBALT" is not defined anywhere
X-Message-Flag: Warning: May contain useful information
References: <Pine.LNX.4.64.0706031315230.23477@localhost.localdomain>
	<20070603132309.508738b7.randy.dunlap@oracle.com>
	<Pine.LNX.4.64.0706031630030.26035@localhost.localdomain>
From: Roland Dreier <rdreier@cisco.com>
Date: Sun, 03 Jun 2007 13:45:08 -0700
In-Reply-To: <Pine.LNX.4.64.0706031630030.26035@localhost.localdomain> (Robert P. J. Day's message of "Sun, 3 Jun 2007 16:31:08 -0400 (EDT)")
Message-ID: <adazm3glqcr.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 03 Jun 2007 20:45:08.0743 (UTC) FILETIME=[12C54170:01C7A620]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > >   there is no Kconfig file which defines the selectable option
 > > > "COBALT", which means that this snippet from drivers/char/nvram.c:
 > > >
 > > > #  if defined(CONFIG_COBALT)
 > > > #    include <linux/cobalt-nvram.h>
 > > > #    define MACH COBALT
 > > > #  else
 > > > #    define MACH PC
 > > > #  endif
 > > > never evaluates to true, therefore making <linux/cobalt-nvram.h>
 > > > fairly useless, at least under the circumstances.

 > > Maybe it should be MIPS_COBALT ?

 > that's the first thing that occurred to me, but that header file is
 > copyright sun microsystems and says nothing about MIPS, so that didn't
 > really settle the issue.  that's why i'd rather someone else resolve
 > this one way or the other.

Actually, looking through the old kernel history, it looks like this
was added by Tim Hockin's (CCed) patch "Add Cobalt Networks support to
nvram driver".  Which added this to drivers/cobalt:

+bool 'Support for Cobalt Networks x86 servers' CONFIG_COBALT

I guess Tim can clear up what's intended...
