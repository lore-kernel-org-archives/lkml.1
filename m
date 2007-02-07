Return-Path: <linux-kernel-owner+w=401wt.eu-S1161087AbXBGJhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161087AbXBGJhU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 04:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161068AbXBGJhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 04:37:20 -0500
Received: from wr-out-0506.google.com ([64.233.184.237]:46169 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161087AbXBGJhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 04:37:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NndlAuASUfh743ngHHXymhsBdh4fhPnVu63Xasu6uYfu4eYA7bk0Ur2bSHqBKgcTubOYKlcxNh/QfFJ8SiFJSepg9RA6LplQUQUjbDcJGVNjTOoVpc2lyoupTOR2cu9dT9ijqhcx1RmqBe+/xAgUmXZHtLX2TxTMS3uVGpp29os=
Message-ID: <f2b55d220702070137k58d99449g604ebb352ad84c69@mail.gmail.com>
Date: Wed, 7 Feb 2007 01:37:17 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>,
       "Kent Overstreet" <kent.overstreet@gmail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Zach Brown" <zach.brown@oracle.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Benjamin LaHaise" <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
In-Reply-To: <f2b55d220702070117r7fb612f0ta3151820ab33ecbc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0702051223390.8424@woody.linux-foundation.org>
	 <6f703f960702061445q23dd9d48q7afec75d2400ef62@mail.gmail.com>
	 <Pine.LNX.4.64.0702061518220.19136@alien.or.mcafeemobile.com>
	 <20070206233907.GW32307@ca-server1.us.oracle.com>
	 <Pine.LNX.4.64.0702061541590.19136@alien.or.mcafeemobile.com>
	 <20070207000626.GC32307@ca-server1.us.oracle.com>
	 <Pine.LNX.4.64.0702061612220.19136@alien.or.mcafeemobile.com>
	 <20070207004443.GE32307@ca-server1.us.oracle.com>
	 <f2b55d220702062216n6b6757e5h10701851b422bc62@mail.gmail.com>
	 <f2b55d220702070117r7fb612f0ta3151820ab33ecbc@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

An idiot using my keyboard wrote:
>     - AIO requests that are serviced from cache ought to immediately
> invoke the callback, in the same thread context as the caller, fixing
> up the stack so that the callback returns to the instruction following
> the syscall.  That way the "immediate completion" path through the
> callback can manipulate data structures, allocate memory, etc. just as
> if it had followed a synchronous call.

Or, of course:
    if (async_stat(entry) == 0) {
        ... immediate completion code path ...
    }

Ugh.  But I think the discussion about the delayed path still holds.

- Michael
