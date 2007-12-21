Return-Path: <linux-kernel-owner+w=401wt.eu-S1759593AbXLUXkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593AbXLUXkt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 18:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbXLUXkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 18:40:40 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:64823 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624AbXLUXki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 18:40:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=wWetHYVbk4DBntq5/cyPBCPfZ+SS46zMCEIzArrNXrkGQKEGrVGrHaq7S7BHlVj7vUfARuZACDPNoRz1kmAoagyPWIi3WU5olo+1TKMTL1tCGY/uUm8c7Y0byLhJ4Qbro7NVvsy4L2G5x1vwjLI/RjTTyfObUix/kYodccpJogI=
Message-ID: <84144f020712211540i33cbd11ke9fcd842980e5689@mail.gmail.com>
Date: Sat, 22 Dec 2007 01:40:37 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20071221231728.GA28008@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1197049846.1645.68.camel@localhost.localdomain>
	 <20071211143336.GA17866@elte.hu>
	 <Pine.LNX.4.64.0712131416280.25120@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0712132010470.30903@schroedinger.engr.sgi.com>
	 <20071221120908.GA15926@elte.hu>
	 <84144f020712210944q3e0539f8vd8a249f69d456dc7@mail.gmail.com>
	 <Pine.LNX.4.64.0712211412040.3795@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0712211435250.3795@schroedinger.engr.sgi.com>
	 <alpine.LFD.0.9999.0712211449320.21557@woody.linux-foundation.org>
	 <20071221231728.GA28008@elte.hu>
X-Google-Sender-Auth: 5971ee2fbb867dc4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Dec 22, 2007 1:17 AM, Ingo Molnar <mingo@elte.hu> wrote:
> yep, and i ran a quick comparison test on a 2-core box with 3 kernels:
>
>   [ best of 5 runs in a row which had a relative jitter of less than 10% ]
>
>      MIN      v2.6.24.slab     v2.6.24.slub v2.6.24.slub.fix
>   ----------------------------------------------------------
>            mmap:    429.00    402.00 ( -6%)    385.00 (-10%)
>          select:     11.38     10.46 ( -8%)     11.41 (  0%)
>       proc-exec:    121.52    116.77 ( -3%)    120.77 (  0%)
>       proc-fork:    106.84    106.19 (  0%)    107.92 (  1%)
>    syscall-open:      3.09      3.13 (  1%)      3.25 (  4%)
>    hackbench-50:      2.85      3.47 ( 21%)      2.88 (  1%)
>
> and the regression seems to be largely fixed! Not only is the hackbench
> one fixed, but mmap shows an above-noise improvement as well.
>
> Acked-by: Ingo Molnar <mingo@elte.hu>

I thought it might be a bug but couldn't figure it out. The patch
looks good to me too, Christoph.

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>

On Dec 22, 2007 1:17 AM, Ingo Molnar <mingo@elte.hu> wrote:
> And i hereby nominate Pekka as SLUB/SLAB co-maintainer and spokesperson
> ;-)

Heh, thanks, but grep me from MAINTAINERS some day, Ingo :-).

                                Pekka
