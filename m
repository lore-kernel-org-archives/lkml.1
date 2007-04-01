Return-Path: <linux-kernel-owner+w=401wt.eu-S1750967AbXDAQxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750967AbXDAQxN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 12:53:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbXDAQxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 12:53:13 -0400
Received: from hosting4p.com ([81.0.235.160]:51825 "EHLO micron1.hosting4p.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750967AbXDAQxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 12:53:12 -0400
Message-ID: <460FE380.2050608@slax.org>
Date: Sun, 01 Apr 2007 18:53:20 +0200
From: Tomas M <tomas@slax.org>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] remove artificial software max_loop limit
References: <b040c32a0703300053u110063b0u80ee0e7b9dd158c2@mail.gmail.com>	<b040c32a0703300148w479cf4cdw667cf464edf7c725@mail.gmail.com>	<Pine.LNX.4.61.0703301105190.31834@yvahk01.tjqt.qr>	<b040c32a0703300225r3f8b1daah2f95e8af26c0d867@mail.gmail.com> <20070330141524.5f6cff29.akpm@linux-foundation.org>
In-Reply-To: <20070330141524.5f6cff29.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 30 Mar 2007 02:25:37 -0700
> "Ken Chen" <kenchen@google.com> wrote:
> 
>> -module_param(max_loop, int, 0);
>> -MODULE_PARM_DESC(max_loop, "Maximum number of loop devices (1-256)");
> 
> So..  this change will cause a fatal error for anyone who is presently
> using max_loop, won't it?  If they're doing that within their
> initramfs/initrd/etc then things could get rather ugly for them.

I consider myself the most precious user of max_loop.

The max_loop parameter would cause a fatal error only in the case if you 
modprobe loop manually, for example:

  $ modprobe loop max_loop=200

But people don't usually use this, read below.

> I don't know how much of a problem this will be in practice - do
> people use max_loop much?

yes, but no as a module parameter.

People usually use max_loop as a 'kernel boot parameter' passed in 
APPEND section in a boot loader (such as LILO for example), not as a 
parameter for module in initrd. Why? Because it's easier; people are 
lazy, people compile loop.c into kernel so they don't need to update the 
loop.ko module in initrd every time a new Kernel is released.

I believe that IF you _really_ need to preserve the boot parameter, then 
the parameter should _not_ be ignored, rather it should have the same 
function like before - to limit the loop driver so if you use 
max_loop=10 for example, it should not allow loop.c to create more than 
10 loops.

And if no parameter is used at all, there will be unlimited amount of 
loops. Simply clever :)

This will make it _completely_ backward-compatible, with very small code 
change I guess.

Just my two cents.

Thank you for reading so far.

Tomas M
slax.org

