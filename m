Return-Path: <linux-kernel-owner+w=401wt.eu-S1758878AbXJCSHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878AbXJCSHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 14:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbXJCSGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 14:06:55 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:24570 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbXJCSGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 14:06:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=A0Pps7lg6UoMAJgPQNM/+O0/WHS9vf2xrEX5uy4XxQTJt+FiCUGyrEtin+d8Qi6+/sTFGxGObp3J2XSFIlWtNa/cfHHlY/sP13ZG4XnJk7uEgAQOzLmzDJJqVKptr3NKegDjC6lWQsBnXjKWXekp/iygCm6kJrrkphTQz8XuYB8=
Message-ID: <64bb37e0710031106n2aa93d08j85c6729df2f2cac8@mail.gmail.com>
Date: Wed, 3 Oct 2007 20:06:48 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: sata_sil24 broken since 2.6.23-rc4-mm1
Cc: "Tejun Heo" <htejun@gmail.com>, "Jeff Garzik" <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20071003175105.GT19691@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <64bb37e0709292300t39028029n2375899d7ba1e8ce@mail.gmail.com>
	 <64bb37e0709300919w3e9db6aci4c0b9df43407fff3@mail.gmail.com>
	 <46FFDF64.1080005@gmail.com>
	 <64bb37e0709301139h456a82d6u98630a4d1503eaf@mail.gmail.com>
	 <64bb37e0710011100t2cd81a32g501435b98f783ba9@mail.gmail.com>
	 <64bb37e0710030821u56157ad1s6252ee01e050c7d5@mail.gmail.com>
	 <64bb37e0710030855t360f2216mb4c38cfab6d88f37@mail.gmail.com>
	 <20071003163804.GR19691@waste.org>
	 <64bb37e0710031036q228b63a8nf03d030b7d97b27f@mail.gmail.com>
	 <20071003175105.GT19691@waste.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/3/07, Matt Mackall <mpm@selenic.com> wrote:
> On Wed, Oct 03, 2007 at 07:36:55PM +0200, Torsten Kaiser wrote:
> > Of note might be, that at the time of this error init has not been
> > started. I'm using a program from initramfs to start the RAID.
> > The initramfs was primarily build using the genkernel package from
> > gentoo, but I have removed some parts of it (kernel modules and some
> > other part I no longer remember)
>
> Then I really don't see how these patches can have anything to do with
> your problem. They only affect some currently obscure files in /proc
> and it's unlikely to have any impact at init time. It's more likely
> that there's some code alignment Heisenbug or you got a false negative
> somewhere in your bisection.

Heisenbug via code alignment might be, but the bisection result seemed
rather reliable.
I have 4 good boots with all mm-patches before the maps2-* ones and 2
out of 3 boots failed with part or all maps2-* patches applied. (Any
many more failed boots with more mm-patches applied.)

But I do think it might be very possible that some (maybe even
correct) change in the behavior of this code triggers the error. So
I'm very interested in what you additional printk outputs to track
down what changed and why this breaks.

I looked at the scripts from the initramfs, but sadly I don't see
anything that crawls throug /proc and might hit your files. Other than
that there is nearly only busybox in there. cryptsetup should run
later and modprobe does not have any modules it could try to load...

Torsten
