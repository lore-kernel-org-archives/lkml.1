Return-Path: <linux-kernel-owner+w=401wt.eu-S1754103AbZBCXqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbZBCXqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 18:46:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbZBCXpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 18:45:54 -0500
Received: from smtp4.ono.com ([62.42.230.177]:11053 "EHLO resmaa15.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751046AbZBCXpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 18:45:54 -0500
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Feb 2009 18:45:53 EST
Date: Wed, 4 Feb 2009 00:40:03 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: SSD and IO schedulers
Message-ID: <20090204004003.26068f72@werewolf.home>
In-Reply-To: <4dcf7d360901301355l7ed26a5aob7ef6d79d9607b6b@mail.gmail.com>
References: <4dcf7d360901301355l7ed26a5aob7ef6d79d9607b6b@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0cvs53 (GTK+ 2.15.3; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jan 2009 22:55:47 +0100, Lorenzo Allegrucci <l.allegrucci@gmail.com> wrote:

> Hi, I was wondering how IO schedulers such as as-iosched, deadline and
> cfq behave on SSD
> (that have virtually no seek time), from a theoretical point of view.
> How do they affect
> performance on these devices?
> I heard that the noop scheduler is often chosen by owners of EeePcs
> (with a SSD unit).

I'm beginning to think this is a _very_ bad idea. I have an AspireOne
A110 (512MB, 8GB SSD). This is 'not the best SSD in the world', to say
something. I had been booting with elevator=noop, because of all those
advices found along many blogs.

The fact is that the system behaved well, except when I was doing an
'urpmi --auto-update' (I use Mandriva). The bulk of rpm work rendered the
box unusable. 5-10 seconds stalls and so on.

After reading this, I killed the elevator option from grub, the system uses
the default cfq scheduler, and things are much smoother and the laptop
is perfectly usable while doing an update. I think even rpm itself works
faster.

Perhaps the reason is that, as the SSD is not so good, it behaves more
like a rotational drive ;).

> They report superior performance by using this (quite simple) scheduler.
> Are there any scientific benchmarks around?
> 

A couple questions:
- Apart from noop, which scheduler do you think is the best for SSDs ?
- I'm running 2.6.28.2. Does it have the 'SSD detector' in libata ?
  How can I verify it ?

TIA

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.1 (Cooker) for x86_64
Linux 2.6.28.2-desktop-1mnb (gcc 4.3.2 (GCC) #1 Wed Jan
