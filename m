Return-Path: <linux-kernel-owner+w=401wt.eu-S1754057AbXL3CBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbXL3CBL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 21:01:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbXL3CA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 21:00:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:47302 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbXL3CA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 21:00:57 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH] x86: unify x86 Makefile(s)
Date: Sun, 30 Dec 2007 03:00:51 +0100
User-Agent: KMail/1.9.6
Cc: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <20071228212341.GA6939@uranus.ravnborg.org> <200712292217.37474.ak@suse.de> <20071229214522.GG27360@does.not.exist>
In-Reply-To: <20071229214522.GG27360@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712300300.51427.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Without inlining the maxmimum stack usage inside foobar() is
> max(stack usage foo(), stack usage bar()). [1]

It's a little more complicated. gcc 4.x (not sure which x, might 0) 
is clever enough to not use max() stack, but only use the stack for the 
different scopes as needed similar as when the calls weren't inlined. 
But gcc 3 didn't do that.

> With foo() and bar() inlined (-funit-at-a-time also enables 
> -finline-functions-called-once), the maxmimum stack usage inside 
> foobar() is sum(stack usage foo(), stack usage bar()). And this
> worst case is the area where gcc 4 is much better than gcc 3.4.

Yes exactly.  If the functions weren't inlined the problem wouldn't
occur because the stack sizes do not add up in the same dynamic call chain. 
Thus a few statetic noinlines will fix it.

-Andi
