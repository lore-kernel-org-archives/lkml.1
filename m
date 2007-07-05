Return-Path: <linux-kernel-owner+w=401wt.eu-S1760579AbXGERRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760579AbXGERRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 13:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756674AbXGERR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 13:17:26 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:35538 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199AbXGERRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 13:17:25 -0400
Subject: Re: [PATCH] dio: remove bogus refcounting BUG_ON
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Zach Brown <zach.brown@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <3439F83E-9FBD-4743-B2A9-63009B7087FD@oracle.com>
References: <46832499.40807@us.ibm.com>
	 <5A6608DF-EDC3-43C1-BFB7-58ACBF94DBCB@oracle.com>
	 <46859DE2.9040604@us.ibm.com>  <20070703222855.GA6293@mami.zabbo.net>
	 <1183602311.29435.1.camel@dyn9047017100.beaverton.ibm.com>
	 <3439F83E-9FBD-4743-B2A9-63009B7087FD@oracle.com>
Content-Type: text/plain
Date: Thu, 05 Jul 2007 10:16:59 -0700
Message-Id: <1183655819.19473.0.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-05 at 10:11 -0700, Zach Brown wrote:
> > the BUG_ON(). But unfortunately, our perf. team is able reproduce the
> > problem.
> 
> What are they doing to reproduce it?  How much setup does it take?

Huge OLTP run :(

> 
> > Debug indicated that, the ret2 == 1 :(
> 
> That could be consistent with the theory that we're racing with the  
> dio struct being freed and reused before it's tested in the BUG_ON()  
> condition.  Suparna's suggestion to sample dio->is_async before  
> releasing the refcount and using that in the BUG_ON condition is a  
> good one.

I will ask them to try that.

Thanks,
Badari

