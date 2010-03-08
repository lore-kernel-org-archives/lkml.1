Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab0CHN2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 08:28:23 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:33072 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab0CHN2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 08:28:19 -0500
X-Greylist: delayed 1141 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Mar 2010 08:28:19 EST
Date: Mon, 8 Mar 2010 08:07:39 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: still worth running kernel cleanup scripts after merge windows?
Message-ID: <alpine.LFD.2.00.1003080801560.3620@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  just curious if there's still value in running my kernel scanning
scripts after each merge window closes and posting results.  there's
still a fair bit of inconsistency and mismatches in the Kconfig files.

  as a single example, here's a snippet from the
drivers/message/fusion directory, identifying an apparently bad
reference to a non-existent CONFIG variable:

>>>>> FUSION_MAX_FC_SGE
drivers/message/fusion/mptbase.h:179:#ifdef CONFIG_FUSION_MAX_FC_SGE
drivers/message/fusion/mptbase.h:180:#if CONFIG_FUSION_MAX_FC_SGE  < 16
drivers/message/fusion/mptbase.h:182:#elif CONFIG_FUSION_MAX_FC_SGE  > 256
drivers/message/fusion/mptbase.h:185:#define MPT_SCSI_FC_SG_DEPTH  CONFIG_FUSION_MAX_FC_SGE

  but there is no such Kconfig variable FUSION_MAX_FC_SGE.  however:

$ grep -r FUSION_MAX drivers/message/fusion
drivers/message/fusion/Kconfig:config FUSION_MAX_SGE
drivers/message/fusion/mptbase.h:#ifdef CONFIG_FUSION_MAX_SGE
drivers/message/fusion/mptbase.h:#if CONFIG_FUSION_MAX_SGE  < 16
drivers/message/fusion/mptbase.h:#elif CONFIG_FUSION_MAX_SGE  > 128
drivers/message/fusion/mptbase.h:#define MPT_SCSI_SG_DEPTH	CONFIG_FUSION_MAX_SGE
drivers/message/fusion/mptbase.h:#ifdef CONFIG_FUSION_MAX_FC_SGE
drivers/message/fusion/mptbase.h:#if CONFIG_FUSION_MAX_FC_SGE  < 16
drivers/message/fusion/mptbase.h:#elif CONFIG_FUSION_MAX_FC_SGE  > 256
drivers/message/fusion/mptbase.h:#define MPT_SCSI_FC_SG_DEPTH	CONFIG_FUSION_MAX_FC_SGE
$

  so is that a typo?  should "FUSION_MAX_FC_SGE" really be just
"FUSION_MAX_SGE"?  anyway, you get the idea.  or maybe i should just
put the scripts up at my wiki and people can run their at their
leisure on whatever part of the source tree interests them.

rday
--


========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
