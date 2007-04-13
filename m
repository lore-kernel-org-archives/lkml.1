Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbXDMNjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbXDMNjD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 09:39:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753988AbXDMNjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 09:39:03 -0400
Received: from ns.theshore.net ([67.18.92.50]:59441 "EHLO www.theshore.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753985AbXDMNjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 09:39:02 -0400
Message-ID: <461F87EC.7090609@theshore.net>
Date: Fri, 13 Apr 2007 09:38:52 -0400
From: "Christopher S. Aker" <caker@theshore.net>
User-Agent: Thunderbird 1.5.0.10 (Macintosh/20070221)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andi Kleen <andi@firstfloor.org>,
       "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [Feature Request?] Inline compression of process core dumps
References: <461E55C6.1030905@theshore.net>	<20070412172845.58bfeff5@the-village.bc.nu>	<20070412164251.GC11736@ti88.telemetry-investments.com>	<p73ps697agf.fsf@bingen.suse.de>	<461EE95A.3090600@theshore.net> <20070413133915.55cbf012@the-village.bc.nu>
In-Reply-To: <20070413133915.55cbf012@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Looking at the code, it seems to me that format_corename() is appending 
>> .pid, regardless if !core_uses_pid and corename[0]=='|', in which case 
>> it creates an invalid path for call_usermodehelper_pipe().
>>
>> Bug in the code, or bug in my methods?
> 
> This looks somewhat better and might do the trick. Also fixes a very very
> obscure security corner case. If you change core pattern to start with
> the program name then the user can run a program called "|myevilhack" as
> it stands. The patch checks for "|" in the pattern not the output and
> doesn't nail a pid on to a piped name.

<snip>

Works great now.  Queue this sucker up!

	# cat /proc/sys/kernel/core_pattern
	|/home/caker/bin/dumper.pl
	# ./linux
	<blah blah>
	Segmentation fault (core dumped)
	# file /tmp/dumper.out
	/tmp/dumper.out: ELF 32-bit LSB core file Intel 80386, version 1 
(SYSV), SVR4-style

Thanks for everyone's help.

-Chris

