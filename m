Return-Path: <linux-kernel-owner+w=401wt.eu-S1758743AbZEFLFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743AbZEFLFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 07:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbZEFLFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 07:05:22 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33629 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbZEFLFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 07:05:21 -0400
Date: Wed, 6 May 2009 20:04:24 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: Swappiness vs. mmap() and interactive response
Cc: kosaki.motohiro@jp.fujitsu.com, Theodore Tso <tytso@mit.edu>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Peter Zijlstra <peterz@infradead.org>, Elladan <elladan@eskimo.com>,
       linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <2f11576a0904300459t61ae9619tcf8defacfc94f79@mail.gmail.com>
References: <20090429130430.4B11.A69D9226@jp.fujitsu.com> <2f11576a0904300459t61ae9619tcf8defacfc94f79@mail.gmail.com>
Message-Id: <20090506200413.7EBE.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > test environment: no lvm, copy ext3 to ext3 (not mv), no change swappiness,
> >         CFQ is used, userland is Fedora10, mmotm(2.6.30-rc1 + mm patch),
> >         CPU opteronx4, mem 4G
> >
> > mouse move lag:        not happend
> > window move lag:       not happend
> > Mapped page decrease rapidly: not happend (I guess, these page stay in
> >                     active list on my system)
> > page fault large latency:   happend (latencytop display >1200ms)
> >
> >
> > Then, I don't doubt vm replacement logic now.
> > but I need more investigate.
> > I plan to try following thing today and tommorow.
> >
> > - XFS
> > - LVM
> > - another io scheduler (thanks Ted, good view point)
> > - Rik's new patch
> 
> hm, AS io-scheduler don't make such large latency on my environment.
> Elladan, Can you try to AS scheduler? (adding boot option "elevator=as")

second test result:
read dev(sda): SSD, lvm+XFS
write dev(sdb): HDD, lvm+XFS

the result is the same of ext3 without lvm. Thus I think
XFS isn't guilty.



