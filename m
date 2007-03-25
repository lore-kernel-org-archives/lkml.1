Return-Path: <linux-kernel-owner+w=401wt.eu-S1751948AbXCYRCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbXCYRCF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 13:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbXCYRCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 13:02:05 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:15392 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbXCYRCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 13:02:04 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Early hang with 2.6.21-rc4-rt1
X-Message-Flag: Warning: May contain useful information
References: <adad52xnccs.fsf@cisco.com> <20070325073146.GB10734@elte.hu>
	<ada4po9mlw5.fsf@cisco.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Sun, 25 Mar 2007 10:01:58 -0700
In-Reply-To: <ada4po9mlw5.fsf@cisco.com> (Roland Dreier's message of "Sun, 25 Mar 2007 07:35:22 -0700")
Message-ID: <adavegpl0jd.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Mar 2007 17:01:58.0790 (UTC) FILETIME=[4CD21260:01C76EFF]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > I finally got curious enough to want to debug why starting kvm with
 > tun/tap networking produces a bunch of
 > 
 >     rtc: lost some interrupts at 1024Hz.
 > 
 > messages.  So I'm assuming it's a ~millisecond irqs-off section
 > somewhere.

And after everything, it's a heisenbug -- I repeatably get that lost
interrupts message on stock 2.6.21-rc4 but never on -rt1 with
CONFIG_LATENCY_TRACE.

Any suggestion of where to look?  My /proc/latency_trace stays
stubbornly empty -- are there any sysctls I need to change from their
default to get latency tracing?  I'm a complete noob when it comes to
the -rt patch, so I'm not sure what the right way to use the tracing
infrastructure to track down this lost rtc interrupts issue is.

Thanks, 
  Roland
