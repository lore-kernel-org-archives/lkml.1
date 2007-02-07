Return-Path: <linux-kernel-owner+w=401wt.eu-S1030510AbXBGBYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030510AbXBGBYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 20:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030527AbXBGBYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 20:24:40 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:35902 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030510AbXBGBYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 20:24:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EKKhoTL1+jgsGw1c652ev8qJttfCSx/dm+qyTrTaKeCVlHqDxUZZJn0TFoRoapZG1WXQlkKLlI1AHiFswDVpuzV2kNfxJksnan2xQFb71QI5ZdS7KR4ykB6xlUs3X/xWuFhulA3ZF+U7pW89sXPWXBDcC2wIRBT2Fm4riVc40IA=
Message-ID: <6f703f960702061724o51e2cdadi28ae367c2b3029cb@mail.gmail.com>
Date: Tue, 6 Feb 2007 16:24:37 -0900
From: "Kent Overstreet" <kent.overstreet@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Cc: "Joel Becker" <Joel.Becker@oracle.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Zach Brown" <zach.brown@oracle.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Benjamin LaHaise" <bcrl@kvack.org>
In-Reply-To: <Pine.LNX.4.64.0702061658370.19136@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0702051223390.8424@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0702061238300.8424@woody.linux-foundation.org>
	 <6f703f960702061445q23dd9d48q7afec75d2400ef62@mail.gmail.com>
	 <Pine.LNX.4.64.0702061518220.19136@alien.or.mcafeemobile.com>
	 <20070206233907.GW32307@ca-server1.us.oracle.com>
	 <Pine.LNX.4.64.0702061541590.19136@alien.or.mcafeemobile.com>
	 <20070207000626.GC32307@ca-server1.us.oracle.com>
	 <Pine.LNX.4.64.0702061612220.19136@alien.or.mcafeemobile.com>
	 <20070207004443.GE32307@ca-server1.us.oracle.com>
	 <Pine.LNX.4.64.0702061658370.19136@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> If that's what is wanted, then the async_submit() API can detect the
> syncronous completion soon, and drop a result inside the result-queue
> immediately. It means that an immediately following async_wait() will find
> some completions soon. Or:
>
> struct async_submit {
>         void *cookie;
>         int sysc_nbr;
>         int nargs;
>         long args[ASYNC_MAX_ARGS];
> };
> struct async_result {
>         void *cookie;
>         long result:
> };
>
> int async_submit(struct async_submit *a, struct async_result *r, int n);
>
> Where "r" will store the ones that completed syncronously. I mean, there
> are really many ways to do this.

That interface (modifying async_submit to pass in the size of the
result array) would work great.
