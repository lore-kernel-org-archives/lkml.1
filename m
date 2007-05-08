Return-Path: <linux-kernel-owner+w=401wt.eu-S968773AbXEHWrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968773AbXEHWrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968610AbXEHWrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:47:11 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:14943 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968601AbXEHWrJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:47:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LHbZNapsLSBqPlGekOgVljLIbD91q5whcEQFL4pZrY8GihP14FHSurbUPuolrHG8CCIBCYyhsiylsiMj4rAoGRVk/sLla53U64B3zH7mG5Rp1NuOYKksxraCtBwDxi2/+xrSUx9CKHxkLKngk+wry50HSpSQM7dy4lp9pUOJaO0=
Message-ID: <6bffcb0e0705081547t198ed83eg3f4861617216127d@mail.gmail.com>
Date: Wed, 9 May 2007 00:47:02 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Ken Moffat" <zarniwhoop@ntlworld.com>
Subject: Re: Lockup after logging out of X
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Vivek Goyal" <vgoyal@in.ibm.com>, "Andi Kleen" <ak@suse.de>
In-Reply-To: <20070508195142.GA30030@deepthought>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20070508195142.GA30030@deepthought>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ken,

On 08/05/07, Ken Moffat <zarniwhoop@ntlworld.com> wrote:
>  This is a resend, with a better title and slightly more
> clarification.  Originally sent yesterday evening, but I can see no
> evidence that it got beyond my isp's mailserver.  Apologies to the
> Cc's if you did get the original.
>
>  Using Linus' tree pulled on Sunday afternoon UK time.  Running an
> amd64 ('pure64') desktop using gdm for graphical login, on Xorg 7.2
> with a radeon 9200se.  No problems until I log out of the desktop
> and go back to gdm.  Before that, the text consoles seem to be
> working fine.  After I go back to gdm. the display is corrupted and
> only MagicSysRQ works.  Mostly, the keyboard LEDs flash, but the
> only thing that made it to the logs was this exceedingly incomplete
> oops report:
>
> May  7 21:02:54 bluesbreaker kernel: [   46.549615] [drm] writeback
> test succeeded in 1 usecs
> May  7 21:03:24 bluesbreaker kernel: [   61.552793] Unable to handle
> kernel paging request at ffff81003befd3e8 RIP:
> May  7 21:03:24 bluesbreaker kernel: [   61.552798]
> [<ffffffff80271576>] fasync_helper+0x52/0xf0
> May  7 21:03:24 bluesbreaker kernel: [   61.552805] PGD 8063 PUD
> 9063 PMD 800000003bef11e3 BAD
> May  7 21:03:24 bluesbreaker kernel: [   61.552811] Oops: 0009 [1]
> PREEMPT
> May  7 21:04:18 bluesbreaker syslogd 1.4.1: restart.
>
>  After trying git-bisect, it tells me:
> 0dbf7028c0c1f266c9631139450a1502d3cd457e is first bad commit
> commit 0dbf7028c0c1f266c9631139450a1502d3cd457e
> Author: Vivek Goyal <vgoyal@in.ibm.com>
> Date:   Wed May 2 19:27:07 2007 +0200
>
>     [PATCH] x86: __pa and __pa_symbol address space separation
>
>     Currently __pa_symbol is for use with symbols in the kernel
> address
>     map and __pa is for use with pointers into the physical memory
> map.
>     But the code is implemented so you can usually interchange the
> two.
>
>     __pa which is much more common can be implemented much more
> cheaply
>     if it is it doesn't have to worry about any other kernel address
>     spaces.  This is especially true with a relocatable kernel as
>     __pa_symbol needs to peform an extra variable read to resolve
>     the address.
>
>  [snip the rest of the commit message on the resend]
> This time, I'll gzip the config in case it was a size problem for
> the list.

Please check the latest -git.

31 hours ago 	Linus Torvalds 	Revert "[PATCH] x86: __pa and
__pa_symbol address space ...

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e3ebadd95cb621e2c7436f3d3646447ac9d5c16d

>
> Ken
> --
> das eine Mal als Tragödie, das andere Mal als Farce
>
>

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
