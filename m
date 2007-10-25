Return-Path: <linux-kernel-owner+w=401wt.eu-S1762372AbXJYUVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762372AbXJYUVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:21:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068AbXJYUUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:20:48 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:20201 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762723AbXJYUUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:20:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PzonHsZZqCZHF1+R3HYhDFKZ5F8+rlzCy5xzFQw1ECb8vXd34ByO3/3kBZ/TuTfDw8qlf/8Dl8PUt0A/p0v1+pb0MmzcREvZmAOsEMihceLV6w9F0/rZimwEy5iyVoY6TWd9p0TCx27K4hbIOJJcTD47pDIC24iaDHONEp8h5Kg=
Message-ID: <8bd0f97a0710251320m3490c53dpe85656a939e8536e@mail.gmail.com>
Date: Thu, 25 Oct 2007 16:20:20 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] blackfin: "extern inline" -> "static inline"
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Jie Zhang" <jzhang.linux@gmail.com>,
       bryan.wu@analog.com, linux-kernel@vger.kernel.org
In-Reply-To: <20071025201842.GT30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071024162643.GP30533@stusta.de>
	 <40401db90710241947i15e40e78v292e52f5229d9d35@mail.gmail.com>
	 <8bd0f97a0710242000h7b6c97e7ia3f461c69b7d5de5@mail.gmail.com>
	 <47200826.1060801@zytor.com> <20071025150545.GK30533@stusta.de>
	 <8bd0f97a0710250916v5d3f0166qbfacf4abb0fc3d45@mail.gmail.com>
	 <20071025165344.GL30533@stusta.de>
	 <8bd0f97a0710251307m9f45f4dmf6d8cfa93af9fdf5@mail.gmail.com>
	 <20071025201842.GT30533@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/07, Adrian Bunk <bunk@kernel.org> wrote:
> On Thu, Oct 25, 2007 at 04:07:45PM -0400, Mike Frysinger wrote:
> > On 10/25/07, Adrian Bunk <bunk@kernel.org> wrote:
> > > On Thu, Oct 25, 2007 at 12:16:40PM -0400, Mike Frysinger wrote:
> > > > On 10/25/07, Adrian Bunk <bunk@kernel.org> wrote:
> > > > > On Wed, Oct 24, 2007 at 08:06:14PM -0700, H. Peter Anvin wrote:
> > > > > > Mike Frysinger wrote:
> > > > > >> we'll have to either use the gcc attributes to force old inline
> > > > > >> behavior or use the gcc flag to force it
> > > > > >
> > > > > > We should probably have an extern_inline define then, assuming this is a
> > > > > > function that does exist in a linkable version already -- otherwise "static
> > > > > > inline" is correct.
> > > > >
> > > > > Since we #define inline to be __attribute__((always_inline))
> > > > > "extern inline" with the old semantics would only behave differently
> > > > > if someone took the address of one of these string functions.
> > > >
> > > > that isnt what we intended ;)
> > > >
> > > > > Does this happen anywhere in the blackfin port?
> > > >
> > > > gcc is also free to ignore the optimized inline in favor of an
> > > > external reference
> > >
> > > It is not since we #define inline to be __attribute__((always_inline)).
> >
> > as i said, that was not what we intended ... and actually,
> > always_inline does not mean always inline ... it is still possible to
> > get gcc to not inline things when building debug versions.
>
> Do you have any example for your claim "to get gcc to not inline things
> when building debug versions"?

$ cat test.c
__attribute__((always_inline)) int foo(void) { return 0; }
int main(void){ return foo(); }
$ gcc -g test.c -o test
$ readelf -s test | grep FUNC | grep -v _
    61: 00000000004004b8    11 FUNC    GLOBAL DEFAULT   13 foo
    68: 00000000004004c3    11 FUNC    GLOBAL DEFAULT   13 main

looks pretty straightforward to me
-mike
