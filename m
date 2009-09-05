Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528AbZIEWku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbZIEWku (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 18:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbZIEWks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 18:40:48 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:60872 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbZIEWkr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 18:40:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=PIbXrtw5kF/9H+Z3DfBdNaIE/h2SbL6/DBKtP8EqYTGODNMr5uaYY3J2YnhTEzjPLb
         rou8rdnyJdab3Iw7ANGMRcqgjlzdGWCfbOf+gJ1ERmJV7yAnO5abw8edAKPAS1ID2N4A
         AQfEOB5hjy6m2273iv2mWNPiD9jevWLqe92Oc=
MIME-Version: 1.0
In-Reply-To: <20090905204037.GE4953@gandalf.sssup.it>
References: <DDFD17CC94A9BD49A82147DDF7D545C501F0F575@exchange.ZeugmaSystems.local> 
	<20090905204037.GE4953@gandalf.sssup.it>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Sun, 6 Sep 2009 00:40:29 +0200
Message-ID: <193b0f820909051540v1ad63c24xc822dbdef5bd0c1c@mail.gmail.com>
Subject: Re: question on sched-rt group allocation cap: sched_rt_runtime_us
To: Fabio Checconi <fchecconi@gmail.com>
Cc: Anirban Sinha <ASinha@zeugmasystems.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You say you pin the threads to a single core: how many cores does your
> system have?
>
> If this is the case, this behavior is the expected one, the scheduler
> tries to reduce the number of migrations, concentrating the bandwidth
> of rt tasks on a single core.  With your workload it doesn't work well
> because runtime migration has freed the other core(s) from rt bandwidth,
> so these cores are available to SCHED_OTHER ones, but your SCHED_OTHER
> thread is pinned and cannot make use of them.

Indeed. I've tested this same test program in a single core machine and it
produces the expected behavior:

rt_runtime_us / rt_period_us     % loops executed in SCHED_OTHER
95%                              4.48%
60%                              54.84%
50%                              86.03%
40%                              OTHER completed first


Lucas De Marchi
