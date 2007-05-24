Return-Path: <linux-kernel-owner+w=401wt.eu-S1754340AbXEXVP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbXEXVP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 17:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbXEXVPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 17:15:18 -0400
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:34060 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbXEXVPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 17:15:16 -0400
X-IronPort-AV: i="4.14,575,1170662400"; 
   d="scan'208"; a="376024274:sNHT44246458"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Collins <ben.collins@ubuntu.com>, linux-kernel@vger.kernel.org,
       Zachary Amsden <zach@vmware.com>
Subject: Re: [PATCH 4/6] RTC: Ratelimit "lost interrupts" message
X-Message-Flag: Warning: May contain useful information
References: <98cd38b5.git.bcollins@ubuntu.com>
	<e5ea703bf068a19cc9a4cc76a9b6b8990380ee75.1179964369.git.bcollins@ubuntu.com>
	<20070524134822.ed020127.akpm@linux-foundation.org>
	<1180040212.12570.279.camel@cunning>
	<20070524140956.12ff7c99.akpm@linux-foundation.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 24 May 2007 14:15:12 -0700
In-Reply-To: <20070524140956.12ff7c99.akpm@linux-foundation.org> (Andrew Morton's message of "Thu, 24 May 2007 14:09:56 -0700")
Message-ID: <adaejl56hzz.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 May 2007 21:15:14.0605 (UTC) FILETIME=[9F046DD0:01C79E48]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > I got it a lot when using any sort of virtualization on my Core2Duo
 > > (kvm, vmware, qemu). Just a big spew. Honestly, I was getting this with
 > > 2.6.20, and haven't tested again with latest kernel.
 > 
 > OK, a bit of googling finds things like this:
 > http://chxo.com/be2/20060821_3333.html, so I assume that it's some sort of
 > generic problem with the hypervisor's emulation of the RTC.

Actually I saw this "lost interrupts" spew on the host (ie the
non-virtualized kernel) running just plain qemu (no kvm or anything
scary like that).  It seemed to be some long irqs-off latency in the
tun/tap or bridging code (it went away when I stopped using "-net tap"
on the qemu command line), but I never succeeded in getting Ingo's
latency tracer to be able to track it down.

 - R.
