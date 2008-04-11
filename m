Return-Path: <linux-kernel-owner+w=401wt.eu-S1760681AbYDKVbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760681AbYDKVbT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 17:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755240AbYDKVbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 17:31:10 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:2540 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088AbYDKVbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 17:31:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Syt8d8bxApj/1NWyeoC0+4F3+WW5ocffkDTcH+RO7Cve8LeS55Md8JQAeITBfYjV4IyBqXYhGyaWQO4Yy9I0QoRCkUg7yLZb0pOMUq63MPvfxJ+4TOl8rnaFs2u9tu6lbDnGskfFDLJytdzcMv0j/i5ndZubG7kBhvHkTI5WsLM=
Message-ID: <86802c440804111431i224b311gf8958f73e3447a92@mail.gmail.com>
Date: Fri, 11 Apr 2008 14:31:07 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: x86 git tree broken (bisected)
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Pavel Machek" <pavel@ucw.cz>,
       "Thomas Gleixner" <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <200804112321.53106.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804102159.14563.rjw@sisk.pl> <200804112251.09769.rjw@sisk.pl>
	 <86802c440804111411s74758aabm573de938371b11ce@mail.gmail.com>
	 <200804112321.53106.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 2:21 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> On Friday, 11 of April 2008, Yinghai Lu wrote:
>  > On Fri, Apr 11, 2008 at 1:51 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>  > >
>  > > On Friday, 11 of April 2008, Yinghai Lu wrote:
>  > >  > On Fri, Apr 11, 2008 at 12:26 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>  > >  > > On Friday, 11 of April 2008, Rafael J. Wysocki wrote:
>  > >  > >  > On Thursday, 10 of April 2008, Ingo Molnar wrote:
>  > >  > >  > >
>  > >  > >  > > * Ingo Molnar <mingo@elte.hu> wrote:
>  > >  > >  > >
>  > >  > >  > > > > > > First, the X server doesn't want to start (it says it couldn't
>  > >  > >  > > > > > > mmap the framebuffer).
>  > >  > >  > > > > >
>  > >  > >  > > > > > could you send your .config?
>  > >  > >  > > > >
>  > >  > >  > > > > Attached.
>  > >  > >  > > >
>  > >  > >  > > > could you disable this option:
>  > >  > >  > > >
>  > >  > >  > > >  CONFIG_NONPROMISC_DEVMEM=y
>  > >  > >  > > >
>  > >  > >  > > > does it help with the X problem?
>  > >  > >  >
>  > >  > >  > That didn't help.
>  > >  > >  >
>  > >  > >  > > btw., Xorg works fine here on a comparable AMD system - but i use a
>  > >  > >  > > rather new distro (Fedora 8) which has Xorg 7.2.
>  > >  > >  >
>  > >  > >  > My system is an OpenSUSE 10.3 and it has Xorg 7.2 as well.
>  > >  > >  >
>  > >  > >  > I think the problem is somehow related to the Radeon.
>  > >  > >
>  > >  > >  The bisection turned up commit ea1441bdf53692c3dc1fd2658addcf1205629661
>  > >  > >  "x86: use bus conf in NB conf fun1 to get bus range on, on 64-bit"  as the one
>  > >  > >  causing problems.
>  > >  > >
>  > >  > >  Unfortunately, I can't revert cleanly it, because there are two more commits
>  > >  > >  depending on it in a highly nontrivial fashion, so I have reverted all three
>  > >  > >  commits
>  > >  > >
>  > >  > >  a365998cd2cecfb827469dbd57c29602c106cb83
>  > >  > >  44f7f90fbe7a3a99aab082f765346514b7b5c705
>  > >  > >  ea1441bdf53692c3dc1fd2658addcf1205629661
>  > >  > >
>  > >  > >  and X starts again.  Also, suspend to RAM works from under X.
>  > >  >
>  > >  > please keep the three patches and applied the two attached debug patches.
>  > >  >
>  > >  > i wonder if there is some io allocation overlapping with your system.
>  > >
>  > >  Attached is a boot dmesg output from the current x86 git tree with your two
>  > >  patches applied.
>  > >
>  > can you put boot in your command line?
>
>  I'm not quite sure what you mean.
>
>  Can you please tell me what exactly you want me to do?

i got some hint. Will send you one patch to workaround the overlapping.

YH
