Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab0CGLXw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 06:23:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44756 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751047Ab0CGLXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 06:23:51 -0500
Date: Sun, 7 Mar 2010 03:23:34 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: don.mullis@gmail.com, david@fromorbit.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: modules, "modules" and CONFIG_LIST_SORT
In-Reply-To: <20100307091223.GA4895@x200>
Message-ID: <alpine.LFD.2.00.1003070320370.4033@localhost.localdomain>
References: <20100307091223.GA4895@x200>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 7 Mar 2010, Alexey Dobriyan wrote:
> 
> Unpleasant side effect of the change is that some modules stop being
> true modules, i. e. admin is unable to start using them without reboot
> if kernel was compiled without that tiny amount of core kernel.
> 
> Having used this feature several times, I think it'd be correct
> to preserve this behaviour, at least not regress for those modules
> which benefitted from it. For modules which were always "modules" (ipv6)
> it's fine to continue.
> 
> Can we declare some policy about it?
> 
> And revert LIST_SORT commit if yes.

Yeah, I think that in cases like this, you have a very good argument: 
LIST_SORT enables code that isn't that large, and is clearly very generic.

And changing the config later and trying to compile and install a module 
is rather sane. And if that new module needs LIST_SORT, you're screwed 
because it didn't get compiled in originally.

Honestly, personally I'd rather have a real library that modules can link 
to _before_ even loading into kernel space, but that's not how we've 
traditionally done things. So I guess we should just revert that commit.

		Linus
