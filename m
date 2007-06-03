Return-Path: <linux-kernel-owner+w=401wt.eu-S1752132AbXFCVwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbXFCVwT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 17:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbXFCVwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 17:52:09 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:59735 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbXFCVwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 17:52:08 -0400
X-Originating-Ip: 72.143.65.211
Date: Sun, 3 Jun 2007 17:50:26 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Tim Hockin <thockin@google.com>
cc: Roland Dreier <rdreier@cisco.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Kconfig variable "COBALT" is not defined anywhere
In-Reply-To: <cc96a5040706031438o667e4df0wb18bdd071f48e246@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706031747190.23873@localhost.localdomain>
References: <Pine.LNX.4.64.0706031315230.23477@localhost.localdomain> 
 <20070603132309.508738b7.randy.dunlap@oracle.com> 
 <Pine.LNX.4.64.0706031630030.26035@localhost.localdomain>  <adazm3glqcr.fsf@cisco.com>
  <cc96a5040706031408i54116922m7a83c7e0b07181e6@mail.gmail.com> 
 <Pine.LNX.4.64.0706031714070.19004@localhost.localdomain>
 <cc96a5040706031438o667e4df0wb18bdd071f48e246@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jun 2007, Tim Hockin wrote:

> I think the nvram is the only place left that uses CONFIG_COBALT

sure, but once you remove this snippet near the top of
drivers/char/nvram.c:

...
#  if defined(CONFIG_COBALT)
#    include <linux/cobalt-nvram.h>
#    define MACH COBALT
#  else
#    define MACH PC
#  endif
...

then everything else COBALT-related in that file should be tossed as
well, which would include stuff conditional on:

  #if MACH == COBALT

and so on.  just making sure that what you're saying is that *all*
COBALT-related content in that file can be thrown out.  i'll submit a
patch shortly and you can pass judgment.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
