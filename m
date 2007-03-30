Return-Path: <linux-kernel-owner+w=401wt.eu-S1752250AbXC3Eou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250AbXC3Eou (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 00:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbXC3Eou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 00:44:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:61722 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbXC3Eot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 00:44:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=tI8Ehq0Ib9yN5tvFSv+KwDfnJEhIRJKAxwud5ad8Ksyh9n7vYokt1kkg07ZL6b22gT3Qt32jlms9gNkRRjM9euS9EUxVAlMkRuHOh+U3U28vU8U+SdkgofWZtCR1xror5NnpLcFGuoqoju7cuXAuomJjJBwBJ5xuBRqpjWf49sA=
Message-ID: <75b66ecd0703292144x2dd9df30y3c316d54d2e5f7d@mail.gmail.com>
Date: Fri, 30 Mar 2007 00:44:44 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Nick Piggin" <npiggin@suse.de>
Subject: Re: [patch] queued spinlocks (i386)
Cc: "Davide Libenzi" <davidel@xmailserver.org>,
       "Oleg Nesterov" <oleg@tv-sign.ru>,
       "Ravikiran G Thirumalai" <kiran@scalex86.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Nikita Danilov" <nikita@clusterfs.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Eric Dumazet" <dada1@cosmosbay.com>
In-Reply-To: <20070330021717.GF19407@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070325155407.GA497@tv-sign.ru>
	 <20070328070459.GC12508@wotan.suse.de>
	 <20070329184213.GA83@tv-sign.ru>
	 <Pine.LNX.4.64.0703291215440.1199@alien.or.mcafeemobile.com>
	 <75b66ecd0703291906q265f9cc7g486cf65484ba8393@mail.gmail.com>
	 <20070330021717.GF19407@wotan.suse.de>
X-Google-Sender-Auth: 56396bdda3feba5c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/29/07, Nick Piggin <npiggin@suse.de> wrote:
> On Thu, Mar 29, 2007 at 10:06:41PM -0400, Lee Revell wrote:
> > Until someone fixes all the places in the kernel where scheduling can
> > be held off for tens of milliseconds, CONFIG_PREEMPT will be an
> > absolute requirement for many applications like audio and gaming.
>
> There's nothing wrong with CONFIG_PREEMPT for those users. We have
> a few other performance concessions activated with CONFIG_PREEMPT on.
> I think a usual upper of a few miliseconds (especially for SMP) is
> reasonable for a non preempt kernel.

This is within reach - the only major offender left is
rt_secret_rebuild (and possibly other areas of the route cache
handling).  Eric Dumazet had some suggestions to fix it, but the
details are beyond my area of expertise.

Lee
