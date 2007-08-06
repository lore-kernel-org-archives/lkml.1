Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbXHFFAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbXHFFAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 01:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbXHFFAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 01:00:09 -0400
Received: from mail.cs.umn.edu ([128.101.36.202]:38560 "EHLO mail.cs.umn.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871AbXHFFAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 01:00:08 -0400
X-Greylist: delayed 8880 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Aug 2007 01:00:07 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18102.43459.440189.123024@gargle.gargle.HOWL>
Date: Sun, 5 Aug 2007 23:55:31 -0500
To: Matt Mackall <mpm@selenic.com>
Cc: Dave Boutcher <boutcher@cs.umn.edu>, linux-kernel@vger.kernel.org,
       Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix /proc/pid/pagemap return length calculation
In-Reply-To: <20070806033446.GU11115@waste.org>
References: <18102.33131.876436.899189@gargle.gargle.HOWL>
	<20070806033446.GU11115@waste.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
From: boutcher@cs.umn.edu (Dave Boutcher)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Aug 2007 22:34:46 -0500, Matt Mackall <mpm@selenic.com> said:
> 
> On Sun, Aug 05, 2007 at 09:03:23PM -0500, Dave Boutcher wrote:
>> 
>> /proc/pid/pagemap has a header (usually 8 bytes) the length
>> of which needs to be compensated for when converting from
>> proc file offset to page number.  The calculation of the
>> starting page number (svpfn) compensates for this, but the
>> calculation of the ending page number (evpfn) does not, resulting
>> in reads returning 8 bytes more than were asked for and
>> nastily overwriting userspace memory.
> 
> Does this mean you're running on a 64-bit arch? I'd already fixed this
> locally, but it was off by 4 for me.
> 
> Acked-by: Matt Mackall <mpm@selenic.com>

Yeah, and there is going to be at least one more patch coming, since
with this fix, which is a righteous fix, things don't get copied up to
user space correctly since some other code was dependent on the borken 
length :-)

I like the /proc/xxx/pagemap function though...thanks for writing it.

Dave B
