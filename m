Return-Path: <linux-kernel-owner+w=401wt.eu-S932136AbXIRRzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136AbXIRRzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 13:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759911AbXIRRzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 13:55:42 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:36591 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761275AbXIRRzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 13:55:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Nj4AGr+i5C10aQvmI/6hcMz9+HdtVWflMShBVos0VZsk8IC9o5is/RzpXF2f41w520oUuxDGARXDWOD9uwU5MnVdcUamML6dXEOP90OrK+yBPNYnem6iEnPSBDgzh/ljEl0BB2UNttM2HEi3y5+jAVMYEYeMF07O4Y9EWz/Qm2E=  ;
X-YMail-OSG: BCHsBYIVM1nQMombKbInqGmBVfq6lRCNtBJ1mdqiEg1UYvDnx_wc3AJRBHnTjHmQJitweSlJtg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: use pagevec to rotate reclaimable page
Date: Tue, 18 Sep 2007 11:47:44 +1000
User-Agent: KMail/1.9.5
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <6.0.0.20.2.20070907113025.024dfbb8@172.19.0.2> <200709181129.50253.nickpiggin@yahoo.com.au> <20070918104435.2ba25ff3.akpm@linux-foundation.org>
In-Reply-To: <20070918104435.2ba25ff3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709181147.45006.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 September 2007 03:44, Andrew Morton wrote:
> On Tue, 18 Sep 2007 11:29:50 +1000 Nick Piggin <nickpiggin@yahoo.com.au> 
wrote:
> > It would be interesting to test -mm kernels. They have a patch which
> > reduces zone lock contention quite a lot.
>
> They do?  Which patch?

Hmm... mm-buffered-write-cleanup.patch.


> > I think your patch is a nice idea, and with less zone lock contention in
> > other areas, it is possible that it might produce a relatively larger
> > improvement.
>
> I'm a bit wobbly about this patch - it adds additional single-cpu overhead
> to reduce multiple-cpu overhead and latency.

Yeah, that's true. Although maybe it gets significantly more after the
patch in -mm.

Possibly other page batching sites have similar issues on UP... I wonder
if a type of pagevec that turns into a noop on UP would be interesting...
probably totally unmeasurable and not worth the cost of code
maintenance ;)
