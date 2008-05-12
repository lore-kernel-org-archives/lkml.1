Return-Path: <linux-kernel-owner+w=401wt.eu-S1759109AbYELKBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759109AbYELKBB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 06:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760799AbYELKAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 06:00:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50801 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757915AbYELKAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 06:00:49 -0400
Date: Mon, 12 May 2008 12:08:09 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Paulo Marques <pmarques@grupopie.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: /proc/kallsyms broken in 2.6.26-rc1-git6
Message-ID: <20080512100809.GH31954@one.firstfloor.org>
References: <20080509174148.GA22246@basil.nowhere.org> <482491D6.9030205@grupopie.com> <4824A7B6.70306@firstfloor.org> <4824AD3C.3070506@grupopie.com> <4824DB36.8000500@firstfloor.org> <4828140F.9030609@grupopie.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4828140F.9030609@grupopie.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So, the only difference is the filter made by that "grep -v" to exclude 
> a few classes of symbols.
> 
> Maybe I lost myself in that expression, but it doesn't seem like it 
> would be able to filter out the symbols you're seeing. Are you sure the 
> same symbols don't appear in System.map?

They do, but that's also new.

> 
> >They didn't use to be there and don't
> >make any sense because they don't have any valid kernel addresses.
> 
> I don't know enough about the markers infrastructure but I guess these 
> "addresses" are more like an "offset" into a markers structure that is 
> automatically produced by putting these symbols into a special section 
> that starts at offset 0.

I don't know too much about the markers implementation either and
if it's caused by then.

> Well, my first suspects would be these:
> 
> CONFIG_KPROBES=y
> CONFIG_KRETPROBES=y
> CONFIG_HAVE_KPROBES=y
> CONFIG_HAVE_KRETPROBES=y

I've always had those enabled and afaik they don't generate any 
magic symbols.

> 
> >
> >It's the other way round -- kallsyms changed and that change will likely
> >break programs.
> 
> I don't have the time right now to try your configuration and pinpoint 
> the problem, but if you can come up with a plan, like: "we need to 
> filter out symbols from the output of "nm" whose type is 'N'", I'll be 
> more than happy to provide a patch to fix it...

man nm says

 "N" The symbol is a debugging symbol.

while I'm not 100% sure what a debugging symbol is I suppose we don't
need those so yes please filter those out (both
out of System.map and out of kallsyms) 

-Andi
