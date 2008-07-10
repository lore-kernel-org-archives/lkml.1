Return-Path: <linux-kernel-owner+w=401wt.eu-S1755680AbYGJHYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbYGJHYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 03:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbYGJHYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 03:24:08 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:37025 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751455AbYGJHYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 03:24:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=PPmV1pSgQjaNL8+3qU8ONfkKf2xS9pvUwFDVfEdQZIVa5i4qxArVkP6H+iKrpy4FhOpTmxyiajzzVVDsYBYqWAlSyAU+R3YNa7eLt+uQxz5sBlOz7LTq3pOIb9Elr6U857UZbIH0ADxS22kR6oT30uGWmUwlxhYUt4bPiQ0BbBQ=  ;
X-YMail-OSG: 0OqYzFEVM1mo4hpuI0Q5GFFxZ9qGE.wRIlP9uQjA3eEG5PaNAxibR1o0LfIWzyv6YXoJjPI1WLqiZ9jUByDB4MCuT3j._T0J7411NWHQhjS7fe0HA7K2cGc31aR9Erdclm4-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Subject: Re: [PATCH] fix task dirty balancing
Date: Thu, 10 Jul 2008 17:23:36 +1000
User-Agent: KMail/1.9.5
Cc: a.p.zijlstra@chello.nl, kamezawa.hiroyu@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org
References: <200807091741.25447.nickpiggin@yahoo.com.au> <20080710031051.887CA5A29@siro.lan>
In-Reply-To: <20080710031051.887CA5A29@siro.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807101723.36713.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 July 2008 13:10, YAMAMOTO Takashi wrote:
> hi,
>
> thanks for the review.
>
> > On Wednesday 09 July 2008 09:38, YAMAMOTO Takashi wrote:
> > > hi,
> > >
> > > > Please beat me to cleaning up this stuff - otherwise I'll have to
> > > > look at it when I get back from holidays.
> > >
> > > how about the following?
> >
> > Quite good, however I would like to keep the buffers warning if it isn't
> > too difficult (it has already caught one or two real bugs).
>
> isn't the WARN_ON_ONCE in __set_page_dirty_nobuffers enough?

No, because it will skip warning if the page has buffers (which is a
very common case for fs/buffer.c :)).


> > Also, we should
> > split out the bugfix from the cleanup. But yes overall I think the result
> > looks quite nice.
>
> honestly, i don't think it makes much sense to separate the fix and
> the cleanup in this particular case.  trying to keep the bug while
> the code cleanup naturally fixes it, or vice versa, would be a waste
> of time.

It always makes sense to separate fix and cleanup IMO. The most important
reason is that it makes it clearer to review the fix. Secondarily, it
makes it easier to ensure no unwanted changes in the cleanup part.
