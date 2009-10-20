Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbZJTGdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbZJTGdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 02:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbZJTGdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 02:33:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60139 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbZJTGdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 02:33:31 -0400
Date: Tue, 20 Oct 2009 08:33:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ling Ma <linguranus@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] [X86] performance improvement for memcpy_64.S by
	avoid memory miss predication.
Message-ID: <20091020063326.GI8550@elte.hu>
References: <1255928924-19140-1-git-send-email-linguranus@gmail.com> <20091019071740.GA17407@elte.hu> <4b097b8f0910192240r254cb792gb5c3217c5bc71c8c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b097b8f0910192240r254cb792gb5c3217c5bc71c8c@mail.gmail.com>
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


* Ling Ma <linguranus@gmail.com> wrote:

> Hi Ingo
> Thanks for your suggestion. I used 'perf stat --repeat 10
> /develop/trunk/memcpy/static'  to measure before/after patch.
> 
> The test program I wrote:
>  for (i = 64; i < 4096 *4; i ++)
>       do_memcpy(src, dst, i);
> 
> when src offset is 0xbe000, dst is 0xad008, the measured result:
> 
> Before patch:
>  Performance counter stats for '/develop/trunk/memcpy/static' (10 runs):
>   <not counted>  task-clock-msecs
>   <not counted>  context-switches
>   <not counted>  CPU-migrations
>   <not counted>  page-faults
>   <not counted>  cycles
>   <not counted>  instructions
>   <not counted>  cache-references
>   <not counted>  cache-misses
>    37.408743997  seconds time elapsed   ( +-   0.222% )

hm, on what kind of CPU have you run this? Why are those events not 
counting? Is it some older, Pentium-4 alike CPU perhaps?

	Ingo
