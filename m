Return-Path: <linux-kernel-owner+w=401wt.eu-S1759443AbXEWNqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759443AbXEWNqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 09:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755337AbXEWNqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 09:46:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:14162 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150AbXEWNqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 09:46:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Uf4jQtum5X/V9ZWYIY0zv6FozU7+nLV0J4cx5iV7fZNKPbIGqvPsRxct0TK3o0tuXbZ4jn5ix1ezBJuxPRqb4HTPG9ixfle5j87ibWmatXW5uE4goFMNeOEvvKibHAHEC9gHppJicQzTQbWnKrMaDZVuz0VyztpNfceUOZ2Bcdo=
Message-ID: <a781481a0705230646x9a0255ak4254d05ba5442cad@mail.gmail.com>
Date: Wed, 23 May 2007 19:16:24 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: any value to "NORET_TYPE" macro?
Cc: "Krzysztof Halasa" <khc@pm.waw.pl>, "Adrian Bunk" <bunk@stusta.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0705230908180.4309@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0705220904320.13623@localhost.localdomain>
	 <20070522135927.GA2098@stusta.de>
	 <Pine.LNX.4.64.0705221002350.14457@localhost.localdomain>
	 <20070522161951.GC2098@stusta.de> <m3ejl8k6e3.fsf@maximus.localdomain>
	 <Pine.LNX.4.64.0705221616270.18792@localhost.localdomain>
	 <m37ir0iodl.fsf@maximus.localdomain>
	 <a781481a0705230137v4c8ba82fx263212a2958b55b9@mail.gmail.com>
	 <Pine.LNX.4.64.0705230908180.4309@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

On 5/23/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> On Wed, 23 May 2007, Satyam Sharma wrote:
>
> > On 5/23/07, Krzysztof Halasa <khc@pm.waw.pl> wrote:
> > > "Robert P. J. Day" <rpjday@mindspring.com> writes:
> > >
> > > > that may be but, as i suggested earlier, that would get into
> > > > guessing what those developers were thinking, and i just didn't
> > > > want to go there.
> > >
> > > No guessing, I just checked it (though a second check wouldn't do
> > > any harm).
> > >
> > > > the simple version of the patch is now in andrew's tree, and
> > > > i'll worry about the harder stuff next time.
> > >
> > > The "next time" would be much harder as there would be no key for
> > > searching for these functions.
> >
> > Krzysztof's absolutely right ... we don't want to lose the
> > NORET_TYPE annotations on all these functions before we switch them
> > to ATTRIB_NORET. And yes, _all_ of these NORET_TYPE's do want to be
> > ATTRIB_NORET (except for those that are double-annotated, for those
> > we can just get rid of the NORET_TYPE macro).
>
> ok, i'll go back and take another look at this.

Actually there's another thing :-) The __attribute__((xxx)) must go with the
function _declarations_ (and not the implementations/definitions). I noticed
after my previous mail that most of the double annotations are actually in
the case of the _declarations_ of these non-returning functions, whereas
most of the single-occurrences of NORET_TYPE were in the function
definitions, which means your patch that simply got rid of NORET_TYPE
actually ended up doing exactly the right thing that we wanted :-)

The unfortunate / ugly part, however, is that there are few cases where
the above doesn't hold true ([1] NORET_TYPE without ATTRIB_NORET in
function declaration e.g. in include/asm-mips/ptrace.h -- this must
become ATTRIB_NORET, and [2] ATTRIB_NORET either alone or with
NORET_TYPE in function definitions e.g. arch/mips/kernel/traps.c -- these
can be eliminated entirely, and [3] NORET_AND occurrences where we
don't really want ATTRIB_NORET anymore, so just removing
NORET_TYPE would be right).

So this might not really be a simple patch anymore, and because the
benefit of ATTRIB_NORET is only miniscule, so you can ignore my
previous mail if you want :-)

Thanks,
Satyam
