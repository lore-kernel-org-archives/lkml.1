Return-Path: <linux-kernel-owner+w=401wt.eu-S1752294AbXJVAgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbXJVAgf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 20:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbXJVAg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 20:36:27 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:44384 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750839AbXJVAg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 20:36:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=kdGqLDzgtrNG9ZgWG+1IBPjd7RRf/4G+7RLk/sLjxqxp06qYXa3wRQW6vE8e1Roh8eUhNQzqd5u4pRlxmtKN2iT8j2n0L01BWnBSuMlQdCBoW9/k3r+3XRZ2hF3JKnAeVwQ2ztREyuggHrIL25iaTyk/JxO1qRVUAkL38xwEdFU=  ;
X-YMail-OSG: HL91HBIVM1moWevUtW_trAutSjk4rORS9LWiBYCxUWrmiL5g4gTlYRnxV2u0DSRmynvjVDplaw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Takenori Nagano <t-nagano@ah.jp.nec.com>
Subject: Re: [PATCH 0/2] add new notifier function ,take2
Date: Sun, 21 Oct 2007 22:00:03 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, vgoyal@in.ibm.com,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, k-miyoshi@cb.jp.nec.com,
       kexec@lists.infradead.org, Bernhard Walle <bwalle@suse.de>,
       Keith Owens <kaos@ocs.com.au>, kdb@oss.sgi.com
References: <471700F4.1080200@ah.jp.nec.com> <20071018080621.GB8779@in.ibm.com> <47171ED9.7010907@ah.jp.nec.com>
In-Reply-To: <47171ED9.7010907@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710212200.04361.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 October 2007 18:52, Takenori Nagano wrote:
> Vivek Goyal wrote:

> > > My stance is that _all_ the RAS tools (kdb, kgdb, nlkd, netdump, lkcd,
> > > crash, kdump etc.) should be using a common interface that safely puts
> > > the entire system in a stopped state and saves the state of each cpu.
> > > Then each tool can do what it likes, instead of every RAS tool doing
> > > its own thing and they all conflict with each other, which is why this
> > > thread started.
> > >
> > > It is not the kernel's job to decide which RAS tool runs first, second
> > > etc., it is the user's decision to set that policy. Different sites
> > > will want different orders, some will say "go straight to kdump", other
> > > sites will want to invoke a debugger first. Sites must be able to
> > > define that policy, but we hard code the policy into the kernel.
>
> I agreed with him and I made new notifier function that users can change
> the order. Priority value in notifier blocks are hardcoded. If users want
> to change list order, they have to rebuild kernel. I think it is very
> unhappy.

Is it possible to use a single bit of common code and a single
notifier for these things? Or is it too difficult?

One thing I'd suggest is not to use debugfs, if it is going to
be a useful end-user feature.
