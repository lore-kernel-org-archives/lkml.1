Return-Path: <linux-kernel-owner+w=401wt.eu-S1754521AbXI1TnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbXI1TnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 15:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbXI1Tm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 15:42:58 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:32881 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752172AbXI1Tm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 15:42:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=JnHLO+atXjDrru/sNxe4AGJy5lPNKQ6n9G71SqS+IuDp20mZ2HDrILPx+HnHQb/uZM6eyZXZEWovI++O6DSmj/KAncNli7cISBHPLjJvMLB/hJpExwmtEJI72f8MRTCXdS9H4baRL4uvyTfxL0QZ6CjHxn3clf/mmlmtSv/YcIM=  ;
X-YMail-OSG: 7PX45CsVM1mTDq3X_Ez9bVHBRx3Qy8.fKREomgj62YOQnSSpXx.ntpIgYHeaAfLbsBLIW7yADA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 05/12] mm: trylock_page
Date: Fri, 28 Sep 2007 13:11:37 +1000
User-Agent: KMail/1.9.5
Cc: lkml <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org
References: <20070928074200.436463000@chello.nl> <20070928080041.891125000@chello.nl>
In-Reply-To: <20070928080041.891125000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709281311.37616.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 September 2007 17:42, Peter Zijlstra wrote:
> Replace raw TestSetPageLocked() usage with trylock_page()

I have such a thing queued too, for the lock bitops patches for when 2.6.24
opens, Andrew promises me :).

I guess they should be identical, except I don't like doing trylock_page in
place of SetPageLocked, for memory ordering performance and aesthetic
reasons... I've got an init_page_locked (or set_page_locked... I can't
remember, the patch is at home).

Fine idea to lockdep the page lock, anyway. Does it show up any of the
buffered write deadlock possibilities? :)

buffer lock is another notable bit-mutex that might be converted (I have
the patch to do the similar nice !tas->trylock conversion for that too). I
think it is used widely enough by tricky code that it would be useful to
annotate as well.

Unfortunately we can't convert bit_spinlock.h easily, I guess?
