Return-Path: <linux-kernel-owner+w=401wt.eu-S938812AbXGSTYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938812AbXGSTYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 15:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965874AbXGSTXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 15:23:33 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:42913 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965916AbXGSTXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 15:23:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pA0thgUouXqQ4lBy+vZ335Ju10Zo03bu48WtkGsa0l/X2x53HbiWBqcnggVIXkAkGIIjKMidaLNS5Au+Osvx4fSNK/McvmtRUr7k2gT61FzQgmhgtnxwQOROl+veMZS381TC3+We986tymY2WHtSthFm0ZavxX9nhdwmP5Bbj68=
Message-ID: <d120d5000707191223s40d58d1bga858357265318371@mail.gmail.com>
Date: Thu, 19 Jul 2007 15:23:30 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH for review] [12/48] x86_64: use the global PIT lock
Cc: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <200707191929.40016.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070719348.540885000@suse.de>
	 <20070719134841.5677614E6E@wotan.suse.de>
	 <d120d5000707190822v44ca6fb0lefcc5302d3f7b8de@mail.gmail.com>
	 <200707191929.40016.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/19/07, Andi Kleen <ak@suse.de> wrote:
> On Thursday 19 July 2007 17:22:38 Dmitry Torokhov wrote:
> > Hi Andi,
> >
> > On 7/19/07, Andi Kleen <ak@suse.de> wrote:
> > >
> > > From: Thomas Gleixner <tglx@linutronix.de>
> > >
> > > Replace the pcspkr private PIT lock by the global PIT lock to serialize the
> > > PIT access all over the place.
> > >
> >
> > Like I said before I'd be more happy if spinlock was attached to a
> > platform device that pcspkr binds to so the arch code would control
> > wehther we use a private spinlock or a global one (I sent a patch to
> > that effect earlier).
>
> Not sure that flexibility is needed. Why would an architecture ever want
> to have more than one lock for this? And we normally don't need sysdevs
> for locks, they seem to be quite unrelated.
>

I was not talking about sysdevs. I was talking about platform devices
that are already being created for pcspkr by arch code. Now I want
arch code to provide a spinlock for pcspkr driver to use when
accessing PIT. What it does it allows to remove arch specific
knowledge (i.e. #ifdef CONFIG_X86...) from the pcspkr driver.

-- 
Dmitry
