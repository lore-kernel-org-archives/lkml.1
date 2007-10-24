Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbXJXTEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbXJXTEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 15:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbXJXTEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 15:04:47 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:36576 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbXJXTEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 15:04:46 -0400
Date: Wed, 24 Oct 2007 21:04:44 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Simon Arlott <simon@fire.lp0.eu>
cc: Adrian Bunk <bunk@kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static
 interface)
In-Reply-To: <471F9603.9080308@simon.arlott.org.uk>
Message-ID: <Pine.LNX.4.64.0710242059500.17781@fbirervta.pbzchgretzou.qr>
References: <alpine.LFD.0.999.0710171913270.26902@woody.linux-foundation.org>
 <200710192226.53233.agruen@suse.de> <alpine.LFD.0.999.0710191336250.26902@woody.linux-foundation.org>
 <Pine.LNX.4.64.0710201255170.1997@fbirervta.pbzchgretzou.qr>
 <Xine.LNX.4.64.0710210842540.551@us.intercode.com.au>
 <20071022210956.31f7bbcf@laptopd505.fenrus.org> <20071023051642.GA3908@sequoia.sous-sol.org>
 <471E9260.6000704@goop.org> <20071023220649.5a76af82@laptopd505.fenrus.org>
 <55615.simon.1193226629@5ec7c279.invalid> <20071024125533.GE30533@stusta.de>
 <471F8AC5.9080300@simon.arlott.org.uk> <Pine.LNX.4.64.0710242050540.17781@fbirervta.pbzchgretzou.qr>
 <471F9603.9080308@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 24 2007 19:59, Simon Arlott wrote:
>On 24/10/07 19:51, Jan Engelhardt wrote:
>> On Oct 24 2007 19:11, Simon Arlott wrote:
>>>
>>>* (I've got a list of access rules which are scanned in order until one of 
>>>them matches, and an array of one bit for every port for per-port default 
>>>allow/deny - although the latter could be removed.
>>>http://svn.lp0.eu/simon/portac/trunk/)
>> 
>> Besides the 'feature' of inhibiting port binding,
>> is not this task of blocking connections something for a firewall?
>
>The firewall blocks incoming connections where appropriate, yes, but it 
>doesn't stop one user binding to a port that another user expected to be able 
>to use. "Ownership" of ports (1-1023) shouldn't be something only root (via 
>CAP_NET_BIND_SERVICE) has. Lots of services also don't have standard ports 
>below 1024 and it's useful to be able to prevent users from binding to them 
>too.

Indeed.


There has been a feature in the security framework that probably did
not get much attention. It looks like YAGNI first, but on a closer look,
it becomes useful pretty quick - secondary_register.

As more and more simple LSM plugins pop up, stacking/chaining by means
of secondary_register becomes attractive again, especially if these LSMs
target different actions. This is probably the most useful thing why
the LSM interface should remain modular:

# Secure my files
modprobe apparmor
# -*- assuming apparmor implemented secondaries -*-
# Secure my ports
modprobe portac
# More rights to users
modprobe multiadm
# -*- whatever else comes along -*-
