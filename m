Return-Path: <linux-kernel-owner+w=401wt.eu-S1754909AbYH1ETu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbYH1ETu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 00:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbYH1ETl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 00:19:41 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:41321 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751127AbYH1ETk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 00:19:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=nCwtqxeiYdgFbz+GSH0a0XEpsG187eM5SVY0X2sVYpvRaeu+1w7S3n5ZJYg65368uPJIh2vUW0y3IL0uFmmbBFW9cAyKuEDvKxwsPUKbVZFXU90KtjxeL9BD8tH4LS0KHhAkL6Da6gt1tBO3kj4SLUxyw/OK68xFcMrma8YFbVY=  ;
X-YMail-OSG: htXy.SMVM1mMG9AChryFUS.z3aMGb_hvRF_nmMSjbDJB1Jl8.hv4XEFPyTc6zr_KTCIgkUa1jOnxnpEYU3NSOGQ_a2xKM1RD9tQRQGouUPDIwgNUSjO2nIeWrkjYGwSw8q8QXQ.E4lzi4.RhTChtvZOo
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -V3 01/11] percpu_counters: make fbc->count read atomic on 32 bit architecture
Date: Fri, 29 Aug 2008 00:19:32 +1000
User-Agent: KMail/1.9.5
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, cmm@us.ibm.com,
       tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
References: <1219850916-8986-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080828034816.GA6440@skywalker> <20080827210652.dcbe5ff4.akpm@linux-foundation.org>
In-Reply-To: <20080827210652.dcbe5ff4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808290019.32744.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 August 2008 14:06, Andrew Morton wrote:
> On Thu, 28 Aug 2008 09:18:16 +0530 "Aneesh Kumar K.V" 
<aneesh.kumar@linux.vnet.ibm.com> wrote:
> > > This is now too large to be inlined.
> >
> > How do we actually figure that out ? I have been making that mistakes
> > quiet often.
>
> Well.  Experience and guesswork, mainly.
>
> But a useful metric is to look and the /bin/size output before and
> after the inlining.  In this case fs/ext3/ialloc.o's text shrunk 40-odd
> bytes, which we think is a net benefit due to reduced CPU cache
> pressure.

Weighed against register save/restore, compiler barrier, and function
call cost of uninlined. These can add up to 10s of cycles per call I've
seen, so if it is called several times between each icache miss it can
easily be worth inlining. Basically, measurement is required, and if it
isn't important enough to measure policy tends to default to uninline if
that saves space.
