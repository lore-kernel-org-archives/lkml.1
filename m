Return-Path: <linux-kernel-owner+w=401wt.eu-S1756872AbXKLHz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbXKLHz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 02:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbXKLHzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 02:55:16 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33146 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753131AbXKLHzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 02:55:14 -0500
Date: Mon, 12 Nov 2007 08:54:52 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, Frank Seidel <fseidel@suse.de>
Subject: Re: [RFC 13/13] Char: nozomi, cleanup read and write
Message-ID: <20071112075452.GD9771@stusta.de>
References: <10551261882075921134.slaby@pripojeni.net> <151715551528512164.slaby@pripojeni.net> <20071110161511.GA21669@stusta.de> <47362AF9.5080009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47362AF9.5080009@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2007 at 11:04:41PM +0100, Jiri Slaby wrote:
> On 11/10/2007 05:15 PM, Adrian Bunk wrote:
> > On Fri, Nov 09, 2007 at 06:51:35PM -0500, Jiri Slaby wrote:
> >> ...
> >> --- a/drivers/char/nozomi.c
> >> +++ b/drivers/char/nozomi.c
> >> ...
> >> -		if (size_bytes - i == 2) {
> >> +		if (unlikely(size_bytes - i == 2)) {
> >> ...
> > 
> > Please don't add likely/unlikely in drivers unless it brings a 
> > measurable improvement.
> 
> Why? Anyway I think this is the case. The body of the then branch is executed at
> most once, while the else branch each time but last. If you write/read 1002
> bytes, it means 250:1. ...and it's invoked from interrupt too...

AFAIK there is no well defined semantics whether likely/unlikely means 
10:1 or 10000:1 that is guaranteed to not change during the next
10 years.

Unless there's a measurable difference, it's best to write readable 
C code and simply leave all optimizations to the compiler.

> regards,

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

