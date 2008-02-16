Return-Path: <linux-kernel-owner+w=401wt.eu-S1753251AbYBPIrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbYBPIrT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 03:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbYBPIrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 03:47:04 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:47992
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbYBPIrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 03:47:01 -0500
Message-ID: <47B6A2BE.6080201@qumranet.com>
Date: Sat, 16 Feb 2008 10:45:50 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Lameter <clameter@sgi.com>,
       Andrea Arcangeli <andrea@qumranet.com>, Robin Holt <holt@sgi.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 1/6] mmu_notifier: Core code
References: <20080215064859.384203497@sgi.com>	<20080215064932.371510599@sgi.com> <20080215193719.262c03a1.akpm@linux-foundation.org>
In-Reply-To: <20080215193719.262c03a1.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> How important is this feature to KVM?
>   

Very.  kvm pins pages that are referenced by the guest; a 64-bit guest 
will easily pin its entire memory with the kernel map.  So this is 
critical for guest swapping to actually work.

Other nice features like page migration are also enabled by this patch.

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

