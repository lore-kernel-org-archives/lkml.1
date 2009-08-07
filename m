Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481AbZHGVlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbZHGVlu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 17:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbZHGVlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 17:41:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:54406 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbZHGVlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 17:41:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [Bridge] [PATCH] macvlan: add tap device backend
Date: Fri, 7 Aug 2009 23:38:57 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.2.98; x86_64; ; )
Cc: "Paul Congdon \(UC Davis\)" <ptcongdon@ucdavis.edu>, drobbins@funtoo.org,
       "'Fischer, Anna'" <anna.fischer@hp.com>, herbert@gondor.apana.org.au,
       mst@redhat.com, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       ogerlitz@voltaire.com, evb@yahoogroups.com, davem@davemloft.net
References: <0199E0D51A61344794750DC57738F58E6D6A6CD7F6@GVW1118EXC.americas.hpqcorp.net> <004f01ca1792$b24a7a90$16df6fb0$@edu> <20090807123554.7c2bc27c@nehalam>
In-Reply-To: <20090807123554.7c2bc27c@nehalam>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908072338.57895.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/0zqJiuo0wwS4g9kAEeTOZFzWfD9jRKTsb5JJ
 OV6x1wMptV/fWu00/IShL5bB2nMlIEYaiLNVScvP0eXgTBxSjz
 c66j9gT4qdX0tnzDfqNAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 August 2009, Stephen Hemminger wrote:
> On Fri, 7 Aug 2009 12:10:07 -0700
> "Paul Congdon \(UC Davis\)" <ptcongdon@ucdavis.edu> wrote:
> 
> > Responding to Daniel's questions...
> > 
> > > I have some general questions about the intended use and benefits of 
> > > VEPA, from an IT perspective:
> > > 
> > > In which virtual machine setups and technologies do you forsee this 
> > > interface being used?
> > 
> > The benefit of VEPA is the coordination and unification with the
> > external network switch.  So, in environments where you are
> > needing/wanting your feature rich, wire speed, external network
> > device (firewall/switch/IPS/content-filter) to provide consistent
> > policy enforcement, and you want your VMs traffic to be subject to
> > that enforcement, you will want their traffic directed externally.
> > Perhaps you have some VMs that are on a DMZ or clustering an 
> > application or implementing a multi-tier application where you
> > would normally place a firewall in-between the tiers.
> 
> I do have to raise the point that Linux is perfectly capable of keeping up without
> the need of an external switch.  Whether you want policy external or internal is
> a architecture decision that should not be driven by mis-information about performance.

In general, I agree that Linux on a decent virtual machine host will be
able to handle forwarding of network data fast enough, often faster than
the external connectivity allows if it needs to transmit every frame twice.

However, there is a tradeoff between CPU cycles and I/O bandwidth. If your
application needs lots of CPU but you have spare capacity on the PCI bus, the
network wire and the external switch, VEPA can also be a win on the performance
side. As always, performance depends on the application, even if it's not the
main driving factor here.

	Arnd <><
