Return-Path: <linux-kernel-owner+w=401wt.eu-S1765976AbXE2UOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765976AbXE2UOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 16:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbXE2UOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 16:14:39 -0400
Received: from dhazelton.dsl.enter.net ([216.193.185.50]:50673 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753973AbXE2UOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 16:14:38 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: "Nitin Gupta" <nitingupta910@gmail.com>
Subject: Re: [RFC] LZO de/compression support - take 6
Date: Tue, 29 May 2007 16:14:34 -0400
User-Agent: KMail/1.9.6
Cc: "Bret Towe" <magnade@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-mm-cc@laptop.org, linuxcompressed-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Richard Purdie" <richard@openedhand.com>,
       "Satyam Sharma" <satyam.sharma@gmail.com>
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com> <dda83e780705281553s67ace88at60f6ab28b198a832@mail.gmail.com> <4cefeab80705282258p570c649aja5a60b82f63c2440@mail.gmail.com>
In-Reply-To: <4cefeab80705282258p570c649aja5a60b82f63c2440@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705291614.34504.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 May 2007 01:58:43 Nitin Gupta wrote:
> On 5/29/07, Bret Towe <magnade@gmail.com> wrote:
> > tested this on ppc and its still good
> >
> > is there any reason to bother with a test on amd64?
> > if there is I might be able to get to it tonight
>
> Yes, this test is desired on 'take 6'
> (In future I will append version to patch bz2)
>
> Thanks,
> Nitin

I added a few functions to my test-bed to see how well the LZO code coped with 
random input data. I'll extend my error checking so that it dumps all local 
variables at the first error, but for the time being I'm staring at a problem 
with what appears to be a double-free (in addition to lzo1x_decompress(_safe) 
screaming about overruns when I pass it the buffer of compressed, totally 
random data).

(I fill the buffer by doing a read from /dev/urandom, though I'll certainly 
change it to use random() if anyone thinks that'll make a difference)

I'll post the version with the random-data tests when I get the double-free 
solved. (I've looked and don't see how its happening)

DRH
