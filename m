Return-Path: <linux-kernel-owner+w=401wt.eu-S1755991AbYLaJD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbYLaJD5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 04:03:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbYLaJDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 04:03:42 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:48177 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbYLaJDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 04:03:39 -0500
Date: Wed, 31 Dec 2008 10:05:10 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/13] kconfig: print all locations when we see a recursive dependency
Message-ID: <20081231090510.GA15943@uranus.ravnborg.org>
References: <20081229134402.GA7069@uranus.ravnborg.org> <1230558803-7168-6-git-send-email-sam@ravnborg.org> <Pine.LNX.4.64.0812310346430.17013@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812310346430.17013@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2008 at 03:55:00AM +0100, Roman Zippel wrote:
> Hi,
> 
> On Mon, 29 Dec 2008, Sam Ravnborg wrote:
> 
> > It is nessesary to know all locations when trying to track
> > a recursive dependency. So print out all locations for each symbol.
> 
> The problem is that this is little more than a better grep, although 
> kconfig knows exactly what went wrong, but this info is scattered all over 
> the stack.
> We could either return more info to print more than just the symbol or 
> maintain more info while traversing the tree. The patch below does the 
> latter. The patch could use some small cleanups, so it's not final yet.

Hi Roman.

I will drop 
"[PATCH 05/13] kconfig: improve readout when we hit recursive dependencies"
"[PATCH 06/13] kconfig: print all locations when we see a recursive dependency"

and will await an updated version of the patch below.

Notice that with your patch below we still hit the segmentation fault
with the small test sample included in the description of 05/13:

    config TEST1
            bool
            depends on TEST2 && PCI
            select TEST2

    config TEST2
            bool

I guess this was one of the cleanups you had in mind.
I added a promt and then I got the following error message:

Kconfig:2:error: recursive dependency detected!
Kconfig:2:      symbol TEST1 prompt depends on TEST2
Kconfig:4:      symbol TEST2 is selected by TEST1

This is indeed better than before.

    Kconfig:2:      symbol TEST1 prompt depends on TEST2

should read:

    Kconfig:2:      symbol TEST1 depends on TEST2

As it just confuses with the "prompt" in the text.

It would be good to have the final patch ready soon so we can include
it in 2.6.29.

Thanks,
	Sam

