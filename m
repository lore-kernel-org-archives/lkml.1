Return-Path: <linux-kernel-owner+w=401wt.eu-S1756391AbXLUG37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391AbXLUG37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 01:29:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbXLUG3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 01:29:52 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40398 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750740AbXLUG3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 01:29:51 -0500
Date: Thu, 20 Dec 2007 22:29:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Miles Lane" <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Christoph Lameter" <clameter@sgi.com>, "Pavel Machek" <pavel@suse.cz>,
       linux-pm@lists.linux-foundation.org
Subject: Re: OOPS: 2.6.24-rc5-mm1 -- EIP is at r_show+0x2a/0x70 --
 (triggered by "cat /proc/iomem" AFTER suspend-to-disk/resume)
Message-Id: <20071220222913.92a2c19f.akpm@linux-foundation.org>
In-Reply-To: <a44ae5cd0712202158u31c8b4e1lf5b0df89dde20e7e@mail.gmail.com>
References: <a44ae5cd0712192040k7480682eoa29f33d70a91c618@mail.gmail.com>
	<4769F409.6030300@gmail.com>
	<4769FF37.5060308@gmail.com>
	<476A703B.50804@gmail.com>
	<20071220093206.22f319b0.akpm@linux-foundation.org>
	<a44ae5cd0712202158u31c8b4e1lf5b0df89dde20e7e@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2007 00:58:19 -0500 "Miles Lane" <miles.lane@gmail.com> wrote:

> On Dec 20, 2007 12:32 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Thu, 20 Dec 2007 08:38:03 -0500 Miles Lane <miles.lane@gmail.com>
> > wrote:
> >
> > > On further investigation, "cat /proc/iomem" does not trigger the stack
> > > trace until after a suspend-to-disk/resume cycle has occurred.
> >
> > I still can't reproduce this.
> >
> > Could you please try this?
> >
> > - cat /proc/iomem
> > - suspend/resume
> > - do
> >
> > while read i
> > do
> > echo $i
> > sleep 1
> > done < /proc/iomem
> >
> > then, with luck, we'll be able to work out which /proc/iomem record
> > immediately precedes the corrupted one.
> >
> 
> miles@syntropy:~$ cat > test.sh
> while read i
> do
> echo $i
> sleep 1
> done < /proc/iomem
> ^C
> miles@syntropy:~$ sh test.sh
> 00000000-0009f7ff : System RAM
> 0009f800-0009ffff : reserved
> 000a0000-000bffff : Video RAM area
> 000c0000-000c7fff : Video ROM
> 000f0000-000fffff : System ROM
> 00100000-7f68ffff : System RAM
> 00100000-0039e4b7 : Kernel code
> 0039e4b8-004f0983 : Kernel data
> 00553000-007ecdfb : Kernel bss
> 7f690000-7f698fff : ACPI Tables
> 7f699000-7f6fffff : ACPI Non-volatile Storage
> 7f700000-7fffffff : reserved
> 88000000-8bffffff : PCI CardBus #05
> 8c000000-8fffffff : PCI CardBus #05
> Segmentation fault
> 
> How do I determine what comes next?
> 

By comparing it with the /proc/iomem from prior to suspending the machine.
