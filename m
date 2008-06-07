Return-Path: <linux-kernel-owner+w=401wt.eu-S933664AbYFGB3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933664AbYFGB3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761082AbYFGBKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:10:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36646 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761020AbYFGBKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:10:41 -0400
Message-ID: <4849E00E.5090206@firstfloor.org>
Date: Sat, 07 Jun 2008 03:10:38 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Scott Wiersdorf <scott@bluehost.com>
CC: Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, matt@bluehost.com
Subject: Re: [PATCH 2.6.25-4] getdelays.c: signal handling for log rotation
References: <20080605194334.GA56830@perlcode.org> <87d4muu0k2.fsf@basil.nowhere.org> <20080606204208.GB4283@perlcode.org>
In-Reply-To: <20080606204208.GB4283@perlcode.org>
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
> I believe it, but you can miss a lot of important stuff between STOP
> and CONT, especially on a busy system.

Do you have data on that or are you guessing?

I suspect the later, I'm sceptical of your claim. A lot of events
fit into the netlink socket buffer.

-Andi
