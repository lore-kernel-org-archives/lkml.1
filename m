Return-Path: <linux-kernel-owner+w=401wt.eu-S935408AbXJQRIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935408AbXJQRIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 13:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762564AbXJQRII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 13:08:08 -0400
Received: from smtp-out.google.com ([216.239.45.13]:53496 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762586AbXJQRIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 13:08:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=mF8TksgTkkbaP5FhBGsKELC0DXWYLu9FKMvsozvj7gRUfn+c4YuBAnTPiWrVe3Ikc
	rY2r43U/Ou3xgeL1jU+2Q==
Message-ID: <b040c32a0710171008s4acf8d80y137ace2bfd0a894e@mail.gmail.com>
Date: Wed, 17 Oct 2007 10:08:00 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [patch] sched: fix improper load balance across sched domain
Cc: "Ingo Molnar" <mingo@elte.hu>, "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20071017022303.GA27457@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b040c32a0710161207s4d6d4d4cq1fa7f0dd1a7f017d@mail.gmail.com>
	 <20071017022303.GA27457@linux-os.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/07, Siddha, Suresh B <suresh.b.siddha@intel.com> wrote:
> On Tue, Oct 16, 2007 at 12:07:06PM -0700, Ken Chen wrote:
> > We recently discovered a nasty performance bug in the kernel CPU load
> > balancer where we were hit by 50% performance regression.
> >
> > When tasks are assigned to a subset of CPUs that span across
> > sched_domains (either ccNUMA node or the new multi-core domain) via
> > cpu affinity, kernel fails to perform proper load balance at
> > these domains, due to several logic in find_busiest_group() miss
> > identified busiest sched group within a given domain. This leads to
> > inadequate load balance and causes 50% performance hit.
> >
> > To give you a concrete example, on a dual-core, 2 socket numa system,
> > there are 4 logical cpu, organized as:
>
> oops, this issue can easily happen when cores are not sharing caches. I
> think this is what happening on your setup, right?

yes, we observed the bad behavior on quad-core system with separate L2
cache as well.

- Ken
