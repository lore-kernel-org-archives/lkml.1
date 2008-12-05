Return-Path: <linux-kernel-owner+w=401wt.eu-S1754183AbYLEGu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbYLEGu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 01:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751182AbYLEGuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 01:50:13 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:33609 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbYLEGuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 01:50:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=BajaQJ9eq5mE3js4NhETK/mCggLHcYLd0Lt64b+8WPIWpdBTiFvSCtnfvcXVe9hua0
         22FlkNQ3MQiB/Jf0KNcpjLOGmuBYSwnfQ2ieBClIhfVQTX/yes2hzRPPPHSUi1ioYlg7
         N3kDwbcZS1J9IIKyGf+Be0rG9p9oRl/5EqToE=
Message-ID: <4938CF1C.9020503@gmail.com>
Date: Fri, 05 Dec 2008 08:50:04 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Ying Han <yinghan@google.com>
CC: Nick Piggin <npiggin@suse.de>, Mike Waychison <mikew@google.com>,
       Ingo Molnar <mingo@elte.hu>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rohit Seth <rohitseth@google.com>,
       Hugh Dickins <hugh@veritas.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC v1][PATCH]page_fault retry with NOPAGE_RETRY
References: <604427e00811212247k1fe6b63u9efe8cfe37bddfb5@mail.gmail.com>	 <20081126123246.GB23649@wotan.suse.de> <492DAA24.8040100@google.com>	 <20081127085554.GD28285@wotan.suse.de> <492E6849.6090205@google.com>	 <492E8708.4060601@gmail.com> <20081127120330.GM28285@wotan.suse.de>	 <492E90BC.1090208@gmail.com> <20081127123926.GN28285@wotan.suse.de>	 <492E97FA.5000804@gmail.com> <604427e00812041427j7f1c8118p48b1b5b577143703@mail.gmail.com>
In-Reply-To: <604427e00812041427j7f1c8118p48b1b5b577143703@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-12-05 00:27, Ying Han wrote:
> I am trying your test program(scalability) in house, but somehow i got
> different result as you saw. i created 8 files each with 1G size on
> separate drives( to avoid the latency disturbing of disk seek). I got
> this number without applying the batch based on 2.6.26. May i ask how
> to reproduce the mmap issue you mentioned?
>   

Hi,

Try using more files, and of smaller size.  I was using /usr/bin, which
has 3632 files, and 571M total.
I am using XFS filesystem: /dev/mapper/vg--all-lv--usr on /usr type xfs
(rw,noatime,logbsize=262144,logbufs=8,logdev=/dev/sdg6,inode64)


> 8 CPU
> read_worker
> 1 threads Real time: 101.058262 s (since task start)
> 2 threads Real time: 50.670456 s (since task start)
> 4 threads Real time: 25.904657 s (since task start)
> 8 threads Real time: 20.090677 s (since task start)
> --------------------------------------------------------------------------------
> mmap_worker
> 1 threads Real time: 101.340662 s (since task start)
> 2 threads Real time: 51.484646 s (since task start)
> 4 threads Real time: 28.414534 s (since task start)
> 8 threads Real time: 21.785818 s (since task start)
>   


Try 16 threads, so that there is more contention on the read side as well.

Best regards,
--Edwin
