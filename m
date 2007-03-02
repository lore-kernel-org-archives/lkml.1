Return-Path: <linux-kernel-owner+w=401wt.eu-S2992543AbXCBQEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992543AbXCBQEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 11:04:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992554AbXCBQEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 11:04:42 -0500
Received: from mail.daysofwonder.com ([213.186.49.53]:52516 "EHLO
	mail.daysofwonder.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992543AbXCBQEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 11:04:40 -0500
Subject: Re: [RFC][PATCH 0/3] VM throttling: avoid blocking
	occasional	writers
From: Brice Figureau <brice+lklm@daysofwonder.com>
To: Leroy van Logchem <leroy.vanlogchem@wldelft.nl>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <loom.20070302T140036-942@post.gmane.org>
References: <45DED819.9040404@hitachi.com>
	 <17888.14958.85897.289141@gargle.gargle.HOWL>
	 <45E380DA.6090509@hitachi.com>   <loom.20070301T133046-12@post.gmane.org>
	 <1172826980.9640.13.camel@localhost.localdomain>
	 <loom.20070302T140036-942@post.gmane.org>
Content-Type: text/plain
Date: Fri, 02 Mar 2007 17:04:36 +0100
Message-Id: <1172851477.9640.26.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2007-03-02 at 13:06 +0000, Leroy van Logchem wrote:
> > I'm sorry to piggy-back this thread.
> > 
> > Could it be what I'm experiencing in the following bugzilla report:
> > http://bugzilla.kernel.org/show_bug.cgi?id=7372
> > 
> > As I explained in the report, I see this issue only since 2.6.18.
> > So if your concern is related to mine, what could have changed between
> > 2.6.17 and 2.6.18 related to this?
> 
> I don't think it's 2.6.x related, it's been under the sheets from start.

Maybe. Still the issue has been aggravated between 2.6.17 and 2.6.18.
Right now (running 2.6.17.13) I can backup and do whatever I want, even
with high memory pressure because of mysql (which is consumming right
now about 3.8GB of 4GB).

Under 2.6.18 and later it is simply impossible to perform that (except
with the dd directIO trick).
This makes me think that something else has joined the party on
2.6.18...

> Related to your problem in the 7372 bug:
> 
> Pages are kept in memory for re-use, which is fast and fine except for:
> 1) data without re-use value or even single use
> 2) applications _do not_ advise the kernel how to cache pages related
>    to there self generated i/o. POSIX does provide mechanisms to
>    properly do so. But the kernel should help these poor apps.
>
> To minimize your MySQL backup cp(1) problem, try this workaround:
> 
> cat ./cp_direct.sh 
> #!/bin/sh
> dd if=$1 of=$2 bs=1M iflag=direct oflag=direct

Yes, I already did this, and it helped, see:
http://bugzilla.kernel.org/show_bug.cgi?id=7372#c16

> Combine this with [/etc/sysctl.conf]:
> 
> vm.vfs_cache_pressure = 1
> vm.dirty_ratio = 2
> vm.dirty_background_ratio = 1
> 
> This should reduce both the stress on the vm and response latency during
> interactive work.

I'll test the vfs_cache_pressure (I was already using those dirty_*
settings) whenever I'll reboot the server to 2.6.20.

Please CC: me on list replies as I'm not subscribed to the list.

Thanks for the tips.
Regards
-- 
Brice Figureau <brice+lklm@daysofwonder.com>

