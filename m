Return-Path: <linux-kernel-owner+w=401wt.eu-S1760322AbXGERMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760322AbXGERMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 13:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757212AbXGERMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 13:12:17 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:22762 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757160AbXGERMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 13:12:16 -0400
In-Reply-To: <1183602311.29435.1.camel@dyn9047017100.beaverton.ibm.com>
References: <46832499.40807@us.ibm.com> <5A6608DF-EDC3-43C1-BFB7-58ACBF94DBCB@oracle.com> <46859DE2.9040604@us.ibm.com>  <20070703222855.GA6293@mami.zabbo.net> <1183602311.29435.1.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <3439F83E-9FBD-4743-B2A9-63009B7087FD@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] dio: remove bogus refcounting BUG_ON
Date: Thu, 5 Jul 2007 10:11:20 -0700
To: Badari Pulavarty <pbadari@us.ibm.com>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> the BUG_ON(). But unfortunately, our perf. team is able reproduce the
> problem.

What are they doing to reproduce it?  How much setup does it take?

> Debug indicated that, the ret2 == 1 :(

That could be consistent with the theory that we're racing with the  
dio struct being freed and reused before it's tested in the BUG_ON()  
condition.  Suparna's suggestion to sample dio->is_async before  
releasing the refcount and using that in the BUG_ON condition is a  
good one.

- z
