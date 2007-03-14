Return-Path: <linux-kernel-owner+w=401wt.eu-S1750829AbXCNAgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750829AbXCNAgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 20:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbXCNAgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 20:36:38 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:53803 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbXCNAgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 20:36:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iwBZAXOZy8xOLxs/HEIzdnov+t93XgyDskTAIgLjJjzSvyondwaSyX5ClVN4ouI99zcr64Dp06ZjSLqCOWDuIdKZSWku8EL6UPhx4JJav5Ablg9g5EvTyVUUpwqSacL2FioAv3YM5Hizbn5fn1iX7Du2gMrOyyGxYU5rpeM3lHA=
Message-ID: <29495f1d0703131736l74a63c15n94f03527d7e63500@mail.gmail.com>
Date: Tue, 13 Mar 2007 17:36:36 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Anton Blanchard" <anton@samba.org>
Subject: Re: SMP performance degradation with sysbench
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>, "Rik van Riel" <riel@redhat.com>,
       "Lorenzo Allegrucci" <l_allegrucci@yahoo.it>,
       linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Jens Axboe" <jens.axboe@oracle.com>
In-Reply-To: <20070312220042.GA807@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1172425476.5489.11.camel@odyssey.lan>
	 <45E21FEC.9060605@redhat.com> <45E2E244.8040009@yahoo.com.au>
	 <20070312220042.GA807@kryten>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/07, Anton Blanchard <anton@samba.org> wrote:
>
> Hi Nick,
>
> > Anyway, I'll keep experimenting. If anyone from MySQL wants to help look
> > at this, send me a mail (eg. especially with the sched_setscheduler issue,
> > you might be able to do something better).
>
> I took a look at this today and figured Id document it:
>
> http://ozlabs.org/~anton/linux/sysbench/
>
> Bottom line: it looks like issues in the glibc malloc library, replacing
> it with the google malloc library fixes the negative scaling:
>
> # apt-get install libgoogle-perftools0
> # LD_PRELOAD=/usr/lib/libtcmalloc.so /usr/sbin/mysqld

Quick datapoint, still collecting data and trying to verify it's
always the case: on my 8-way Xeon, I'm actually seeing *much* worse
performance with libtcmalloc.so compared to mainline. Am generating
graphs and such still, but maybe someone else with x86_64 hardware
could try the google PRELOAD and see if it helps/hurts (to rule out
tester stupidity)?

Thanks,
Nish
