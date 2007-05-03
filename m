Return-Path: <linux-kernel-owner+w=401wt.eu-S1161425AbXECVZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161425AbXECVZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 17:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161485AbXECVZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 17:25:51 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:57110
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161425AbXECVZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 17:25:50 -0400
Date: Thu, 3 May 2007 14:25:02 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: David Schwartz <davids@webmaster.com>
cc: linux-kernel@vger.kernel.org
Subject: RE: scheduling oddity on 2.6.20.3 stock
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKIEJKDIAC.davids@webmaster.com>
Message-ID: <Pine.LNX.4.64.0705031424030.26172@asgard.lang.hm>
References: <MDEHLPKNGKAHNMBLJOLKIEJKDIAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2007, David Schwartz wrote:

>> I needed to recompress some files from .bz2 to .gz so I setup a script to
>> do
>>
>> bunzip2 -c $file.bz2 |gzip -9 >$file.gz
>>
>> I expected that the two CPU heavy processes would end up on different
>> cpu's and spend a little time shuffling data between the two cpu's on a
>> system (dual core opteron)
>>
>> however, instead what I find is that each process is getting 50% of one
>> cpu while the other cpu is 97% idle.
>
> That would only be possible if the compression/decompression block size is
> small compared to the maximum pipe buffer size. I suspect the reverse is the
> case.
>
> It would be interesting to write an intermediate process that basically
> enlarged the pipe buffers and see if that changed anything. Basically, the
> intermediate process would allocate a large buffer (16MB or so) and fill it
> from 'bunzip2' while draining it to 'gzip' in a non-blocking way (unless the
> buffer was full/empty, of course).

hmm, how about
bunzip2 -c $file.bz2 |dd bs=8m |gzip -9 >$file.gz
should that work?

David Lang
