Return-Path: <linux-kernel-owner+w=401wt.eu-S1422865AbXBASRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422865AbXBASRK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 13:17:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422899AbXBASRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 13:17:10 -0500
Received: from wx-out-0506.google.com ([66.249.82.236]:51952 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422865AbXBASRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 13:17:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gR1WG8TB6rFtNpSidj2I05YZ3ARI+iUsNj3GAj3+DONidw6LfFQm0DexmxQJLS8coOV5sXCjam07TmQKMC19rkLl7Ex+P9WYnx9rwAcm57JA0uCBtdcBuXKuIHn3qli+RsaG4LK98mDEwIKSW1r9ZCP1gjdFBK9Z9kxbxyYl3XI=
Message-ID: <653402b90702011017j4c8602e8v983fb224662a5e3d@mail.gmail.com>
Date: Thu, 1 Feb 2007 19:17:08 +0100
From: "Miguel Ojeda" <maxextreme@gmail.com>
To: "Daniel Walker" <dwalker@mvista.com>
Subject: Re: crash on CONFIG_CFAG12864B=y in 2.6.20-rc3-mm1
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <1170352552.9781.212.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1168188931.26086.255.camel@imap.mvista.com>
	 <653402b90702010549v17e72765uc718c1ae79419003@mail.gmail.com>
	 <653402b90702010716i7c0ddf71xe6fa7866323f52f4@mail.gmail.com>
	 <1170342991.9781.189.camel@imap.mvista.com>
	 <653402b90702010913g3d91b190ud4faa2bcce3251b@mail.gmail.com>
	 <1170350433.9781.200.camel@imap.mvista.com>
	 <653402b90702010939t692e0852pc6750dbfae4b25f5@mail.gmail.com>
	 <1170352552.9781.212.camel@imap.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/1/07, Daniel Walker <dwalker@mvista.com> wrote:
> On Thu, 2007-02-01 at 18:39 +0100, Miguel Ojeda wrote:
> > On 2/1/07, Daniel Walker <dwalker@mvista.com> wrote:
> > > On Thu, 2007-02-01 at 18:13 +0100, Miguel Ojeda wrote:
> > >
> > > > >
> > > > >
> > > >
> > > > Well, I use the word "module" for both cases: When I modprobe
> > > > cfag12864b, if ks0108 fails, it doesn't get linked. So I thought the
> > > > same happen for built-in drivers (in other words, I didn't think
> > > > cfag12864b would be linked if ks0108 failed).
> > > >
> > > > So I'm waiting until someone tell me what is the right way to avoid
> > > > drivers like cfag12864b been inited if their dependencies failed.
> > > >
> > > > Anyway, thanks for discovering the bug (I wouldn't have discovered it
> > > > as my motherboard has parallel port ;).
> > >
> > > I have a parallel port, but I don't have the cfag12864b or ks0108 .. I
> >
> > In fact, you don't need the cfag12864b display, as the driver just
> > needs the parallel port for output (you can put some LEDs attached to
> > the parallel port to check the driver's operations and it will be
> > fine).
> >
> > BTW, why ks0108 didn't find the 888 parallel port? Haven't you got such
> number?
>
> You know I think your right, it may not have a parallel port.. It's so
> common I tend to take it for granted .
>

Sadly, parallel ports are dying :(

> > > think the simplest way to fix it would be to add a flag to ks0108 that
> > > signals successful initialization , then force cfag12864b to check for
> > > that ..
> >
> > Sure, that won't be a problem; however, maybe there is other better way
> (?).
>
> When you build the driver as a module the module loader will only load
> what is needed, and in order .. When the same driver is built-in the
> module_init() becomes a device_initcall() , and all device_initcall's
> get executed .. So you have to expect that cfag12864b drivers initcalls
> will run eventually and will need to be careful about it's
> initialization.

That is the real problem, indeed.

>
> Daniel
>
>

All right, if there is no other better way to avoid that, I will send
the patch soon.

Miguel

-- 
Miguel Ojeda
http://maxextreme.googlepages.com/index.htm
