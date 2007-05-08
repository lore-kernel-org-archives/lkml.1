Return-Path: <linux-kernel-owner+w=401wt.eu-S1032024AbXEHUIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032024AbXEHUIF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967203AbXEHUH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:07:58 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:10674 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032112AbXEHUHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:07:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=p51AnSi6uNcQyR+bvarYq4t7n3223y03+esoYAwIAeHYxxEETloSDqa1V1HS4ekli39/HZ9DbS1OpA7/LDopfKdAxWHjWq4a2R6pAia6hxtRMG17YvpdOHx/gbIf4KQ60HrCjktPndXnjCo0pV7VDWh+9aB30OoHxW7MTfeB08g=
Message-ID: <a781481a0705081307r546f8889qecca3db16ea03fb8@mail.gmail.com>
Date: Tue, 8 May 2007 13:07:51 -0700
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [RFC/PATCH] doc: volatile considered evil
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Paul Sokolovsky" <pmiscml@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070508121404.17bd97a6.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <516386418.20070501080839@gmail.com>
	 <20070430235642.e576e917.akpm@linux-foundation.org>
	 <20070508121404.17bd97a6.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/8/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Mon, 30 Apr 2007 23:56:42 -0700 Andrew Morton wrote:
>
> > Oh my eyes.  What are these doing?
> >
> > The volatiles are a worry - volatile is said to be basically-always-wrong
> > in-kernel, although we've never managed to document why, and i386
> > cheerfully uses it in readb() and friends.
> >
> > Perhaps if you can describe presisely what's going on here, alternatives
> > might be suggested.
>
> [well, can be turned into a patch]
>
> Here are some 'volatile' comments from Linus, extracted from
> several emails in at least 2 threads.
>
> If this is close to useful, we can add it to Documentation/.

Yes, definitely. Say Documentation/volatile-usage.txt -- this raw
version could be touched a little bit, to have sections that clearly
explain (1) how volatile makes the compiler generate trashy code, (2)
why volatile doesn't even do what people _think_ it does, considering
code is executed out-of-order by _hardware_ these days and not due to
compilers like was the case 20 years back, (3) and so volatile ends up
_hiding_ bugs from people and thus should be consigned to the trash
can of history, (4) _except_ for _really special_ usage cases like
reading IO mapped as memory.
