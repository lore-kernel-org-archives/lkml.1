Return-Path: <linux-kernel-owner+w=401wt.eu-S1759587AbYBARCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587AbYBARCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 12:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756710AbYBARCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 12:02:10 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:15043 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755717AbYBARCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 12:02:08 -0500
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Are Section mismatches out of control?
X-Message-Flag: Warning: May contain useful information
References: <20080201104718.GA11717@uranus.ravnborg.org>
	<20080201030329.9b760777.akpm@linux-foundation.org>
	<1201864894.23523.117.camel@brick>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 01 Feb 2008 09:02:00 -0800
In-Reply-To: <1201864894.23523.117.camel@brick> (Harvey Harrison's message of "Fri, 01 Feb 2008 03:21:34 -0800")
Message-ID: <adak5lo7gqf.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 01 Feb 2008 17:02:01.0051 (UTC) FILETIME=[2976D2B0:01C864F4]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Subject to someone _making_ it an issue, can't see it changing.

Actually I think that Sam's recent improvements to the section
mismatch detection should make it easy to get at least all of the
driver issues fixed -- the problem in the past was that many warnings
would only show with certain configs or certain compilers (inlining
functions only called once would hide many warnings).

Now I just need to enable CONFIG_DEBUG_SECTION_MISMATCH and I'm pretty
certain to see everything (and indeed this found a few warnings in
drivers/infiniband hidden by inlining, which I've queued up a fix for).

So the __cpuinit stuff may be trickier and half false positives etc,
but I'm confident drivers/ will be cleaned up quickly now thanks to Sam.
