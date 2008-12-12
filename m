Return-Path: <linux-kernel-owner+w=401wt.eu-S1759525AbYLLSF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525AbYLLSF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 13:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757802AbYLLSFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 13:05:13 -0500
Received: from mail-bw0-f13.google.com ([209.85.218.13]:51413 "EHLO
	mail-bw0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757915AbYLLSFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 13:05:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=cZ5Rs/G8W9vCfUV2QnkN2cYgaQOAsX51aJtHE8v4t8tvQxY25ZghGU3L+delsEtJ7A
         KI3FzzZwt3ddL1VtallZScqvDGhqe5iYsLLcPVoXtEv0aCn6SgTaLqKpCH83XLoOvAY+
         xdRJXgbZRtNlLlgQ4DF0l5TSWQ7ZsoAt/J+s8=
Message-ID: <7c86c4470812121001i765d663bq6db3080b633a1eef@mail.gmail.com>
Date: Fri, 12 Dec 2008 19:01:20 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [patch] Performance Counters for Linux, v3
Cc: "Vince Weaver" <vince@deater.net>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric Dumazet" <dada1@cosmosbay.com>,
       "Robert Richter" <robert.richter@amd.com>,
       "Arjan van de Veen" <arjan@infradead.org>,
       "Peter Anvin" <hpa@zytor.com>, "Paul Mackerras" <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <7c86c4470812120942x607a74f7w9f823adecbd73b85@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081211155230.GA4230@elte.hu>
	 <Pine.LNX.4.64.0812111247510.22556@pianoman.cluster.toy>
	 <1229070345.12883.12.camel@twins>
	 <7c86c4470812120059s7f8e64a6h91ebeadbf938858d@mail.gmail.com>
	 <1229073834.12883.41.camel@twins>
	 <7c86c4470812120942x607a74f7w9f823adecbd73b85@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Given the level of abstractions you are using for the API, and given
your argument
that the kernel can do the HW resource scheduling better than anybody else.

What happens in the following test case:

   - 2-way system (cpu0, cpu1)

   - on cpu0, two processes P1, P2, each self-monitoring and counting event E1.
     Event E1 can only be measured on counter C1.

   - on cpu1, there is a cpu-wide session, monitoring event E1, thus using C1

   - the scheduler decides to migrate P1 onto CPU1. You now have a
conflict on C1.

How is this managed?
