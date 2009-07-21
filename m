Return-Path: <linux-kernel-owner+w=401wt.eu-S1751532AbZGUAhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532AbZGUAhz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 20:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbZGUAhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 20:37:54 -0400
Received: from relais.videotron.ca ([24.201.245.36]:56578 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbZGUAhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 20:37:53 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Message-id: <4A650DE1.20105@gmail.com>
Date: Mon, 20 Jul 2009 20:37:53 -0400
From: Marc Dionne <marc.c.dionne@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre)
 Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Krzysztof Oledzki <olel@ans.pl>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.27.27
References: <20090720040655.GA11940@kroah.com> <4A645A45.9060509@ans.pl>
 <20090720151008.GC10015@suse.de>
 <alpine.LFD.2.01.0907200848530.13838@localhost.localdomain>
 <alpine.LNX.1.10.0907202341580.29729@bizon.gios.gov.pl>
 <alpine.LFD.2.01.0907201504470.19335@localhost.localdomain>
 <4A650219.3060003@gmail.com>
 <alpine.LFD.2.01.0907201650570.19335@localhost.localdomain>
In-reply-to: <alpine.LFD.2.01.0907201650570.19335@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2009 07:56 PM, Linus Torvalds wrote:
>
> On Mon, 20 Jul 2009, Marc Dionne wrote:
>> I might be seeing a slightly different bug, but in case it's helpful, the
>> behaviour here on Fedora rawhide with gcc-4.4.0-14.x86_64 and
>> binutils-2.19.51.0.11-27.fc12.x86_64 is that I get various .o files that come
>> out as completely empty files (or in one case as a precisely 64K sized file
>> that gives a "File format not recognized" error"), and the latest 2.6.31-rc
>> git can't be built at all.
>
> Hmm. This sounds more like the binutils bug that people had. Sounds like
> an assembler bug if the *.o file ends up being empty or at some fixed
> size. If it was cc1 that fails, I'd expect to not see an *.o file at all,
> since it didn't generate good assembly.
>
> In fact, your behavior sounds like the thing that produces the *.o files
> core-dumped or died for other reasons, and had a 64kB buffer that either
> got flushed or not. That would explain the "zero or exactly 64kB" size.
>
> It could be ccache too, of course.

Actually in my case it turns out that it is ccache after all - if I 
remove it from the picture everything is fine.  If I re-enable it, even 
with a clean cache, I get the problem.

It might just be a coincidence that it's triggered by the -fwrapv change.

Marc
