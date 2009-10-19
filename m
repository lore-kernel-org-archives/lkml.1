Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbZJSHRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbZJSHRq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 03:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbZJSHRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 03:17:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57235 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354AbZJSHRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 03:17:45 -0400
Date: Mon, 19 Oct 2009 09:17:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linguranus@gmail.com, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] [X86] performance improvement for memcpy_64.S by
	avoid memory miss predication.
Message-ID: <20091019071740.GA17407@elte.hu>
References: <1255928924-19140-1-git-send-email-linguranus@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255928924-19140-1-git-send-email-linguranus@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* linguranus@gmail.com <linguranus@gmail.com> wrote:

> From: Ling <linguranus@gmail.com>
> 
> Hi All
> 
> CPU will use memory disambiguration predication to speculatively read 
> memory without waiting for previous write instructions and correctly 
> avoid conflict between them (RAW). However it seem only to care about 
> last 12 bits of address, not care about real address. For example if 
> rsi is 0xf004, rdi is 0xe008, when we do following operation there 
> will generate big performance latency.

Would be nice to trigger this kind of pattern via some testcase that 
uses read() or write() - or some other real workload.

Then you can use 'perf stat --repeat 10 ./my-test-prog' to measure it 
and post the results - the before-patch/after-patch instruction count, 
cycle count, etc.

You can get 'perf' via:

  cd tools/perf
  make -j install

(And please preserve the Cc: line for new postings - thanks.)

Thanks,

	Ingo
