Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbYBEEnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbYBEEnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 23:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbYBEEnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 23:43:40 -0500
Received: from mga07.intel.com ([143.182.124.22]:63303 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752888AbYBEEnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 23:43:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,304,1199692800"; 
   d="scan'208";a="375236615"
Message-ID: <47A7E8DF.3080209@linux.intel.com>
Date: Mon, 04 Feb 2008 20:41:03 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
CC: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: issue with patch "x86: no CPA on iounmap"
References: <20080205011357.GA14712@linux-os.sc.intel.com>
In-Reply-To: <20080205011357.GA14712@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Siddha, Suresh B wrote:
> This is wrt to x86 git commit f56d005d30342a45d8af2b75ecccc82200f09600
> 	"x86: no CPA on iounmap"
> 
> This can use performance issue. When a GART driver unmaps a RAM page,
> which was mapped as UC, this commit will still retain UC attribute
> on the kernel identity mapping. This can cause mysterious performance issue
> if this freed page gets used by kernel later.
> 
> For now we should change the attribute during iounmap and in future PAT
> infrastructure will have necessary hooks to avoid the aliasing issues.
> 

this is a hard one; because the flipside is someone ioremapping the same page twice
(which is not impossible if there's 2 1k bars)... and then one of them gets iounmapped,
which would turn the page cachable again.
