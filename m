Return-Path: <linux-kernel-owner+w=401wt.eu-S1758318AbZIQMmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318AbZIQMmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 08:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754281AbZIQMmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 08:42:46 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:38205 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191AbZIQMmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 08:42:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Z4S0nFr5JHuT+iDfoh2AEB10HhyMnpR2mOnW3kc2Rxr6l9j9eHyoSxfUW+o9RydrhP
         lmhdZqmod0/BCcrZOpse1JcsLveV7yly9dsb9GJDDe1WE6/oAifT4xJ2MtjpaTg9VB1n
         8drZIUfJzwTYBL74cxwrKMNQUn2JPmhMdfMu4=
MIME-Version: 1.0
In-Reply-To: <20090917123627.GP18404@wotan.suse.de>
References: <1253083059.5478.1.camel@penberg-laptop>
	 <20090917100841.GF13002@csn.ul.ie>
	 <1253183365.4975.20.camel@penberg-laptop>
	 <20090917105707.GA7205@csn.ul.ie>
	 <20090917121232.GA5041@osiris.boeblingen.de.ibm.com>
	 <1253189782.4975.51.camel@penberg-laptop>
	 <20090917122141.GB5041@osiris.boeblingen.de.ibm.com>
	 <20090917123627.GP18404@wotan.suse.de>
Date: Thu, 17 Sep 2009 15:42:47 +0300
X-Google-Sender-Auth: 59a9c1ca5109390f
Message-ID: <84144f020909170542g2377fdb1i460cb27a3b687825@mail.gmail.com>
Subject: Re: [RFC/PATCH] SLQB: Mark the allocator as broken PowerPC and S390
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nick Piggin <npiggin@suse.de>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, mingo@elte.hu, sachinp@in.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 3:36 PM, Nick Piggin <npiggin@suse.de> wrote:
> On Thu, Sep 17, 2009 at 02:21:41PM +0200, Heiko Carstens wrote:
>> On Thu, Sep 17, 2009 at 03:16:21PM +0300, Pekka Enberg wrote:
>> > On Thu, 2009-09-17 at 14:12 +0200, Heiko Carstens wrote:
>> > > Ok, I just wanted to debug this on s390. But... the bug seems to have
>> > > disappeared.
>> > > I pulled in
>> > >
>> > > git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git slqb/core
>> > >
>> > > and tried defconfig (+SLQB) as well as allyesconfig (+SLQB). Both started and
>> > > didn't show the crash-before-console-is-active which went away when switching
>> > > to a different allocator.
>> > > So the s390 restriction seems to be resolved. Don't know why...
>> >
>> > IIRC, this is the only bug fix that was merged after your report:
>> >
>> > http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff;h=ff61c4950125b09b5e5a83d48a6c81827e9d67ab
>>
>> Still works even if I revert that patch. Probably something else interfered.
>
> Nasty. I don't suppose it would be too much work to try bisecting it?
> Unfortunately with this kind of thing, bisecting doesn't always point
> to anything meaningful anyway :(

Bisecting won't work here because I rebased the branch to fix merge
conflicts and move the Kconfig and Makefile changes at the end of the
series to make sure SLQB won't break "git bisect". Blah, I guess I
shouldn't have do that. :-(

                        Pekka
