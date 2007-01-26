Return-Path: <linux-kernel-owner+w=401wt.eu-S1030861AbXAZRF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030861AbXAZRF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 12:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030873AbXAZRF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 12:05:58 -0500
Received: from iriserv.iradimed.com ([69.44.168.233]:27788 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030878AbXAZRF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 12:05:57 -0500
Message-ID: <45BA34EE.4050402@cfl.rr.com>
Date: Fri, 26 Jan 2007 12:05:50 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Denis Vlasenko <vda.linux@googlemail.com>
CC: Michael Tokarev <mjt@tls.msk.ru>, Linus Torvalds <torvalds@osdl.org>,
       Viktor <vvp01@inbox.ru>, Aubrey <aubreylee@gmail.com>,
       Hua Zhong <hzhong@gmail.com>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org, hch@infradead.org, kenneth.w.chen@in
Subject: Re: O_DIRECT question
References: <6d6a94c50701101857v2af1e097xde69e592135e54ae@mail.gmail.com> <45B90D19.60106@cfl.rr.com> <45B916F2.4070906@tls.msk.ru> <200701252211.39017.vda.linux@googlemail.com>
In-Reply-To: <200701252211.39017.vda.linux@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jan 2007 17:06:07.0435 (UTC) FILETIME=[4510C9B0:01C7416C]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-14958.003
X-TM-AS-Result: No--3.775500-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Denis Vlasenko wrote:
> Which shouldn't be true. There is no fundamental reason why
> ordinary writes should be slower than O_DIRECT.

Again, there IS a reason:  O_DIRECT eliminates the cpu overhead of the 
kernel-user copy, and when coupled with multithreading or aio, allows 
the IO queues to be kept full with useful transfers at all times. 
Normal read/write requires the kernel to buffer and guess access 
patterns correctly to perform read ahead and write behind perfectly to 
keep the queues full.  In practice, this does not happen perfectly all 
of the time, or even most of the time, so it slows things down.


