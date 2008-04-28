Return-Path: <linux-kernel-owner+w=401wt.eu-S934638AbYD1RZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934638AbYD1RZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 13:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765334AbYD1RYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 13:24:55 -0400
Received: from mtl.rackplans.net ([69.90.0.18]:55456 "EHLO mtl.rackplans.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761612AbYD1RYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 13:24:54 -0400
Date: Mon, 28 Apr 2008 13:24:52 -0400 (EDT)
From: Gerhard Mack <gmack@innerfire.net>
X-X-Sender: gmack@mtl.rackplans.net
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.25] compat VDSO option not disabling
In-Reply-To: <4816029D.3030508@goop.org>
Message-ID: <alpine.DEB.1.10.0804281322200.17060@mtl.rackplans.net>
References: <alpine.DEB.1.10.0804241244360.28216@mtl.rackplans.net> <Pine.LNX.4.64.0804251632490.19002@twin.jikos.cz> <alpine.DEB.1.10.0804261213200.28624@mtl.rackplans.net> <48140ACF.4000500@goop.org> <alpine.DEB.1.10.0804281145090.17060@mtl.rackplans.net>
 <4816029D.3030508@goop.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008, Jeremy Fitzhardinge wrote:
> Gerhard Mack wrote:
> > On Sat, 26 Apr 2008, Jeremy Fitzhardinge wrote:
> >   
> > > Gerhard Mack wrote:
> > >     
> > > > I havn't enabled compat VDSO at the kernel command line or otherwise.
> > > > Something broke with this option.         
> > > Yes, you might be on to something.  I think I've been seeing that message
> > > when
> > > I wouldn't expect to.  I'll double-check.  Could you send your complete
> > > dmesg
> > > output?
> > > 
> > >     
> > Of course
> > 
> > 
> > Compat vDSO mapped to ffffe000.
> >   
> 
> I think this is just a false alarm.  sysenter_setup always prints this, but if
> compat mode isn't enabled this is just the address the compat vdso would be at
> if it were mapped.  You can confirm this by doing "cat /proc/self/maps" and
> making sure that there's nothing mapped at ffffe000.  And then cross confirm
> with "sysctl -w vm.vdso_enabled=2; cat /proc/self/maps" to make sure it
> appears.
> 

fd:~# cat /proc/self/maps | grep ffffe000
fd:~# sysctl -w vm.vdso_enabled=2
vm.vdso_enabled = 2
fd:~# cat /proc/self/maps | grep ffffe000
ffffe000-fffff000 r-xp 00000000 00:00 0          [vdso]

Your right.. can the boot message be made a bit more descriptive ?  I'm 
going to guess that I'm not the only one who makes this mistake.

	Gerhard


--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
