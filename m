Return-Path: <linux-kernel-owner+w=401wt.eu-S1762171AbXF1OOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762171AbXF1OOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 10:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799AbXF1OOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 10:14:47 -0400
Received: from c-71-193-194-8.hsd1.or.comcast.net ([71.193.194.8]:34292 "EHLO
	laptopd505.fenrus.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752071AbXF1OOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 10:14:46 -0400
Subject: Re: New format Intel microcode...
From: Arjan van de Ven <arjan@linux.intel.com>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Daniel J Blueman <daniel.blueman@gmail.com>,
       Shaohua Li <shaohua.li@intel.com>, jamagallon@ono.com,
       tigran@aivazian.fsnet.co.uk,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4683BD56.7070707@tmr.com>
References: <6278d2220703221645j760a8816v4b8749ea2d60e493@mail.gmail.com>
	 <1174610594.6598.3.camel@sli10-conroe.sh.intel.com>
	 <6278d2220706261442u9b137c5xb6225b3f56605554@mail.gmail.com>
	 <p731wfy5m74.fsf@bingen.suse.de>  <4683BD56.7070707@tmr.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 28 Jun 2007 07:12:55 -0700
Message-Id: <1183039975.14676.12.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(while I work for Intel this is not an official Intel statement, but
there is so much FUD going around now that I feel I need to at least
point out a few things others "forget")
> > 
> Slashdot carried an article this morning saying that an error in Intel 
> microcode was being fixed.

don't just always believe everything you read on slashdot please

>  However, it listed only Windows related sites 
> for the "fix" download. Is this the same TLB issue? And are these really 
> fixes for Windows to flush the TLB properly the way Linux does?

First of all, Linux has microcode updates as well. Some of the more
hypish news-bulletins just conveniently "forgot" about this. Basically
all distributions ship them, so users who use the distro update tools
get these automatically. And the update mentioned has been shipping for
a while (in version 1.17).

Second, Intel really recommends always running the latest microcode.
(which is easy on Linux at least, and on Windows you can now see how
they do it). While reading the errata list may sound really scary, most
of the issues found and fixed are "lab finds" and are things operating
systems don't do. Some are more visible though; and since it's easy to
get the latest microcode (yum upgrade / apt-get upgrade / etc) you
probably are already running a recent one.

As for the TLB behavior; the Linux kernel is behaving correctly for
quite a while now as far as I know.. I wouldn't worry about it too much.
SMP tlb shootdown always has been tricky in the light of multiple cpus
having tlbs "hot" and active while tearing down mappings. 
(just think about it: cpu0 is accessing the memory while cpu1 is
removing it; until you flush the tlb on cpu0 it won't see the new
pagetable state since the tlb is a cache...)

