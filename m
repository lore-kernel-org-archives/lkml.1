Return-Path: <linux-kernel-owner+w=401wt.eu-S1754482AbZGTXrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbZGTXrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 19:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384AbZGTXri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 19:47:38 -0400
Received: from relais.videotron.ca ([24.201.245.36]:49720 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332AbZGTXrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 19:47:37 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Message-id: <4A650219.3060003@gmail.com>
Date: Mon, 20 Jul 2009 19:47:37 -0400
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
In-reply-to: <alpine.LFD.2.01.0907201504470.19335@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2009 06:08 PM, Linus Torvalds wrote:
>
> On Mon, 20 Jul 2009, Krzysztof Oledzki wrote:
>> No problem. Please let me know what should I do to help tracking this issue.
>
> Can you build two kernels: one with -fwrapv, and one with
> -fno-strict-overflow, and then verify that
>
>   - they are otherwise identical (ie exact same source code, same compiler
>     etc)
>
>   - verify that yes, the -fwrapv kernel works, the other does not. Just to
>     avoid the confusion that obviously exists with Debian/sid binutils
>     upgrades that _also_ happens result in nonbootable kernels.
>
>   - upload the 'vmlinux' images somewhere (I'm not sure what the limits for
>     binary attachments are at the kernel bugzilla, but that would be the
>     logical place)
>
> In fact, it would be nice to have a third "identical" kernel build, except
> with neither -fwrapv/-fno-strict-overflow.
>
> 			Linus

I might be seeing a slightly different bug, but in case it's helpful, 
the behaviour here on Fedora rawhide with gcc-4.4.0-14.x86_64 and 
binutils-2.19.51.0.11-27.fc12.x86_64 is that I get various .o files that 
come out as completely empty files (or in one case as a precisely 64K 
sized file that gives a "File format not recognized" error"), and the 
latest 2.6.31-rc git can't be built at all.

If I replace -fno-strict-overflow with -fwrapv in Makefile everything 
builds and runs fine.

Interestingly though, "-fno-strict-overflow -v" also gives me a good 
kernel, and comparing the assembly for one of the affected files doesn't 
show any difference between -fwrapv and -fno-strict-overflow.

Marc
