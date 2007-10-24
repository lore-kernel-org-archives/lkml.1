Return-Path: <linux-kernel-owner+w=401wt.eu-S1760618AbXJXVmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760618AbXJXVmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 17:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756878AbXJXVmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 17:42:21 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:57164 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757449AbXJXVmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 17:42:20 -0400
Date: Wed, 24 Oct 2007 23:42:18 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
cc: Simon Arlott <simon@fire.lp0.eu>, Adrian Bunk <bunk@kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static
 interface)
In-Reply-To: <1193259748.30930.91.camel@moss-terrapins.epoch.ncsc.mil>
Message-ID: <Pine.LNX.4.64.0710242326430.17781@fbirervta.pbzchgretzou.qr>
References: <alpine.LFD.0.999.0710171913270.26902@woody.linux-foundation.org>
  <200710192226.53233.agruen@suse.de>  <alpine.LFD.0.999.0710191336250.26902@woody.linux-foundation.org>
  <Pine.LNX.4.64.0710201255170.1997@fbirervta.pbzchgretzou.qr> 
 <Xine.LNX.4.64.0710210842540.551@us.intercode.com.au> 
 <20071022210956.31f7bbcf@laptopd505.fenrus.org>  <20071023051642.GA3908@sequoia.sous-sol.org>
 <471E9260.6000704@goop.org>  <20071023220649.5a76af82@laptopd505.fenrus.org>
  <55615.simon.1193226629@5ec7c279.invalid>  <20071024125533.GE30533@stusta.de>
 <471F8AC5.9080300@simon.arlott.org.uk>  <Pine.LNX.4.64.0710242050540.17781@fbirervta.pbzchgretzou.qr>
  <471F9603.9080308@simon.arlott.org.uk>  <Pine.LNX.4.64.0710242059500.17781@fbirervta.pbzchgretzou.qr>
 <1193259748.30930.91.camel@moss-terrapins.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 24 2007 17:02, David P. Quigley wrote:
>> 
>> There has been a feature in the security framework that probably did
>> not get much attention. It looks like YAGNI first, but on a closer look,
>> it becomes useful pretty quick - secondary_register.
>> 
>> As more and more simple LSM plugins pop up, stacking/chaining by means
>> of secondary_register becomes attractive again, especially if these LSMs
>> target different actions. This is probably the most useful thing why
>> the LSM interface should remain modular:
>> 
>> # Secure my files
>> modprobe apparmor
>> # -*- assuming apparmor implemented secondaries -*-
>> # Secure my ports
>> modprobe portac
>> # More rights to users
>> modprobe multiadm
>> # -*- whatever else comes along -*-

>Apparmor wants to lock down some application, it gives the application
>access to a particular port, and the minimal set of privileges needed to
>execute the application. [...]
>however we now have to compose this with AppArmor. So an administrator
>runs into an error running his application. Is this because his user
>isn't granted the proper escalated privileges? Is it because AppArmor
>needs an extra rule to run the application?

Of course, the example I gave assumed that each LSM had disjunctive
features. Apparmor is primarily known for blocking file access,
and portac for blocking bind(2). If one of these gets additionaly
functionality, it would be nice that code gets combined so that
tracking down the piece of code that caused a particular syscall to
say nay is easier to pinpoint.

>It could also be that our third module has blocked the application
>because it determined that even though multiadm specified that the
>user should have the elevated privileges to run the application that
>user shouldn't be able to bind to that port.
>[...] Stacking works in things such as file systems because we have
>a clearly defined interface with fixed solid semantics. You could
>attempt to do that but once you have modules that step on each
>others toes you have to figure out a way to reconcile that.

I agree - if one does not get the magic behind LSM stacking, s/he
should not use it, or learn to use it.
However, if you grasp how it works (probably even easier to learn
than figuring out how to selinux), one should know that a pam_deny.so
even after a pam_permit.so will lock you down. Yeah, it's like PAM
stacking.
