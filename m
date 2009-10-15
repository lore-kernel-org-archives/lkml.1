Return-Path: <linux-kernel-owner+w=401wt.eu-S935087AbZJOS2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935087AbZJOS2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 14:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933312AbZJOS2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 14:28:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932895AbZJOS2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 14:28:53 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ian Lance Taylor <iant@google.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] x86: linker script syntax nits
In-Reply-To: H. Peter Anvin's message of  Thursday, 15 October 2009 10:17:20 -0700 <4AD75920.8000303@zytor.com>
References: <20091014221024.EFA79E2F@magilla.sf.frob.com>
	<20091015033010.GB10068@merkur.ravnborg.org>
	<20091015063837.GA11645@elte.hu>
	<4AD75920.8000303@zytor.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20091015182616.DFD875E6@magilla.sf.frob.com>
Date: Thu, 15 Oct 2009 11:26:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The other -- and somewhat less cantankerous way -- is to use a dummy symbol:
> 
> #define LINUX_ASSERT(expr, name, string) name = ASSERT(expr, string)
> 
> "name" would have to be unique for each instance.

I wouldn't like to pollute the symtabs with those useless symbols.

#define LINUX_ASSERT(expr, string) PROVIDE(_assert_bogon = ASSERT(expr, string))

works with a recent ld.  I don't know what the problematic old ld versions
were.  Do you have such on hand to test?

Ian may have another suggestion.


Thanks,
Roland
