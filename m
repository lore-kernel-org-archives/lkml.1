Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbZCVUaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbZCVUaH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 16:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbZCVU3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 16:29:54 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:16315 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984AbZCVU3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 16:29:53 -0400
Date: Sun, 22 Mar 2009 21:29:51 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Test some kernel feature without recompile
In-Reply-To: <2d05c4580903220343l4b1359fx79f18b56203bd463@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.0903222124580.7175@swampdragon.chaosbits.net>
References: <2d05c4580903220343l4b1359fx79f18b56203bd463@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Mar 2009, Dragoslav Zaric wrote:

> Hi,
> 
> I know when you work on some kernel module, you can change code and load
> module again and test it, but what if you change some built in kernel
> .c file, why
> would I need to recompile whole kernel just to see what happens if I change one
> .c file ??
> 
Depends on the nature of the change. Some changes will ripple through the 
whole kernel.
If, for example, you made a change to kmalloc() so that it takes an extra 
argument, then obviously all call sites would need changing and since 
kmalloc is used almose everywhere, then almost all files would need to be 
recompiled.
But if your change is entirely contained to a single file, then 'make' 
will already ensure that only that file is rebuilt when you run 'make' 
(you'll still have to re-link the kernel or module though and a reboot 
will still be needed).

> Why can I just compile one changed .c file and copy it where compiled version of
> that file reside inside kernel tree? 

'make' should already handle that for you. In what way does it not?

-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

