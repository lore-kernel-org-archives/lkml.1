Return-Path: <linux-kernel-owner+w=401wt.eu-S1757752AbXKASVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757752AbXKASVF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 14:21:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbXKASUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 14:20:55 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:3788 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbXKASUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 14:20:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=S1+pDyOWKUu/8NFHPcQ58bv95BJuMynAG5y87NDq20247y4WumT1kxIu0pEMVNPWHiD/vWmazCK8rjGN676mPxZ6Ul1DZ6wWYMd+QmVUxKKEM8MclpAqQ5A7en9yAw84e0WZzv2S3pI+E7BOiXfsfK2JlDePrQkglHTfpVpnEMs=
Message-ID: <64bb37e0711011120i63cdfe3ci18995d57b6649a8@mail.gmail.com>
Date: Thu, 1 Nov 2007 19:20:51 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Fengguang Wu" <wfg@mail.ustc.edu.cn>
Subject: Re: 100% iowait on one of cpus in current -git
Cc: "Maxim Levitsky" <maximlevitsky@gmail.com>,
       "Peter Zijlstra" <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <393903856.06449@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710220822.52370.maximlevitsky@gmail.com>
	 <200710221421.21439.maximlevitsky@gmail.com>
	 <393056632.00561@ustc.edu.cn>
	 <200710221505.35397.maximlevitsky@gmail.com>
	 <20071022131045.GA5357@mail.ustc.edu.cn> <393060478.03650@ustc.edu.cn>
	 <64bb37e0710310822r5ca6b793p8fd97db2f72a8655@mail.gmail.com>
	 <393903856.06449@ustc.edu.cn>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/1/07, Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> On Wed, Oct 31, 2007 at 04:22:10PM +0100, Torsten Kaiser wrote:
> > Since 2.6.23-mm1 I also experience strange hangs during heavy writeouts.
> > Each time I noticed this I was using emerge (package util from the
> > gentoo distribution) to install/upgrade a package. The last step,
> > where this hang occurred, is moving the prepared files from a tmpfs
> > partion to the main xfs filesystem.
> > The hangs where not fatal, after a few second everything resumed
> > normal, so I was not able to capture a good image of what was
> > happening.
>
> Thank you for the detailed report.
>
> How severe was the hangs? Only writeouts stalled, all apps stalled, or
> cannot type and run new commands?

Only writeout stalled. The emerge that was moving the files hung, but
everything else worked normaly.
I was able to run new commands, like coping the /proc/meminfo.

[snip]
> > After this SysRq+W writeback resumed again. Possible that writing
> > above into the syslog triggered that.
>
> Maybe. Are the log files on another disk/partition?

No, everything was going to /

What might be interesting is, that doing cat /proc/meminfo
>~/stall/meminfo did not resume the writeback. So there might some
threshold that only was broken with the additional write from
syslog-ng. Or syslog-ng does some flushing, I dont now. (I'm using the
syslog-ng package from gentoo:
http://www.balabit.com/products/syslog_ng/ , version 2.0.5)

> > The source tmpfs is mounted with any special parameters, but the
> > target xfs filesystem resides on a dm-crypt device that is on top a 3
> > disk RAID5 md.
> > During the hang all CPUs where idle.
>
> No iowaits? ;-)

No, I have a KSysGuard in my taskbar that showed no activity at all.

OK, the subject does not match for my case, but there was also a tmpfs
involved. And I found no thread with stalls on xfs. :-)

> > The system is x86_64 with CONFIG_NO_HZ=y, but was still receiving ~330
> > interrupts per second because of the bttv driver. (But I was not using
> > that device at this time.)
> >
> > I'm willing to test patches or more provide more information, but lack
> > a good testcase to trigger this on demand.
>
> Thank you. Maybe we can start by the applied debug patch :-)

Will applied it and try to recreate this.

Thanks for looking into it.

Torsten
