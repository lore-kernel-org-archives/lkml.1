Return-Path: <linux-kernel-owner+w=401wt.eu-S933318AbXEVKPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318AbXEVKPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 06:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757790AbXEVKPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 06:15:31 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:17069 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757476AbXEVKPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 06:15:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ptN8BmoFCu9SHx1/S38zs/2Pje1pelfB2SGrz2VMWb3TXd7CGpp9UvDpaC9Kdcvra9wj3ZPjJiXZ7uRYgG0tmEz2eWtz+m44vrH25CrPbVCbWbTU1iAV8sct5ah7EP0Fyy1aNF9xgmzt1RQX5PoVduOpj1ryPemBT7254jgYcxQ=
Message-ID: <5486cca80705220315oe4a42a2x366cff682333075c@mail.gmail.com>
Date: Tue, 22 May 2007 12:15:30 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] mm: swap prefetch improvements
Cc: "Con Kolivas" <kernel@kolivas.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Ray Lee" <ray-lk@madrabbit.org>, "ck list" <ck@vds.kolivas.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20070521160029.GA28715@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	 <200705121446.04191.kernel@kolivas.org>
	 <20070521100320.GA1801@elte.hu>
	 <200705212344.27511.kernel@kolivas.org>
	 <20070521160029.GA28715@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/5/21, Ingo Molnar <mingo@elte.hu>:
>
> * Con Kolivas <kernel@kolivas.org> wrote:
>
> > > A suggestion for improvement: right now swap-prefetch does a small
> > > bit of swapin every 5 seconds and stays idle inbetween. Could this
> > > perhaps be made more agressive (optionally perhaps), if the system
> > > is not swapping otherwise? If block-IO level instrumentation is
> > > needed to determine idleness of block IO then that is justified too
> > > i think.
> >
> > Hmm.. The timer waits 5 seconds before trying to prefetch, but then
> > only stops if it detects any activity elsewhere. It doesn't actually
> > try to go idle in between but it doesn't take much activity to put it
> > back to sleep, hence detecting yet another "not quite idle" period and
> > then it goes to sleep again. I guess the sleep interval can actually
> > be changed as another tunable from 5 seconds to whatever the user
> > wanted.
>
> there was nothing else running on the system - so i suspect the swapin
> activity flagged 'itself' as some 'other' activity and stopped? The
> swapins happened in 4 bursts, separated by 5 seconds total idleness.

I've noted burst swapins separated by some seconds of pause in my
desktop system too (with sp_tester and an idle gnome).


Regards,

    ~ Antonio
