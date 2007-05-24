Return-Path: <linux-kernel-owner+w=401wt.eu-S1751361AbXEXO3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361AbXEXO3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 10:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750714AbXEXO3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 10:29:14 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:9964 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbXEXO3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 10:29:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sUykDIfJKQZWyJfKgUJ87F56rcF0K9v8yitWoXViQIQ6vI11HV4AjDeWu2WPUfdmhnkLg1zc8vASwZvoK51/Zob0moYrG4D3wfn4dAiz1MoVmrz1Jip5NLXl9izSv0/w0bgtUzv0ObypqYDGrpaGTE1uotpE8ngAVvpSjdM7JHc=
Message-ID: <4cefeab80705240729w6cf0f84fvb6cd86e19256b2b@mail.gmail.com>
Date: Thu, 24 May 2007 19:59:01 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: [RFC] LZO de/compression support - take 3
Cc: "Richard Purdie" <richard@openedhand.com>, linux-kernel@vger.kernel.org,
       linux-mm-cc@laptop.org
In-Reply-To: <a781481a0705240407p2e9933ecm8d2c9863465cdeac@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705230127r58e8f9e1sa644092e95eb81eb@mail.gmail.com>
	 <a781481a0705231234m62327134mbfd1c1478b6fb99a@mail.gmail.com>
	 <1179995105.5880.7.camel@localhost.localdomain>
	 <a781481a0705240407p2e9933ecm8d2c9863465cdeac@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/24/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> Hmm. The wrappers would clearly be inline, but if we want a common
> low-level decompress function, we'd also need to introduce the "if (safe &&)"
> kind of tests for those differently-defined macros which could impact
> performance (for the _unsafe variant only, isn't it). By how much is the
> question, and whether we really care to avoid duplicating 50 lines of code
> to take that hit on the unsafe function (or vice versa).

All this just to avoid that symlink? What is so wrong with that? Yes,
the ugliest thing is some additions to top-level Makefile but I think
this the reason those prepare{1,2,3....} targets were meant for.

> > All I will add is that after the amendment I made, the ugliness in my
> > patchset is confined to one file now and I still think its the better
> > approach to take.
> >
> > My main concerns with this patch are that:
> > * from the security point of view its not tried and tested code
> > * I'm not 100% confident in what Nitin has done with the code from a
> >   buffer overflow/security PoV
> > * its not tested on many architectures
> > * the performance implications of the rewrite are unknown
>
> Right, it needs testing (for correctness and robustness). But that
> shouldn't be too difficult -- Nitin, you could just write up a simple test
> module that others can use with your patch to do testing on their
> arch's ... the more this gets tested, the better chances it's got.
>

Mailed 'compressed-test' module along with usage to Bret (CC'ed to
you, Richard, linux-kernel). This makes it very easy to test this LZO
code.


Thanks for comments.

- Nitin
