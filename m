Return-Path: <linux-kernel-owner+w=401wt.eu-S1756066AbXE2NNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbXE2NNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 09:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbXE2NNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 09:13:37 -0400
Received: from keil-draco.com ([216.193.185.50]:50950 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751372AbXE2NNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 09:13:35 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: "Nitin Gupta" <nitingupta910@gmail.com>
Subject: Re: [RFC] LZO de/compression support - take 6
Date: Tue, 29 May 2007 09:13:30 -0400
User-Agent: KMail/1.9.6
Cc: "Adrian Bunk" <bunk@stusta.de>, "Michael-Luke Jones" <mlj28@cam.ac.uk>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm-cc@laptop.org,
       linuxcompressed-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Richard Purdie" <richard@openedhand.com>,
       "Bret Towe" <magnade@gmail.com>
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com> <20070529114043.GR3899@stusta.de> <4cefeab80705290503k70572e9bmc76e466c7967871b@mail.gmail.com>
In-Reply-To: <4cefeab80705290503k70572e9bmc76e466c7967871b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705290913.31043.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 May 2007 08:03:55 Nitin Gupta wrote:
> On 5/29/07, Adrian Bunk <bunk@stusta.de> wrote:
> > On Tue, May 29, 2007 at 09:08:27AM +0100, Michael-Luke Jones wrote:
> > > On 28 May 2007, at 18:11, Adrian Bunk wrote:
> > >> I have not seen any explanations:
> > >> - Why did the upstream author write the code that way?
> > >
> > > Apparently due to his requirement for extreme portability. The original
> > > code was designed to work on everything from 16-bit DOS through CRAY
> > > supercomputers through Windows, Unices and Linux.
> >
> > Sure, this could be the reason in some or all cases.
> >
> > The upstream author knows the code best, and discussing such issues with
> > him will in many cases be a win:
> >
> > It could be that there was in some cases no good reason, and the
> > upstream code that gets used by many other projects could become faster.
> >
> > Or there was a good reason that applies also to the in-kernel version
> > and a change breaks some corner case.
>
> I have mailed the author with detailed changelog - waiting for reply.
>
> > > The author has stated on the thread that it's a good idea to remove
> > > unnecessary ifdefs when porting the code into the kernel, given that
> > > the portability requirements are obviously no longer needed.
> >
> > "remove unnecessary ifdefs" implies "generated code is identical".
> >
> > That's quite different from "code is 10% faster".
>
> Daniel made some changes to his testing code and now the perf gain is just
> 1.6%.
>
> - Nitin

The changes for version 5 are all in one file - helpers.h. All I did was 
define the macros that had previously been NOP's. Most of the performance 
loss, IMHO, is due to the compression and decompression functions being 
marked noinline. The currently reported 1.6% overall performance boost is 
likely related to the use of likely()/unlikely().

DRH

