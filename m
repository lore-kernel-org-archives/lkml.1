Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbYAPQiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbYAPQiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 11:38:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYAPQil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 11:38:41 -0500
Received: from wx-out-0506.google.com ([66.249.82.234]:49378 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbYAPQij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 11:38:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ajMTKplD8YJrFVjMTFnWmZRPqcLFCaaJ1fDtY7izwOuIznVQLLmCIQRrR2TmKGBr2kcEVTkOQYxwDLLW3cWwQy4NRQN67tEDF1oQyM0C5Wa7imJm8y9Hbb3DVZ0oCzSsyOD5XCvR+7Uzujqb1cmtHZXsyYVkIBkYCskb9vkgE0s=
Message-ID: <cf3edd8d0801160838o3edf8885uf0a8a9d2872ee36e@mail.gmail.com>
Date: Wed, 16 Jan 2008 16:38:33 +0000
From: "Colin Fowler" <elethiomel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Performance loss 2.6.22->22.6.23->2.6.24-rc7 on CPU intensive benchmark on 8 Core Xeon
Cc: linux-kernel@vger.kernel.org, "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <20080116161951.GA15000@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cf3edd8d0801140937w755c3e75me83c214ebc1f4cd3@mail.gmail.com>
	 <20080114185520.GA26540@elte.hu>
	 <cf3edd8d0801141442nedf4ac1p6b1fd6bc94900063@mail.gmail.com>
	 <cf3edd8d0801150901p653edeear62d5bc91d9f46981@mail.gmail.com>
	 <20080115220641.GC2665@elte.hu>
	 <cf3edd8d0801151505r54bfd9d0r89f57e3835f295e1@mail.gmail.com>
	 <20080116153505.GB18553@elte.hu>
	 <cf3edd8d0801160810w4302afa5vd731cc6852c778ba@mail.gmail.com>
	 <20080116161951.GA15000@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I have permission for a binary only release (mailed the supervisor
intermediately after your earler mail). I'm sure the abstract code
simulating the workload will be alright too, but I need time to put it
together as I'm a bit swamped at the moment. Will hope to have it in
the next few days.

regards,
       Colin

On Jan 16, 2008 4:19 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Colin Fowler <elethiomel@gmail.com> wrote:
>
> > Hi Ingo, I'll need to convince my supervisor first if I can release a
> > binary. Technically anythin glike this needs to go through our
> > University's "innovations department" and requires lengthy paperwork
> > and NDAs :(.
>
> a binary wouldnt work for me anyway. But you could try to write a
> "workload simulator": just pick out the pthread ops and replace the
> worker functions with some dummy stuff that just touches an array that
> has similar size to the tiles (in a tight loop). Make sure it has
> similar context-switch rate and idle percentage as your real workload -
> then send us the .c file. As long as it's a single .c file that runs for
> a few seconds and outputs a precise enough "run time" result, kernel
> developers would pick it up and use it for optimizations. To get the #
> of cpus automatically you can do:
>
>         cpus = system("exit `grep processor /proc/cpuinfo  | wc -l`");
>         cpus = WEXITSTATUS(cpus);
>
> and start as many threads as many CPUs there are in the system.
>
>         Ingo
>
