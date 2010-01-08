Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712Ab0AHNS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab0AHNS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 08:18:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054Ab0AHNS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 08:18:56 -0500
Received: from cantor.suse.de ([195.135.220.2]:32831 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753Ab0AHNS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 08:18:56 -0500
Message-ID: <4B4730C0.6000601@suse.cz>
Date: Fri, 08 Jan 2010 14:18:56 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kbuild@vger.kernel.org,
       Artem Bityutskiy <dedekind1@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sections mismatch detection
References: <1262772683.4263.147.camel@localhost> <20100106104823.GA30439@merkur.ravnborg.org> <4B44762C.1090605@suse.cz> <20100107150339.b66fadc5.rdunlap@xenotime.net> <20100108054144.GA15827@merkur.ravnborg.org>
In-Reply-To: <20100108054144.GA15827@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg napsal(a):
>> I would prefer to see (logically) the same section mismatch not be
>> reported multiple times, even though they are in different binary
>> files.  This would reduce the noise level quite a bit IMO.
> 
> That would be nice but is not trivially doable.
> We need to discover when there is a section mismatch
> resulting from for example a function in kernel/*
> calling a function in arch/$ARCH/kernel so we
> need to execute the check on multiple levels
> i order to catch the bugs as early as possible.
> 
> The easy 'fix' would be to execute the check only
> on vmlinux.o (default behaviour) but the added
> checks with the option enabled allows us to
> be much more precise in reporting where
> the section mismatch originate from.

But we could remember the (caller,callee) pairs and only emit the first
warning. Or am I missing something?

Michal
