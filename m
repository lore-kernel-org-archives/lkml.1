Return-Path: <linux-kernel-owner+w=401wt.eu-S1755634AbYDMISu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbYDMISu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 04:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbYDMISg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 04:18:36 -0400
Received: from rv-out-0708.google.com ([209.85.198.247]:36039 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751444AbYDMISb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 04:18:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=B9BEk/ReIsFXaM4Uap98lGBOjRbw8goxHiK4eV0w4uYaEZnjUPzJMv1XBs8VxGmA1OUQEul7CgMa+k6e0cDSXRROZLZe5K8v9M4NjmRDWcpmCNOexjW8jiFZ5nVi0FyHvQCm3+3ooaaaR7s2QZzaRsgMKzJYkTmXWxGhxr51kVM=
Message-ID: <86802c440804130118n669db8d1rf37551550955a084@mail.gmail.com>
Date: Sun, 13 Apr 2008 01:18:30 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [rfc] hw resource debugging checks (was: Re: x86 git tree broken (bisected))
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Pavel Machek" <pavel@ucw.cz>,
       "Thomas Gleixner" <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>
In-Reply-To: <20080413075845.GJ20332@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804102159.14563.rjw@sisk.pl> <20080410203800.GA14560@elte.hu>
	 <200804110028.22290.rjw@sisk.pl> <200804112126.29455.rjw@sisk.pl>
	 <20080413075845.GJ20332@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2008 at 12:58 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
>  > > > btw., Xorg works fine here on a comparable AMD system - but i use
>  > > > a rather new distro (Fedora 8) which has Xorg 7.2.
>  > >
>  > > My system is an OpenSUSE 10.3 and it has Xorg 7.2 as well.
>  > >
>  > > I think the problem is somehow related to the Radeon.
>  >
>  > The bisection turned up commit
>  > ea1441bdf53692c3dc1fd2658addcf1205629661 "x86: use bus conf in NB conf
>  > fun1 to get bus range on, on 64-bit" as the one causing problems.
>
>  thanks Rafael for bisecting this!
>
>  This was a rather nasty problem - and i'm wondering what else we could
>  do to harden our hw resource management code. I'm wondering, is there
>  any particular reason why clearly broken resource setup is not detected
>  somewhere, automatically, and WARN_ON()-ed about?
>
>  for example, in the scheduler code we used to have similar bug patterns
>  again and again: architecture code set up scheduler domains incorrectly
>  and broke the system in subtle ways. So we added sched_domain_debug()
>  which is active under CONFIG_SCHED_DEBUG=y and does a few sanity checks
>  and complains if something is wrong. This caught quite a few bugs
>  whenever the sched-domains code was modified.
>
>         Ingo

there is silicon abut about agp bridge aperture order reading...
=====> just sent out one patch to work around that

also BIOS is sick to allocate overlapping MMIO to the same link..

node 0 link 0: io port [1000, ffffff]
TOM: 0000000080000000 aka 2048M
node 0 link 0: mmio [e0000000, efffffff]
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [80000000, ffffffff]
bus: [00,ff] on node 0 link 0

never thought that BIOS could be so sick.
 ===> already have one work around, need more test next week.

YH
