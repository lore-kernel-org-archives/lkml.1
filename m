Return-Path: <linux-kernel-owner+w=401wt.eu-S1030959AbXDXAdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030959AbXDXAdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 20:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030962AbXDXAdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 20:33:44 -0400
Received: from terminus.zytor.com ([192.83.249.54]:50415 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030959AbXDXAdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 20:33:43 -0400
Message-ID: <462D4FE1.5040406@zytor.com>
Date: Mon, 23 Apr 2007 17:31:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
       Eric Hopper <hopper@omnifarious.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Question about Reiser4
References: <462C4858.3050006@redhat.com> <Pine.LNX.4.64.0704230555020.25153@server.thyself> <462C4D32.4000909@redhat.com> <Pine.LNX.4.64.0704230611430.25153@server.thyself> <462C5034.9090403@redhat.com> <Pine.LNX.4.64.0704230640540.25153@server.thyself> <20070423010445.454eda63.akpm@linux-foundation.org> <20070423135216.GA2744@omnifarious.org> <20070423225640.GA1663@thunk.org> <462D46DF.4090802@zytor.com> <20070424001934.GC1663@thunk.org>
In-Reply-To: <20070424001934.GC1663@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
>>>
>> Now, to be fair, there are probably a number of cases where 
>> open/lseek/readv/close and open/lseek/writev/close would be worth doing 
>> as a single system call.  The big problem as far as I can see involves 
>> EINTR handling; such a system call has serious restartability implications.
> 
> Sure, but Hans wants to change /etc/inetd.conf into /etc/inetd.conf.d,
> where you have: /etc/inetd.conf.d/telnet/port,
> /etc/inetd.conf.d/telnet/protocol, /etc/inetd.conf.d/telnet/wait,
> /etc/inetd.conf.d/telnet/userid, /etc/inetd.conf.d/telnet/daemon,
> etc. for each individual line in /etc/inetd.conf.  (And where each
> file might only contains 2-4 characters each: i.e., "23", "tcp",
> "root", etc.)
> 
> So it's not enough just to collapse open/pread/close into a single
> system call; in order to gain back the performance squandered by all
> of these itsy-bitsy tiny little files.  You want to collapse the
> open/pread/close for many of these little files into a single system
> call, hence Hans's insistence on sys_reiser4(); otherwise his scheme
> doesn't work all that well at all.
> 

Heh.  sys_read_tree() -- walk a directory tree and return it as a data 
structure in memory :)

	-hpa
