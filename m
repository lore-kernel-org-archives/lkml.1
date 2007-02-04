Return-Path: <linux-kernel-owner+w=401wt.eu-S1751647AbXBDAoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbXBDAoy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 19:44:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbXBDAoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 19:44:54 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:34282 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbXBDAoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 19:44:54 -0500
Date: Sat, 3 Feb 2007 16:40:42 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Richard Knutsson <ricknu-0@student.ltu.se>,
       linux-kernel@vger.kernel.org
Subject: Re: A CodingStyle suggestion
Message-Id: <20070203164042.237f156b.randy.dunlap@oracle.com>
In-Reply-To: <aday7neydq9.fsf@cisco.com>
References: <20070203215848.GA10440@Ahmed>
	<45C51310.6070304@student.ltu.se>
	<20070204000532.GA20721@Ahmed>
	<aday7neydq9.fsf@cisco.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 Feb 2007 16:21:18 -0800 Roland Dreier wrote:

>  > Good catch :). A small grep of `access_ok' reveals that it's always used in the 
>  > form of:
>  > if (!access_ok()) { .. }
>  > 
>  > I can conclude that verbal/imperative methods like `kmalloc, add_work' be 
>  > checked as:
>  > ret = do_work();
>  > if (ret) { ... }
>  > and predicate methods like `acess_ok, pci_dev_present' be checked like:
>  > if (!access_ok) { ... }
>  > if (pci_dev_present) { ...}
>  > 
>  > Any comments ?
> 
> I don't think that's really the distinction that matters.  I think
> really the issue is that assignment within an if is hard to read, so
> 
> 	ret = foo(a, b);
>         if (ret) { ... }
> 
> is clearly preferred to
> 
> 	if ((ret = foo(a,b))) { ... }
> 
> However, in my opinion something like
> 
> 	if (foo(a,b)) { ... }
> 
> if perfectly fine if the return value of foo is not needed anywhere
> else.  In other words, there's no sense introducing a temporary
> variable to hold the return value if you're never going to do anything
> with it other than check it on the next line.

I agree with Roland's comments here.

And with Tim's about side effects.

---
~Randy
