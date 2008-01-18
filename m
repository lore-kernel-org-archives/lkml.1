Return-Path: <linux-kernel-owner+w=401wt.eu-S1764819AbYARTzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764819AbYARTzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 14:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761968AbYARTz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 14:55:27 -0500
Received: from mail.impinj.com ([206.169.229.170]:38239 "EHLO earth.impinj.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762184AbYARTz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 14:55:26 -0500
From: Vadim Lobanov <vlobanov@speakeasy.net>
To: Zan Lynx <zlynx@acm.org>
Subject: Re: Why is the kfree() argument const?
Date: Fri, 18 Jan 2008 11:55:22 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Andy Lutomirski <luto@myrealbox.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Schwartz <davids@webmaster.com>,
       Johannes Weiner <hannes@saeurebad.de>, clameter@sgi.com,
       penberg@cs.helsinki.fi
References: <MDEHLPKNGKAHNMBLJOLKOEIPJJAC.davids@webmaster.com> <200801181114.33513.vlobanov@speakeasy.net> <1200684666.7735.22.camel@localhost>
In-Reply-To: <1200684666.7735.22.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801181155.22301.vlobanov@speakeasy.net>
X-OriginalArrivalTime: 18 Jan 2008 19:55:23.0962 (UTC) FILETIME=[104C91A0:01C85A0C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2008 11:31:05 am Zan Lynx wrote:
> On Fri, 2008-01-18 at 11:14 -0800, Vadim Lobanov wrote:
> > Second, even if const did have stronger semantics that forbade the value
> > of x from being modified during execution of foo, the compiler still
> > could not reorder the two function calls, before it cannot assume that
> > the two functions (in their internal implementations) do not touch some
> > other, unknown to this code, global variable.
>
> This is why GCC has the pure and const function attributes.  These
> attributes are more powerful than the "const" keyword, and do allow
> optimizations with assumptions about global state.

Oh, absolutely. The problem, however, is that very very few people actually 
use these function attributes in their code. Heck, we don't even use the 
standard restrict keyword, much less gcc-specific function annotations.

I think that one part of the problem is because gcc seems to have had 
attribute diarrhea -- I know of noone who can recite more than 10% of the 
available attributes without glancing at the documentation. The other part of 
the problem is that gcc does no sanity checks on the provided attributes. For 
example, the code below compiles perfectly fine without a peep, even 
with -Wall and -Wextra.

int global;

void foobar(const int *x) __attribute__((const));

void foobar(const int *x)
{
        if (*x)
                *(int *)x = 7;
        global = 11;
}

*grumble, grumble* :-)

-- Vadim Lobanov
