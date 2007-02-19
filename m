Return-Path: <linux-kernel-owner+w=401wt.eu-S1750812AbXBSJuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750812AbXBSJuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 04:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750816AbXBSJug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 04:50:36 -0500
Received: from smtp-out.google.com ([216.239.45.13]:40927 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbXBSJuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 04:50:35 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=ShrZJBFg7NVS+bFog9umRuYm82SlhcgP/h34FHEiHHqAUQDeWPp0M3CZZ0j9gRjjY
	p0TxBCVb86xU9wPrXezww==
Message-ID: <6599ad830702190150w254a8d4dncce45a1f9b369579@mail.gmail.com>
Date: Mon, 19 Feb 2007 01:50:22 -0800
From: "Paul Menage" <menage@google.com>
To: "Kirill Korotaev" <dev@sw.ru>
Subject: Re: [ckrm-tech] [RFC][PATCH][0/4] Memory controller (RSS Control)
Cc: "Andrew Morton" <akpm@linux-foundation.org>, vatsa@in.ibm.com,
       ckrm-tech@lists.sourceforge.net, "Balbir Singh" <balbir@in.ibm.com>,
       xemul@sw.ru, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       svaidy@linux.vnet.ibm.com, devel@openvz.org
In-Reply-To: <45D972CC.2010702@sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070219065019.3626.33947.sendpatchset@balbir-laptop>
	 <20070219005441.7fa0eccc.akpm@linux-foundation.org>
	 <6599ad830702190106m3f391de4x170326fef2e4872@mail.gmail.com>
	 <45D972CC.2010702@sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/19/07, Kirill Korotaev <dev@sw.ru> wrote:
> >
> > I think it's OK for a container to consume lots of system time during
> > reclaim, as long as we can account that time to the container involved
> > (i.e. if it's done during direct reclaim rather than by something like
> > kswapd).
> hmm, is it ok to scan 100Gb of RAM for 10MB RAM container?
> in UBC patch set we used page beancounters to track containter pages.
> This allows to make efficient scan contoler and reclamation.

I don't mean that we shouldn't go for the most efficient method that's
practical. If we can do reclaim without spinning across so much of the
LRU, then that's obviously better.

But if the best approach in the general case results in a process in
the container spending lots of CPU time trying to do the reclaim,
that's probably OK as long as we can account for that time and (once
we have a CPU controller) throttle back the container in that case. So
then, a container can only hurt itself by thrashing/reclaiming, rather
than hurting other containers. (LRU churn notwithstanding ...)

Paul
