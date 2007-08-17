Return-Path: <linux-kernel-owner+w=401wt.eu-S1760648AbXHQGrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760648AbXHQGrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 02:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbXHQGrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 02:47:33 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:54644 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751808AbXHQGrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 02:47:32 -0400
Message-ID: <387333248.08272@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Fri, 17 Aug 2007 14:47:27 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@osdl.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       John Berthels <jjberthels@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] maps: /proc/<pid>/pmaps interface - memory maps in
	granularity of pages
Message-ID: <20070817064727.GA6723@mail.ustc.edu.cn>
References: <20070816220516.782145952@mail.ustc.edu.cn> <20070816220849.472883642@mail.ustc.edu.cn> <20070817023846.GJ30556@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070817023846.GJ30556@waste.org>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt,

It's not easy to do direct performance comparisons between pmaps and
pagemap/kpagemap. However some close analyzes are still possible :)

1) code size
pmaps                   ~200 LOC
pagemap/kpagemap        ~300 LOC

2) dataset size
take for example my running firefox on Intel Core 2:
VSZ             400 MB
RSS              64 MB, or 16k pages
pmaps            64 KB, wc shows 2k lines, or so much page ranges
pagemap         800 KB, could be heavily optimized by returning partial data
kpagemap        256 KB

3) runtime overheads
pmaps            2k lines of string processing(encode/decode)
kpagemap        16k seek()/read()s, and context switches (could be
                    optimized somehow by doing a PFN sort first, but
                    that's also non-trivial overheads)

So pmaps seems to be a clear winner :)

Thank you,
Fengguang

