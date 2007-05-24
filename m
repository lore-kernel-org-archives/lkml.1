Return-Path: <linux-kernel-owner+w=401wt.eu-S1750880AbXEXNns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750880AbXEXNns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 09:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750705AbXEXNnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 09:43:41 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:1625 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbXEXNnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 09:43:40 -0400
X-IronPort-AV: i="4.14,573,1170662400"; 
   d="scan'208"; a="2385000:sNHT721246884"
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       shaohua.li@intel.com, lhcs-devel@lists.sourceforge.net
Subject: Re: [PATCH 4/7] SMP: Implement on_one_cpu()
X-Message-Flag: Warning: May contain useful information
References: <1180008615579-git-send-email-avi@qumranet.com>
	<11800086152009-git-send-email-avi@qumranet.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 24 May 2007 06:43:32 -0700
In-Reply-To: <11800086152009-git-send-email-avi@qumranet.com> (Avi Kivity's message of "Thu, 24 May 2007 15:10:12 +0300")
Message-ID: <adaejl68hh7.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 May 2007 13:43:32.0746 (UTC) FILETIME=[850CEEA0:01C79E09]
Authentication-Results: sj-dkim-7; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim7002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I don't see any documented restrictions about preemption being
disabled when this function is called, but...

 > +int on_one_cpu(int cpu, void (*func) (void *info), void *info,
 > +	       int retry, int wait)
 > +{
 > +	int ret;
 > +	int this_cpu;
 > +
 > +	this_cpu = get_cpu();

what if a preempt and reschedule to a different CPU happens right
here, after this_cpu is set?

 > +	if (this_cpu == cpu) {
