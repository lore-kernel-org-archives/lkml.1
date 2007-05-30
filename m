Return-Path: <linux-kernel-owner+w=401wt.eu-S1757143AbXE3Pa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143AbXE3Pa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 11:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755780AbXE3PaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 11:30:07 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:45899 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbXE3PaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 11:30:03 -0400
X-IronPort-AV: i="4.14,594,1170662400"; 
   d="scan'208"; a="489341349:sNHT46177208"
To: openib-general@openib.org
Cc: linux-kernel@vger.kernel.org
Subject: dealing with gcc 'comparison is always false' warnings (was: [PATCH] drivers/infiniband: fix comparsion between unsigned and negative)
X-Message-Flag: Warning: May contain useful information
References: <20070530080518.GA29195@nostromo.devel.redhat.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 30 May 2007 08:30:00 -0700
In-Reply-To: <20070530080518.GA29195@nostromo.devel.redhat.com> (Bill Nottingham's message of "Wed, 30 May 2007 04:05:18 -0400")
Message-ID: <adazm3mqqh3.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 May 2007 15:30:01.0247 (UTC) FILETIME=[635F52F0:01C7A2CF]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

thanks... I'm wondering if there's a consensus among kernel hackers
about changes like:

 > -	if (hdr.cmd < 0 || hdr.cmd >= ARRAY_SIZE(ucma_cmd_table))
 > +	if (hdr.cmd >= ARRAY_SIZE(ucma_cmd_table))
 >  		return -EINVAL;

I understand that new gcc sees that hdr.cmd is unsigned and hence
can't be < 0, and generates a warning for that, and having a build
cluttered with warnings hides bugs and so on.  However the code here
looks quite sensible to me -- otherwise we end up with missing range
checking if hdr.cmd ever changes to a signed type.  This seems like a
good way to introduce bugs: delete valid range checking code to shut
up a silly gcc warning, and then change the type of a variable.

Can't we just make gcc shut up about the comparison and generate no
code for it because it knows it can't be true?

 - R.
