Return-Path: <linux-kernel-owner+w=401wt.eu-S1755832AbZEDTMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832AbZEDTMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 15:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753796AbZEDTL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 15:11:57 -0400
Received: from mx32b01.es6.egwn.net ([195.10.6.123]:39266 "EHLO
	mx1.es6.egwn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045AbZEDTL4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 15:11:56 -0400
Date: Mon, 4 May 2009 21:11:51 +0200
From: Matthias Saou 
	<thias@spam.spam.spam.spam.spam.spam.spam.egg.and.spam.freshrpms.net>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: linux-kernel@vger.kernel.org, Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: Wrong network usage reported by /proc
Message-ID: <20090504211151.74622f29@python3.es.egwn.lan>
In-Reply-To: <49FF2BB2.4030700@cosmosbay.com>
References: <20090504171408.3e13822c@python3.es.egwn.lan>
	<49FF2BB2.4030700@cosmosbay.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote :

> Matthias Saou a écrit :
> > Hi,
> > 
> > I'm posting here as a last resort. I've got lots of heavily used RHEL5
> > servers (2.6.18 based) that are reporting all sorts of impossible
> > network usage values through /proc, leading to unrealistic snmp/cacti
> > graphs where the outgoing bandwidth used it higher than the physical
> > interface's maximum speed.
> > 
> > For some details and a test script which compares values from /proc
> > with values from tcpdump :
> > https://bugzilla.redhat.com/show_bug.cgi?id=489541
> > 
> > The values collected using tcpdump always seem realistic and match the
> > values seen on the remote network equipments. So my obvious conclusion
> > (but possibly wrong given my limited knowledge) is that something is
> > wrong in the kernel, since it's the one exposing the /proc interface.
> > 
> > I've reproduced what seems to be the same problem on recent kernels,
> > including the 2.6.27.21-170.2.56.fc10.x86_64 I'm running right now. The
> > simple python script available here allows to see it quite easily :
> > https://www.redhat.com/archives/rhelv5-list/2009-February/msg00166.html
> > 
> >  * I run the script on my Workstation, I have an FTP server enabled
> >  * I download a DVD ISO from a remote workstation : The values match
> >  * I start ping floods from remote workstations : The values reported
> >    by /proc are much higher than the ones reported by tcpdump. I used
> >    "ping -s 500 -f myworkstation" from two remote workstations
> > 
> > If there's anything flawed in my debugging, I'd love to have someone
> > point it out to me. TIA to anyone willing to have a look.
> > 
> > Matthias
> > 
> 
> I could not reproduce this here... what kind of NIC are you using on
> affected systems ? Some ethernet drivers report stats from card itself,
> and I remember seeing some strange stats on some hardware, but I cannot
> remember which one it was (we were reading NULL values instead of
> real ones, once in a while, maybe it was a firmware issue...)

My workstation has a Broadcom BCM5752 (tg3 module). The servers which
are most affected have Intel 82571EB (e1000e). But the issue is that
with /proc, the values are a lot _higher_ than with tcpdump, and the
tcpdump values seem to be the correct ones.

Matthias

-- 
Clean custom Red Hat Linux rpm packages : http://freshrpms.net/
Fedora release 10 (Cambridge) - Linux kernel
2.6.27.21-170.2.56.fc10.x86_64 Load : 2.20 0.88 0.42
