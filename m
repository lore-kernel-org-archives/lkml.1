Return-Path: <linux-kernel-owner+w=401wt.eu-S1756616AbXHZGxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbXHZGxR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 02:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbXHZGxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 02:53:09 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:43219 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751191AbXHZGxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 02:53:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=lKmSq1sln9czz3DAQCwdoODe6e8I3UiWjCU99xmAaOUyJ7K0H5IqYRQleszr9dxwdpjM/iLI/2qZ04AjmA5Hp8XsK8fRnGmtq42Wa4wQj0G+xZz52r7HSYl/BHaS83DZvznAnVgSp5IdAdJ1VwjcMVm6WxF1T6Ryjcuvtb6pgwA=  ;
X-YMail-OSG: oyEF4ikVM1lWKTcaYvgSUHKjMckbOzsdvY6k6ncn.NbULNsxDdmAfgSAMobFVq25P36h4E3Q_A--
Message-ID: <46D1234D.4090300@yahoo.com.au>
Date: Sun, 26 Aug 2007 16:53:01 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Mitchell Erblich <erblichs@earthlink.net>
CC: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC] : mm : / Patch / code : Suggestion :snip  kswapd &  get_page_from_freelist()
  : No more no page failures.
References: <000601c7e6ae$db887680$6501a8c0@earthlink.net>
In-Reply-To: <000601c7e6ae$db887680$6501a8c0@earthlink.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mitchell@kvack.org wrote:
> linux-mm@kvack.org
> Sent: Friday, August 24, 2007 3:11 PM
> Subject: Re: [RFC] : mm : / Patch / code : Suggestion :snip kswapd &
> get_page_from_freelist() : No more no page failures.
> 
> Mailer added a HTML subpart and chopped the earlier email.... :^(

Hi Mitchell,

Is it possible to send suggestions in the form of a unified diff, even
if you haven't even compiled it (just add a note to let people know).

Secondly, we already have a (supposedly working) system of asynch
reclaim, with buffering and hysteresis. I don't exactly understand
what problem you think it has that would be solved by rechecking
watermarks after allocating a page.

When we're in the (min,low) watermark range, we'll wake up kswapd
_before_ allocating anything, so what is better about the change to
wake up kswapd after allocating? Can you perhaps come up with an
example situation also to make this more clear?

Overhead of wakeup_kswapd isn't too much of a problem: if we _should_
be waking it up when we currently aren't, then we should be calling
it. However the extra checking in the allocator fastpath is something
we want to avoid if possible, because this can be a really hot path.

Thanks,
Nick

-- 
SUSE Labs, Novell Inc.
