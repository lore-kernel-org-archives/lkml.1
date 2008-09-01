Return-Path: <linux-kernel-owner+w=401wt.eu-S1755280AbYIAP20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbYIAP20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 11:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbYIAP2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 11:28:17 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:28853 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbYIAP2R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 11:28:17 -0400
Message-Id: <48BC267E.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Mon, 01 Sep 2008 16:29:34 +0100
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
 <48BC1A10.76E4.0078.0@novell.com> <48BC037F.5010305@panasas.com>
In-Reply-To: <48BC037F.5010305@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Boaz Harrosh <bharrosh@panasas.com> 01.09.08 17:00 >>>
>What is broken with my BUILD_BUG_ON_ZERO(). I tried all tests and
>it works fine. Do you have a test with unwanted results?
>(Actually it's the original one I have not touched it).

That's the problem - it uses the same sizeof(char[]) approach, and hence
has the same problems that you just try to fix for BUILD_BUG_ON().

>>>> Of course you could wrap the whole thing in ({}),
>>> "do{}while(0)" is effectively an "{}" plus the added bonus
>>> of demanding an ";" ;-)
>> 
>> An expression likewise demands a terminating ; (or a continuation of the
>> expression, i.e. by using an operator)
>> 
>
>I was not criticizing your approach, I was commenting on:
>"{}" vs. do{}while(0) 

I think we're having some mis-understanding here: What I'm concerned
about is that you can't use statements where-ever expressions can be
used (the opposite is true, because expressions are statements). My
main concern is the limitation of its use inside macros, where one could
try to use comma expressions to combine multiple BUILD_BUG_ON()-s.

Jan

