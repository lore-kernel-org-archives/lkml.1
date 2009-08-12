Return-Path: <linux-kernel-owner+w=401wt.eu-S1754103AbZHLQBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbZHLQBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 12:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753996AbZHLQBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 12:01:33 -0400
Received: from viefep17-int.chello.at ([62.179.121.37]:40312 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbZHLQBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 12:01:32 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 0/2] perf_counter: fix the group mess
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: eranian@gmail.com
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <7c86c4470908120854h2868695dka07ce55377bd262a@mail.gmail.com>
References: <20090812153529.716542680@chello.nl>
	 <7c86c4470908120854h2868695dka07ce55377bd262a@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 12 Aug 2009 18:01:05 +0200
Message-Id: <1250092865.10001.44.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-12 at 17:54 +0200, stephane eranian wrote:
> On Wed, Aug 12, 2009 at 5:35 PM, Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
> >
> > With these two patches the below proglet gives:
> >
> > # ./test
> > EVNT: 0xffffffff811c0f4c scale: nan ID: 37 CNT: 1006180 ID: 38 CNT: 1010230 ID: 39 CNT: 1010332 ID: 40 CNT: 1010420
> >
> > I can't seem to catch the SIGIO thing, but at least all the counters report
> 
> I think it's because you are missing this fcntl() call to get async
> notification:
> 
>        ret = fcntl(fd, F_SETFL, fcntl(fd, F_GETFL, 0) | O_ASYNC);
>         if (ret == -1)
>                 err(1, "cannot set ASYNC");

Ah, indeed, thanks!

(with a reduced work function, or increased period)

# gcc -o test test.c; ./test
signal
signal
signal
signal
signal
signal
EVNT: 0x40091c scale: nan ID: 49 CNT: 1006676 ID: 50 CNT: 1010796 ID: 51 CNT: 1010960 ID: 52 CNT: 1010937
EVNT: 0x400928 scale: 1.000000 ID: 49 CNT: 2003019 ID: 50 CNT: 2010882 ID: 51 CNT: 2011475 ID: 52 CNT: 2012032
EVNT: 0x400928 scale: 1.000000 ID: 49 CNT: 3002707 ID: 50 CNT: 3015571 ID: 51 CNT: 3016714 ID: 52 CNT: 3017830
EVNT: 0x400916 scale: 1.000000 ID: 49 CNT: 4002677 ID: 50 CNT: 4020137 ID: 51 CNT: 4021880 ID: 52 CNT: 4023639
EVNT: 0x40091c scale: 1.000000 ID: 49 CNT: 5002749 ID: 50 CNT: 5024707 ID: 51 CNT: 5027078 ID: 52 CNT: 5029378
EVNT: 0x40091c scale: 1.000000 ID: 49 CNT: 6002799 ID: 50 CNT: 6029452 ID: 51 CNT: 6032339 ID: 52 CNT: 6035277


