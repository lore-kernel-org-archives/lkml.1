Return-Path: <linux-kernel-owner+w=401wt.eu-S1754011AbYIAOf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbYIAOf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 10:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbYIAOfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 10:35:19 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:26751 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbYIAOfS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 10:35:18 -0400
Message-Id: <48BC1A10.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Mon, 01 Sep 2008 15:36:32 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Boaz Harrosh" <bharrosh@panasas.com>
Cc: "David S. Miller" <davem@davemloft.net>, "Ingo Molnar" <mingo@elte.hu>,
       "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Ivo van Doorn" <IvDoorn@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Theodore Tso" <tytso@mit.edu>, "Rusty Russell" <rusty@rustcorp.com.au>,
       "John W. Linville" <linville@tuxdriver.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] debug: BUILD_BUG_ON: error on non-const	
	 expressions
References: <48BBE77D.7070007@panasas.com> <48BBEE04.30903@panasas.com>
 <48BC1065.76E4.0078.0@novell.com> <48BBFA67.9070305@panasas.com>
In-Reply-To: <48BBFA67.9070305@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Boaz Harrosh <bharrosh@panasas.com> 01.09.08 16:21 >>>
>> I have to admit that I'm surprise this compiles: You replace an expression
>> with a statement, and hence you reduce the places where BUILD_BUG_ON()
>> can validly be used. 
>
>it is only an expression because of the (void)() cast, which is what
>I'm trying to avoid.

No, sizeof() alone is an expression, too. Also, by using a statement you'll
have more problems with fixing BUILD_BUG_ON_ZERO(), which must be
an expression.

>> Of course you could wrap the whole thing in ({}),
>
>"do{}while(0)" is effectively an "{}" plus the added bonus
>of demanding an ";" ;-)

An expression likewise demands a terminating ; (or a continuation of the
expression, i.e. by using an operator)

>> Also, are you sure the compiler will eliminate the dead variable in all
>> cases?
>> 
>> Finally, using as common a variable as 'x' here seems dangerous, too:
>> What if somewhere x is #define-d to something more complex than a
>> simple identifier?
>
>No it is scoped in a dead do{}while(0). What gets optimized out most
>is the do nothing do{}while(0). The inside is just ignored.

I don't think compilers in general and gcc in particular work this way
(i.e. automatically throwing away everything included in a dead block).

Jan

