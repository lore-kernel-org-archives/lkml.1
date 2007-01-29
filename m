Return-Path: <linux-kernel-owner+w=401wt.eu-S1752537AbXA2T1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbXA2T1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 14:27:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbXA2T1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 14:27:13 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:58385 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752537AbXA2T1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 14:27:12 -0500
Date: Mon, 29 Jan 2007 14:27:07 -0500
To: Paul Fulghum <paulkf@microgate.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Strange problem with tty layer
Message-ID: <20070129192707.GE7584@csclub.uwaterloo.ca>
References: <20070124204009.GA7584@csclub.uwaterloo.ca> <45B7CDB5.7020909@microgate.com> <20070125151639.GH7582@csclub.uwaterloo.ca> <20070126142041.GD7584@csclub.uwaterloo.ca> <45BA1556.8080808@microgate.com> <20070126145608.GK7582@csclub.uwaterloo.ca> <45BA190C.5040300@microgate.com> <20070126160842.GM7582@csclub.uwaterloo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070126160842.GM7582@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 26, 2007 at 11:08:42AM -0500, Lennart Sorensen wrote:
> OK, the tty settings according to stty that I am using are:
> # stty -F /dev/ttyn0 -a
> speed 230400 baud; rows 0; columns 0; line = 0;
> intr = ^C; quit = ^\; erase = ^?; kill = ^U; eof = ^D; eol = <undef>; eol2 = <undef>; start = ^Q; stop = ^S; susp = ^Z; rprnt = ^R;
> werase = ^W; lnext = ^V; flush = ^O; min = 1; time = 0;
> -parenb -parodd cs8 hupcl -cstopb cread clocal -crtscts
> -ignbrk -brkint -ignpar -parmrk -inpck -istrip -inlcr -igncr icrnl -ixon -ixoff -iuclc -ixany -imaxbel
> -opost -olcuc -ocrnl onlcr -onocr -onlret -ofill -ofdel nl0 cr0 tab0 bs0 vt0 ff0
> -isig -icanon iexten -echo -echoe echok -echonl -noflsh -xcase -tostop -echoprt echoctl echoke
> 
> So min and time seems good.  I am not explicitly setting those in my
> test program (unless one of the other settings implies it).  I will add
> it explicitly just in case too.

I have run some tests with 8 patches from Linus's 2.6 tree on top of the
2.6.16.25 along with a bit of debug code in the n_tty.c, which ran
perfectly for 3 days.  I now removed the debug code to see if it will
still run perfectly with those 8 patches.  The patches I applied in
order are:

commit 70522e121a521aa09bd0f4e62e1aa68708b798e1
commit 41c28ff1635e71af072c4711ff5fadd5855d48e7
commit 1aef821a6b3aeca8c19d06aee012ed9db617d1e3
commit ee37df7877eeaa16d7761cce64854110a7c17ad9
commit e1a2509023785bd3199ac068ab80155aeba01265
commit 817d6d3bceaf34c99f5343820f9b9e6021f0655c
commit 2c3bb20f46709a0adfa7ea408013edbcab945d5a
commit 33b37a33c242542fac2980b8ccd90977388b7a8d

Hopefully it will stay working, and actually be a solution to my tty
problem in 2.6.16.25.

2.6.18.2 (Debian 2.6.18-4) on the other hand was still broken, but I am
not sure which if any of the above commits are not in that version (the
date ranges made me think they all should be, but maybe I got the date
of 2.6.18 wrong, or not all commits in the linux-2.6 tree are actually
part of a given release.  I am still figuring out git).

--
Len Sorensen
