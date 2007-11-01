Return-Path: <linux-kernel-owner+w=401wt.eu-S1757163AbXKAB4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163AbXKAB4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 21:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871AbXKAB41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 21:56:27 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:15350 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbXKAB40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 21:56:26 -0400
X-IronPort-AV: E=Sophos;i="4.21,354,1188802800"; 
   d="scan'208";a="541972397"
Message-ID: <47293248.9000906@cisco.com>
Date: Wed, 31 Oct 2007 18:56:24 -0700
From: "bc Wong (chimwong)" <bcwong@cisco.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: filp usage when cpu busy
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Nov 2007 01:56:25.0199 (UTC) FILETIME=[68C4C7F0:01C81C2A]
Authentication-Results: sj-dkim-2; header.From=bcwong@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With 2.6.16 x86_64 on a 4 core machine, I noticed
that the filp usage (according to /proc/slabinfo)
shoots up and keeps on increasing sharply when one
of the CPUs is (1) locked up, or (2) very busy
doing a lot of printk()'s with KERN_EMERG.

In the case of (1), it's permanent until it runs
out of memory eventually. For (2), it's temporary;
filp count comes back down when the printk()'s are
done.

I can't think of any relationship between a busy/
locked-up CPU and filp count. The system is still
functional. New short-lived processes kept being
created, but the overall number of processes is
stable.

Does anyone know why filp count would go up like
that?

Thanks,
bc
