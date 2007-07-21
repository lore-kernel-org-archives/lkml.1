Return-Path: <linux-kernel-owner+w=401wt.eu-S1759603AbXGUEH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759603AbXGUEH3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 00:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750768AbXGUEHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 00:07:18 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:1733 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbXGUEHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 00:07:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAMkioUarR7O6/2dsb2JhbAA
X-IronPort-AV: i="4.16,565,1175497200"; 
   d="scan'208"; a="186012469:sNHT24913188"
To: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       openib-general@openib.org, fenkes@de.ibm.com, stefan.roscher@de.ibm.com
Subject: Re: [ofa-general] [PATCH 1/5] ehca: Supports large page MRs
X-Message-Flag: Warning: May contain useful information
References: <200707201601.52277.hnguyen@linux.vnet.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 20 Jul 2007 21:07:13 -0700
In-Reply-To: <200707201601.52277.hnguyen@linux.vnet.ibm.com> (Hoang-Nam Nguyen's message of "Fri, 20 Jul 2007 16:01:51 +0200")
Message-ID: <adabqe67632.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Jul 2007 04:07:13.0798 (UTC) FILETIME=[9E59B260:01C7CB4C]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I applied this, but I agree with checkpatch.pl:

 > WARNING: externs should be avoided in .c files
 > #227: FILE: drivers/infiniband/hw/ehca/ehca_mrmw.c:67:
 > +extern int ehca_mr_largepage;
 > 
 > WARNING: externs should be avoided in .c files
 > #949: FILE: drivers/infiniband/hw/ehca/hcp_if.c:753:
 > +	extern int ehca_debug_level;

if you need to use a variable in more than one .c file, put the extern
declaration in a common header that's included everywhere you use the
variable, including the .c file that it is defined in.  That way the
compiler can see if you get confused about the type of the variable.

When you get a chance, please post a follow-on patch to fix this.

 - R.
