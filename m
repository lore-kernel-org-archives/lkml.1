Return-Path: <linux-kernel-owner+w=401wt.eu-S1762734AbYFGBao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762734AbYFGBao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762080AbYFGBNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:13:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:32892 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761824AbYFGBNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:13:04 -0400
Message-ID: <4849E09D.6090804@firstfloor.org>
Date: Sat, 07 Jun 2008 03:13:01 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Scott Wiersdorf <scott@bluehost.com>
CC: Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, matt@bluehost.com
Subject: Re: [PATCH 2.6.25-4] getdelays.c: signal handling for log rotation
References: <20080605194334.GA56830@perlcode.org> <87d4muu0k2.fsf@basil.nowhere.org> <20080606204704.GA4330@perlcode.org>
In-Reply-To: <20080606204704.GA4330@perlcode.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott Wiersdorf wrote:
> On Fri, Jun 06, 2008 at 03:59:09PM +0200, Andi Kleen wrote:
>> Scott Wiersdorf <scott@perlcode.org> writes:
>>
>>> This adds a USR1 signal handler to getdelays.c, which causes getdelays
>>> to close its logfile and reopen it (if '-w logfile' is
>>> specified). This is useful in situations when getdelays is running for
>>> a long time (i.e, the log file growing) and you need to rotate the
>>> logs but don't want to lose any log data.
>> You could do the same by sending SIGSTOP; copy file; truncate file; SIGCONT
> 
> Actually, I was wrong in my previous reply. Sorry for my error. The
> above will work fine (no data loss; I guess the data queues somewhere
> in some magic way?)

netlink has a socket buffer like all other buffer. I think it's around
128K.

> I still think a single handler is elegant enough though, and works
> better with many log rotation systems that want to send a single
> signal to a pid (it's what we need where I'm working now, hence the
> patch).

Well in general it would be cool if there was nicer free userland for
the obscure but useful delay accounting. The code in Documentation
is really not much more than a example. Do you have something downloadable?

-Andi

