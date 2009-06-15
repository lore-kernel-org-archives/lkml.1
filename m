Return-Path: <linux-kernel-owner+w=401wt.eu-S1758481AbZFON45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758481AbZFON45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 09:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbZFON4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 09:56:49 -0400
Received: from xsmtp1.ethz.ch ([82.130.70.13]:15205 "EHLO xsmtp1.ethz.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbZFON4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 09:56:48 -0400
X-Greylist: delayed 912 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Jun 2009 09:56:48 EDT
Message-ID: <4A364F90.7080807@debian.org>
Date: Mon, 15 Jun 2009 15:41:36 +0200
From: "Giacomo A. Catenazzi" <cate@debian.org>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Performance Counters for Linux
References: <20090611160329.GA3366@elte.hu> <20090611161714.GA5008@infradead.org> <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain> <20090611185049.GB7658@uranus.ravnborg.org>
In-Reply-To: <20090611185049.GB7658@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jun 2009 13:41:37.0164 (UTC) FILETIME=[013644C0:01C9EDBF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Thu, Jun 11, 2009 at 09:26:55AM -0700, Linus Torvalds wrote:
>>
>> On Thu, 11 Jun 2009, Christoph Hellwig wrote:
>>> Err, no.   This adds tons of userspace code into tools/ which
>>> should not be in the kernel tree but a proper package.
>> I disagree.
>>
>> We've had tons of cases where we tried to "separate" the user-land code 
>> and the kernel code, in the name of "beauty" of whatever.
>>
>> It's almost invariably a disaster.
> 
> This is cheating. I had this as a topic for the kernel summit and
> was looking forward to read an interesting article about people
> dancing on the table and fighting in the corners about it.
> [I do not attend myself]
> 
> People say that this would be a nightmare for the packagers.
> I frankly do not see what the issue is here.

Kernels don't fit well in distribution models.
We have distribution since 15 (and more) years, but still with
hackish support for kernels.

Kernel:
- people are used to install multiple "parallel" kernels
- from different sources (distribution, kernel.org)
- and a lot of people configure own kernel

This is a lot different of usual packages:
- packages have dependencies (done at pre-installation time)
- packages normally support only upgrades (and not downgrades)
- support for multiple version exist only on libraries (SONAME)

Thus a program could depends on specific version of the libc,
but it cannot depends on a specific kernel (system doesn't know
the kernel of next boot), which requires a lot of hack in init.d
scripts.

BTW one of the most frequent question on distribution was
about configuring the kernel and the error about missing
lib[n]curse[X]-dev[el].

So the 15 year without finding a good solution could explains the
nightmare, (but it could be finally the opportunity to really
solve the problem).

To conclude: a user space program should not only have a stable
ABI, but also have nice messages about unsupported features
(and wrong kernel) and not changing runtime dependencies like
socks.

ciao
	cate
