Return-Path: <linux-kernel-owner+w=401wt.eu-S1754060AbYGaH1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbYGaH1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 03:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbYGaH1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 03:27:00 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:31480 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752522AbYGaH07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 03:26:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=fSZ6obTYun6JCCEdvBa4f1NEk0Gjwj2cqBAK7h1HeTX6RdWiiZvUESziHer3Lf4dMJiI/T8qFXl+kdo/AW5/d5GA0VCTge9vzct7GSb14L5ciOBVxko9h1B9CuqEi4q3fTz7mx72U0PlpLBljl4s1YjGt4xiHvl5UAQrKiPRlPw=  ;
X-YMail-OSG: HBy5GocVM1mVA4oU4hSxqPIFlLR2mnnESiHPdIAGHX11QNLAAuMoSWldSk4j5KA3do0LNSw7wqQcw7Bhkp3wbUaw4KQv6guaxPB9Pq3GK_rqP3bXRYo8EdiJ8HjtUr6IZrA-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Switching TestSetPageLocked to trylock_page
Date: Thu, 31 Jul 2008 17:26:51 +1000
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807311726.51816.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm wondering if I could get a patch merged which changes all
TestSetPageLocked and replaces them with trylock_page?

It would be done so there are no functional changes.

The reason I want to (aside from having a slightly more
intuitive API), is to facilitate the implementation of lockdep
on page lock, and also to use lock semantics bitops for the
lock rather than the big-hammer barriers that come with
test_and_set_bit.

The lock bitops stuff is one of the parts of my patchset to speed
up page lock functions (which results in nearly 50% faster
pagecache throughput on my G5, and even slightly faster on x86)...

Anyway, I remember you said these kinds of changes are appropriate
for just after -rc1, and I agree it shouldn't cause much pain.

Fixing up patch conflicts is literally a matter of
s/!TestSetPageLocked/trylock_page
s/TestSetPageLocked/!trylock_page

Thoughts?
