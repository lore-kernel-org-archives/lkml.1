Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbZJVNJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbZJVNJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 09:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755710AbZJVNJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 09:09:46 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:64608 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755078AbZJVNJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 09:09:45 -0400
Subject: Re: Leaks in trace reported by kmemleak
From: Catalin Marinas <catalin.marinas@arm.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <c4e36d110910200258q7c1d6b4uf74b6d365ffb3f40@mail.gmail.com>
References: <c4e36d110910150159j6092d0d1lb20434bd9d43d8ce@mail.gmail.com>
	 <1255690674.3008.24.camel@pc1117.cambridge.arm.com>
	 <c4e36d110910160632y4448475dp1ae66dfc01ff8448@mail.gmail.com>
	 <tnxbpk7a0ok.fsf@pc1117.cambridge.arm.com>
	 <c4e36d110910160728n5ceefaa8u6b9989aec0564628@mail.gmail.com>
	 <c4e36d110910160807i2298dacp7d37289ca3ad25f@mail.gmail.com>
	 <1255711285.3008.59.camel@pc1117.cambridge.arm.com>
	 <c4e36d110910190215j129e61ey5e20634a4bc19292@mail.gmail.com>
	 <1255953605.31096.26.camel@pc1117.cambridge.arm.com>
	 <1255958422.31096.33.camel@pc1117.cambridge.arm.com>
	 <c4e36d110910200258q7c1d6b4uf74b6d365ffb3f40@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 22 Oct 2009 14:09:28 +0100
Message-Id: <1256216968.8608.21.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Oct 2009 13:09:29.0643 (UTC) FILETIME=[E39BA7B0:01CA5318]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zdenek,

On Tue, 2009-10-20 at 11:58 +0200, Zdenek Kabelac wrote:
> I've tested your git with updates - and here is my experience:
> 
> I'm still able to get FP leaks printed even with the print of
> more-then-once appearanc.

I updated the kmemleak.git tree and in my tests it reduced the false
positives significantly. I dropped the two-pass scanning patch and I
added a new one which checks whether objects were modified since the
previous leak suspicion and only report them if unmodified (using
csum_partial for checksum calculation). This works well with linked
lists since list deletion modifies the prev/next pointers of those left
in the list (like in the debug_objects case).

> Also jiffies might be eventually more readable via data/time - but
> this can be preprocessed via script.

Jiffies is still useful to ensure it's the same object or a new one
allocated in the same function (and possibly false positive). I added
another bit of information - the age of an object in seconds.msecs.

-- 
Catalin

