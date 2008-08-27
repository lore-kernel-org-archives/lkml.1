Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbYH0Qjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbYH0Qjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 12:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755086AbYH0Qjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 12:39:39 -0400
Received: from ns.firmix.at ([62.141.48.66]:2428 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724AbYH0Qji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 12:39:38 -0400
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
	bisected
From: Bernd Petrovitsch <bernd@firmix.at>
To: Jamie Lokier <jamie@shareable.org>
Cc: Parag Warudkar <parag.lkml@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Rusty Russell <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-embedded@vger.kernel.org
In-Reply-To: <20080827154805.GA25387@shareable.org>
References: <20080826183051.GB10925@cs181140183.pp.htv.fi>
	 <alpine.LFD.1.10.0808261144510.3363@nehalem.linux-foundation.org>
	 <20080826205916.GB11734@cs181140183.pp.htv.fi>
	 <alpine.LFD.1.10.0808261403360.3363@nehalem.linux-foundation.org>
	 <f7848160808261554j2f4eaaa6i1ee8801ae75ca7bf@mail.gmail.com>
	 <alpine.LFD.1.10.0808261644260.3363@nehalem.linux-foundation.org>
	 <f7848160808261758q7b84aab1m188c1ebb59304818@mail.gmail.com>
	 <1219827609.30209.29.camel@spike.firmix.at>
	 <f7848160808270556q54c36270ye6a465d2ca123cc@mail.gmail.com>
	 <1219843032.30209.51.camel@spike.firmix.at>
	 <20080827154805.GA25387@shareable.org>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Wed, 27 Aug 2008 18:38:41 +0200
Message-Id: <1219855121.30209.112.camel@spike.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.345 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.345 required=5
X-Spam-Score: -2.345 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-27 at 16:48 +0100, Jamie Lokier wrote:
> Bernd Petrovitsch wrote:
> > If you "develop" an embedded system (which is partly system integration
> > of existing apps) to be installed in the field, you don't have that many
> > conceivable work loads compared to a desktop/server system. And you have
> > a fixed list of drivers and applications.
> 
> Hah!  Not in my line of embedded device.
> 
> 32MB no-MMU ARM boards which people run new things and attach new
> devices to rather often - without making new hardware.  Volume's too
> low per individual application to get new hardware designed and made.

Yes, you may have several products on the same hardware with somewhat
differing requirements (or not). But that is much less than a general
purpose system IMHO.

> I'm seriously thinking of forwarding porting the 4 year old firmware
> from 2.4.26 to 2.6.current, just to get new drivers and capabilities.

That sounds reasonable (and I never meant maintaining the old system
infinitely. Actually once the thing is shipped it usually enters deep
maintenance mode and the next is more a fork from the old).

> Backporting is tedious, so's feeling wretchedly far from the mainline
> world.

ACK. But that also depends on amount local changes (and sorry, but not
all locally necessary patches would be accepted in mainline in any way).

> > A usual approach is to run stress tests on several (or all)
> > subsystems/services/... in parallel and if the device survives it
> > functioning correctly, it is at least good enough.
> 
> Per application.
> 
> Some little devices run hundreds of different applications and
> customers expect to customise, script themselves, and attach different
> devices (over USB).  The next customer in the chain expects the bits
> you supplied to work in a variety of unexpected situations, even when
> you advise that it probably won't do that.

Basically their problem. Yes, "they" actually think they get a Linux
system where they can do everything and it simply works.

Oh, that's obviously not a usual "WLAN-router style" of product (where
you are not expected to actually login on a console or per ssh).

> Much like desktop/server Linux, but on a small device where silly
> little things like 'create a process' are a stress for the dear little
> thing.
> 
> (My biggest lesson: insist on an MMU next time!)

ACK. We avoid MMU-less hardware too - especially since there is enough
hardware with a MMU around.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


