Return-Path: <linux-kernel-owner+w=401wt.eu-S1751777AbZJJEsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777AbZJJEsK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 00:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbZJJEsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 00:48:06 -0400
Received: from claw.goop.org ([74.207.240.146]:43387 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbZJJEsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 00:48:06 -0400
Message-ID: <4AD011E0.8010402@goop.org>
Date: Fri, 09 Oct 2009 21:47:28 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: Duplication of vdso and vsyscall code?
References: <4ACFA80E.7050701@goop.org> <20091010041442.GF1656@one.firstfloor.org>
In-Reply-To: <20091010041442.GF1656@one.firstfloor.org>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/09 21:14, Andi Kleen wrote:
> One is at a fixed position in the user address space, and the other at a
> randomized position. The fixed one came first. Fixed doesn't know
> where randomized is. Randomized is also compiled and linked completely
> differently.
Is the fixed vsyscall stuff now considered to be legacy?  As far as I
can see, the vdso seems to be what ends up being used on all the systems
I've tried (going back to Fedora 8).

>  In theory the randomized one could call the fixed one, but
> originally there were some thoughts about turning off fixed for some
> applications that don't need it and also the path was considered very
> performance critical, so unneeded jumps were avoided.
>   

rdtsc seems to swamp pretty much everything else.  In my measurements it
alone takes 1/3 of the time.  Though that's Core2; AMD have
traditionally been much better at those kinds of things.

> In theory you could probably #include the code from a common file, but it 
> wouldn't buy you too much.

Yes, that's what I had in mind.  I don't think duplicating the
instructions is all that important, but having two separate similarish
pieces of code seems like a maintenance headache.  I only discovered the
second set of code by accident; I'd assumed that once I'd found one
vgettimeofday I'd found them all (and I'd been assuming that
clock_gettime didn't get the same treatment).

I'll see what happens if I try unifying them...

    J
