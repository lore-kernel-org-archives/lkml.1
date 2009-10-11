Return-Path: <linux-kernel-owner+w=401wt.eu-S1760715AbZJKMUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760715AbZJKMUK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 08:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbZJKMUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 08:20:08 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:35664 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbZJKMUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 08:20:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mctv0Ygee4UERGcwp8DS8OCQbb8mz3BMN5Qxh9Ob4lKl2pygNQSKF+VETjhJrF1qZ4
         r7Ap0p74j1enzjTO9AOe7XO1w5CgQVVUPRxUuos5bgMksA4g2z2Itx8pHNM3eslZHmiS
         JcKP1CsnX6kETc9vnjmAzvnISsWaBUWRZntO4=
Date: Sun, 11 Oct 2009 14:19:28 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: perf trace errors
Message-ID: <20091011121926.GD4901@nowhere>
References: <20091011025441.GA18152@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091011025441.GA18152@lst.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 11, 2009 at 04:54:41AM +0200, Christoph Hellwig wrote:
> I get some rather interesting errors using perf trace with the block
> tracepoints on current mainline, e.g.:
> 
> perf record -f -e 'block:block_bio_queue:record' -R -F 1 -a -s
> <do some disk I/O end then ctrl+c>
> ^C[ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.237 MB perf.data (~10362 samples) ]
> 
> brick:/home/hch# perf trace
>   Fatal: unknown op '-'
>           xfssyncd-4232  [000]    87.798249255: block_bio_queue: 253,
> 
> There are lots of occurances of that exactly same warning in
> builtin-trace.c, and the code sourrouning them is sufficiently enough
> convoluted that I'm not able to track it down.


Yeah, there are still some trace events that are not well supported
in perf trace, for now... I'll fix that by the time.

Thanks.

