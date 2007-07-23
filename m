Return-Path: <linux-kernel-owner+w=401wt.eu-S1761392AbXGWJBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761392AbXGWJBn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 05:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757111AbXGWJB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 05:01:27 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:46858 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933279AbXGWJBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 05:01:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=CaGaKqCr5b1MtZJoIZISGW+t4s9DYfcgQZf3u6LvYARPsDzMPrWkxHXT1bxcCPy+IyZPYm11hKavxYrwu1fBCVqOo4rCb1dkdADskOCFHhwKbhZDo8LTVF11rthUpO0iW3eLukPUGZuQctjgXyMyH4tzBAvjvLxF+ls3XWfHT80=  ;
X-YMail-OSG: eIngO4QVM1n2Cej6UoXtXJ9iCke5RthLY7oke6R89gRPOUQmOVahggLZkmKzK20rp5wA_uojaA--
Message-ID: <46A46E4B.7050007@yahoo.com.au>
Date: Mon, 23 Jul 2007 19:00:59 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Fengguang Wu <fengguang.wu@gmail.com>, Dave Jones <davej@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>, riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tim Pepper <lnxninja@us.ibm.com>, Chris Snook <csnook@redhat.com>
Subject: Re: [PATCH 0/3] readahead drop behind and size adjustment
References: <20070721210005.000228000@chello.nl>	 <20070722023923.GA6438@mail.ustc.edu.cn> <20070722024428.GA724@redhat.com>	 <20070722081010.GA6317@mail.ustc.edu.cn> <1185093236.6344.87.camel@localhost.localdomain>
In-Reply-To: <1185093236.6344.87.camel@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Sun, 2007-07-22 at 16:10 +0800, Fengguang Wu wrote:

>>So I opt for it being made tunable, safe, and turned off by default.

I hate tunables :) Unless we have workload A that gets a reasonable
benefit from something and workload B that gets a significant regression,
and no clear way to reconcile them...


> I'd like to see it turned on by default in -mm, and try to come up with
> some server-like workload to measure the effect.  Should be easy to
> simulate something (eg. apache server, where clients grab some files in
> preference, and apache server where clients grab different files).

I don't like this kind of conditional information going from something
like readahead into page reclaim. Unless it is for readahead _specific_
data such as "I got these all wrong, so you can reclaim them" (which
this isn't).

Possibly it makes sense to realise that the given pages are cheaper
to read back in as they are apparently being read-ahead very nicely.

But I don't like it as a use-once thing. The VM should be able to get
that right.

-- 
SUSE Labs, Novell Inc.
