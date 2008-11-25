Return-Path: <linux-kernel-owner+w=401wt.eu-S1753438AbYKYXQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbYKYXQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 18:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbYKYXQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 18:16:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47655 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189AbYKYXQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 18:16:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Regression in 2.6.28-rc and 2.6.27-stable - hibernate related
Date: Wed, 26 Nov 2008 00:15:24 +0100
User-Agent: KMail/1.9.9
Cc: Fabio Comolli <fabio.comolli@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jay Fenlason <fenlason@redhat.com>
References: <b637ec0b0811230817x5b445a0m665305d2b6bf6c1f@mail.gmail.com> <200811240031.55944.rjw@sisk.pl> <492A5557.2010404@s5r6.in-berlin.de>
In-Reply-To: <492A5557.2010404@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811260015.24549.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 24 of November 2008, Stefan Richter wrote:
> Rafael J. Wysocki wrote:
> > On Sunday, 23 of November 2008, Fabio Comolli wrote:
> >> Hi.
> >>
> >> On Sun, Nov 23, 2008 at 7:24 PM, Fabio Comolli <fabio.comolli@gmail.com> wrote:
> >>> Hi
> >>>
> >>> Yes. I started another bisection session between 2.6.27.4 and 2.6.27.5.
> >>>
> >> Ok, this time things went much better. The bisection pointed to:
> >>
> >> ------------------------------------------------------------------------------------------------------------------------------------------------
> >> fcomolli@hawking:~/software/GIT-TREES/linux-2.6.27.y> git bisect good
> >> ff0f8d16839cd02dc95bd92c212cbd5d433a4d2b is first bad commit
> >> commit ff0f8d16839cd02dc95bd92c212cbd5d433a4d2b
> >> Author: Jay Fenlason <fenlason@redhat.com>
> >> Date:   Mon Oct 27 23:28:14 2008 +0100
> >>
> >>     firewire: fix struct fw_node memory leak
> >>
> >>     commit 77e557191701afa55ae7320d42ad6458a2ad292e upstream
> >>
> >>     With the bus_resets patch applied, it is easy to see this memory leak
> >>     by repeatedly resetting the firewire bus while running slabtop in
> >>     another window.  Just watch kmalloc-32 grow and grow...
> >>
> >>     Signed-off-by: Jay Fenlason <fenlason@redhat.com>
> >>     Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> >>
> >> :040000 040000 01cadbd5f5fb81ce4f5e2023573204c4fbec3a28
> >> 809a53f4be87bd8be133ebd7564e1139a0cfa45b M      drivers
> >> ------------------------------------------------------------------------------------------------------------------------------------------------
> >>
> >> And this is the log:
> >>
> >> ------------------------------------------------------------------------------------------------------------------------------------------------
> >> fcomolli@hawking:~/software/GIT-TREES/linux-2.6.27.y> git bisect log
> >> git-bisect start
> >> # good: [056c71459d3acf9fefcb2dc67abeef10e649d508] Linux 2.6.27.4
> >> git-bisect good 056c71459d3acf9fefcb2dc67abeef10e649d508
> >> # bad: [788a5f3f70e2a9c46020bdd3a195f2a866441c5d] Linux 2.6.27.5
> >> git-bisect bad 788a5f3f70e2a9c46020bdd3a195f2a866441c5d
> >> # bad: [7bdb542c453c14e54af9ebe5c4a827e4a678c47d] powerpc/numa: Make
> >> memory reserve code more robust
> >> git-bisect bad 7bdb542c453c14e54af9ebe5c4a827e4a678c47d
> >> # good: [f29062d0ec12ee3a58c67228dc829574b4ced378] syncookies: fix
> >> inclusion of tcp options in syn-ack
> >> git-bisect good f29062d0ec12ee3a58c67228dc829574b4ced378
> >> # good: [882491755d4c819de5bb593f04d06692185760aa] firewire: fix
> >> ioctl() return code
> >> git-bisect good 882491755d4c819de5bb593f04d06692185760aa
> >> # bad: [baae4f5fd7a75bdfa70d374b738963053df2bcaa] firewire: fw-sbp2: fix races
> >> git-bisect bad baae4f5fd7a75bdfa70d374b738963053df2bcaa
> >> # bad: [ff0f8d16839cd02dc95bd92c212cbd5d433a4d2b] firewire: fix struct
> >> fw_node memory leak
> >> git-bisect bad ff0f8d16839cd02dc95bd92c212cbd5d433a4d2b
> >> # good: [b6021579f54e5b6b31f03fe24de1208a2feb4aec] firewire: Survive
> >> more than 256 bus resets
> >> git-bisect good b6021579f54e5b6b31f03fe24de1208a2feb4aec
> >> ------------------------------------------------------------------------------------------------------------------------------------------------
> >>
> >> The commit reverted cleanly and now I'm running 2.6.27.7 with that
> >> commit reverted. I'll post my results.
> >>
> >> Hoper this helps. Regards,
> > 
> > Yes, thanks for bisecting this (CCs added).
> 
> The commit which was pointed to in the bisection does nothing else than
> free some data in firewire-core.
> 
> (Note to myself and Jay:  See http://lkml.org/lkml/2008/11/23/123 and
> http://lkml.org/lkml/2008/11/23/153 for the history of this bug.)
> 
> Fabio, please test a _bad_ kernel with firewire drivers unloaded before
> hibernation.  Also, please enable in the "Kernel hacking" kernel config
> menu:  "Kernel debugging", "Debug slab memory allocations".  Thanks,

I _think_ it also happens on the Toshiba Portege R500 I'm testing at the
moment, but I have never been able to recover the box from the failure
(I think it is a panic BTW, because the caps lock LED starts to blink when it
happens).

I'm going to debug this a bit more in the next few days.

Thanks,
Rafael
