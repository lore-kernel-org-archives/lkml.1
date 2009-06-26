Return-Path: <linux-kernel-owner+w=401wt.eu-S1760742AbZFZQNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760742AbZFZQNU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 12:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbZFZQNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 12:13:12 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:42322 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751252AbZFZQNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 12:13:12 -0400
Subject: Re: kmemleak suggestion (long message)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20090626085056.GC3451@localdomain.by>
References: <20090625221816.GA3480@localdomain.by>
	 <20090626065923.GA14078@elte.hu>
	 <84144f020906260007u3e79086bv91900e487ba0fb50@mail.gmail.com>
	 <20090626081452.GB3451@localdomain.by>
	 <1246004270.27533.16.camel@penberg-laptop>
	 <20090626085056.GC3451@localdomain.by>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 26 Jun 2009 17:12:46 +0100
Message-Id: <1246032766.30717.44.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jun 2009 16:12:47.0145 (UTC) FILETIME=[F1E2C990:01C9F678]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-26 at 11:50 +0300, Sergey Senozhatsky wrote:
> On (06/26/09 11:17), Pekka Enberg wrote:
> > Well, the thing is, I am not sure it's needed if we implement Ingo's
> > suggestion. After all, syslog is no longer spammed very hard and you can
> > do all the filtering in userspace when you read /debug/mm/kmemleak file,
> > no?
> 
> Well, we just move 'spam' out of syslog. Not dealing with 'spam' itself.
> I'm not sure about 'filtering in userspace when you read'. Suppose I use
> 'tail -f /debug/mm/kmemleak'. How can I easy suppress printing of (for example):

I had a look at your patch and I tend to agree with Pekka. It really
adds too much complexity for something that could be easily done in user
space (could be more concise or even written in perl, awk, sed, python
etc.):

cat /sys/kernel/debug/kmemleak | tr "\n" "#" \
	| sed -e "s/#unreferenced/\nunreferenced/g" \
	| grep -v "tty_ldisc_try_get" | tr "#" "\n"

It would have made sense with the output in syslog but I just removed
this feature.

As for "tail -f", I'm not sure it would work anyway because of the way
the seqfile content is generated. New detected leaks aren't necessarily
appended to the kmemleak file. They are always listed in the order they
were allocated.

Thanks anyway.

-- 
Catalin

