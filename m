Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbYGLKeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbYGLKeO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 06:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbYGLKd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 06:33:58 -0400
Received: from gv-out-0910.google.com ([216.239.58.187]:13699 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbYGLKd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 06:33:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=leTSC2IeyzcWXCiJFGIbKyQqYfbfi85ecbTajdTM2CYjDe+yqgS6fzvdIdtRacR2E2
         b7Kyj/i5H2xBVjL4A3eqtfQmGjv3JIZCIokBOGeFcXOAkBF0iyZBf1NG+4CjuAukJQM4
         GNJzaRVWzxy1SNZ6jSto/3mYlKIAPn+QNJ6Uc=
Message-ID: <48788891.5070905@gmail.com>
Date: Sat, 12 Jul 2008 13:33:53 +0300
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Elias Oltmanns <eo@nebensachen.de>
Subject: Re: [PATCH] x86_64: fix delayed signals
References: <20080710215039.2A143154218@magilla.localdomain>	<20080711054605.GA17851@elte.hu>	<alpine.LFD.1.10.0807111031310.2936@woody.linux-foundation.org>	<alpine.LFD.1.10.0807111102450.2936@woody.linux-foundation.org>	<alpine.LFD.1.10.0807111120470.2936@woody.linux-foundation.org> <20080711155306.3153e0a1@infradead.org>
In-Reply-To: <20080711155306.3153e0a1@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-07-12 01:53, Arjan van de Ven wrote:
> On Fri, 11 Jul 2008 11:31:26 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>   
>> On Fri, 11 Jul 2008, Linus Torvalds wrote:
>>     
>>> Btw, did any of the impacted people test -rc9? Edwin's report is
>>> about -rc2 and -rc8, and one of the things we fixed since -rc8 is
>>> that incorrect and unintentional nr_zones zeroing that effectively
>>> disabled kswapd - and made everybody do synchronous memory freeing
>>> when they wanted to allocate more memory.. That can play havoc with
>>> any interactive stuff.
>>>       
>> Hmm. Edwin's latencytop output includes this (ignoring the _very_ top 
>> entries that are all either CD-ROM media change tests or are
>> interruptible pipe/select things) at the top:
>>
>> 	21 10264428 915514 get_request_wait __make_request
>> generic_make_request submit_bio xfs_submit_ioend_bio xfs_submit_ioend 
>> 		xfs_page_state_convert xfs_vm_writepage __writepage 
>> 		write_cache_pages generic_writepages xfs_vm_writepages
>>     
>
>
> argh. well I guess this might be useful for this case, but normally
> latencytop gives you much more humanly readable data... maybe Edwin
> forgot to do "make install" :-(

I forgot to use 'latencytop -d', I was running latencytop and when I've
seen something interesting I did a 'cat /proc/latency_stats' instead of
'latencytop -d'.
I'll try to use latencytop -d next time.

Best regards,
--Edwin
