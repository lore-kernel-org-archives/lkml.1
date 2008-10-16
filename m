Return-Path: <linux-kernel-owner+w=401wt.eu-S1757323AbYJPSs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbYJPSs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 14:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbYJPSsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 14:48:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754146AbYJPSsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 14:48:45 -0400
Date: Thu, 16 Oct 2008 11:47:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Jiri Kosina <jkosina@suse.cz>, Adrian Bunk <bunk@kernel.org>,
       zippel@linux-m68k.org, sam@ravnborg.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: select validation (was: Re: [2.6 patch] HID: fix default building
 of all quirky devices)
In-Reply-To: <Pine.LNX.4.64.0810161002240.25933@anakin>
Message-ID: <alpine.LFD.2.00.0810161133150.3288@nehalem.linux-foundation.org>
References: <20081015041346.GE4710@cs181140183.pp.htv.fi> <20081015050557.GB20183@cs181140183.pp.htv.fi> <20081015073011.GE20183@cs181140183.pp.htv.fi> <alpine.LNX.1.10.0810150931350.26779@jikos.suse.cz> <alpine.LFD.2.00.0810151002120.3288@nehalem.linux-foundation.org>
 <Pine.LNX.4.64.0810161002240.25933@anakin>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 16 Oct 2008, Geert Uytterhoeven wrote:
> 
> Would it be possible for kconfig to check for invalid usage of select?
> 
> Like you should not use select to enable something that has
> dependencies. However, that would fail in case both the selector option
> and the selected option depend on the same.

Well, at least in theory you may actually want to select something that 
has dependencies, even if you don't want to select the dependencies.

For example, some feature may be enabled by default on some architecture 
or with some config. Example:

	bool SUPPORT_FEATURE
		default y
		depends on EXPERIMENTAL
		depends on !EMBEDDED
		depends on X86

which is just another way of saying

	bool SUPPORT_FEATURE
		default X86 && !EMBEDDED && EXPERIMENTAL

and it's still possible that some code wants to do a

	select SUPPORT_FEATURE

because the dependency isn't a _code_ dependency, it's a default-value 
dependency.

Now, you could say that then you should use that second version (ie the 
"default X86 && !EMBEDDED && EXPERIMENTAL" version), but the thing is, 
"depends on" is actually a more powerful and can result in more readable 
setup (because you can have multiple "depends on" lines and they are all 
logically anded together.

Do we do that? I dunno. But I wouldn't be surprised if we do.

		Linus
