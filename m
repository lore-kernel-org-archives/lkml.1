Return-Path: <linux-kernel-owner+w=401wt.eu-S1754523AbZGTX6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbZGTX6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 19:58:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbZGTX6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 19:58:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751583AbZGTX6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 19:58:07 -0400
Date: Mon, 20 Jul 2009 16:56:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Marc Dionne <marc.c.dionne@gmail.com>
cc: Krzysztof Oledzki <olel@ans.pl>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.27.27
In-Reply-To: <4A650219.3060003@gmail.com>
Message-ID: <alpine.LFD.2.01.0907201650570.19335@localhost.localdomain>
References: <20090720040655.GA11940@kroah.com> <4A645A45.9060509@ans.pl> <20090720151008.GC10015@suse.de> <alpine.LFD.2.01.0907200848530.13838@localhost.localdomain> <alpine.LNX.1.10.0907202341580.29729@bizon.gios.gov.pl> <alpine.LFD.2.01.0907201504470.19335@localhost.localdomain>
 <4A650219.3060003@gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 20 Jul 2009, Marc Dionne wrote:
> 
> I might be seeing a slightly different bug, but in case it's helpful, the
> behaviour here on Fedora rawhide with gcc-4.4.0-14.x86_64 and
> binutils-2.19.51.0.11-27.fc12.x86_64 is that I get various .o files that come
> out as completely empty files (or in one case as a precisely 64K sized file
> that gives a "File format not recognized" error"), and the latest 2.6.31-rc
> git can't be built at all.

Hmm. This sounds more like the binutils bug that people had. Sounds like 
an assembler bug if the *.o file ends up being empty or at some fixed 
size. If it was cc1 that fails, I'd expect to not see an *.o file at all, 
since it didn't generate good assembly.

In fact, your behavior sounds like the thing that produces the *.o files 
core-dumped or died for other reasons, and had a 64kB buffer that either 
got flushed or not. That would explain the "zero or exactly 64kB" size.

It could be ccache too, of course. 

> If I replace -fno-strict-overflow with -fwrapv in Makefile everything builds
> and runs fine.

.. and this is just really really odd. If it was the cc1 front-end that 
does that with a bad optimization, I'd expect more visible turds. But on 
the other hand, if it's the binutils, then I don't see why -fwrapv would 
matter. Some front-end options get passed down to the assembler, but I 
would definitely not expect -fwrapv/-fno-strict-overflow to be one of 
those.

		Linus
