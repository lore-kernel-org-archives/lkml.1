Return-Path: <linux-kernel-owner+w=401wt.eu-S932235AbZEDRyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235AbZEDRyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 13:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757510AbZEDRyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 13:54:01 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:39713 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379AbZEDRyA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 13:54:00 -0400
Message-ID: <49FF2BB2.4030700@cosmosbay.com>
Date: Mon, 04 May 2009 19:53:54 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Matthias Saou 
	<thias@spam.spam.spam.spam.spam.spam.spam.egg.and.spam.freshrpms.net>
CC: linux-kernel@vger.kernel.org, Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: Wrong network usage reported by /proc
References: <20090504171408.3e13822c@python3.es.egwn.lan>
In-Reply-To: <20090504171408.3e13822c@python3.es.egwn.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 04 May 2009 19:53:54 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthias Saou a écrit :
> Hi,
> 
> I'm posting here as a last resort. I've got lots of heavily used RHEL5
> servers (2.6.18 based) that are reporting all sorts of impossible
> network usage values through /proc, leading to unrealistic snmp/cacti
> graphs where the outgoing bandwidth used it higher than the physical
> interface's maximum speed.
> 
> For some details and a test script which compares values from /proc
> with values from tcpdump :
> https://bugzilla.redhat.com/show_bug.cgi?id=489541
> 
> The values collected using tcpdump always seem realistic and match the
> values seen on the remote network equipments. So my obvious conclusion
> (but possibly wrong given my limited knowledge) is that something is
> wrong in the kernel, since it's the one exposing the /proc interface.
> 
> I've reproduced what seems to be the same problem on recent kernels,
> including the 2.6.27.21-170.2.56.fc10.x86_64 I'm running right now. The
> simple python script available here allows to see it quite easily :
> https://www.redhat.com/archives/rhelv5-list/2009-February/msg00166.html
> 
>  * I run the script on my Workstation, I have an FTP server enabled
>  * I download a DVD ISO from a remote workstation : The values match
>  * I start ping floods from remote workstations : The values reported
>    by /proc are much higher than the ones reported by tcpdump. I used
>    "ping -s 500 -f myworkstation" from two remote workstations
> 
> If there's anything flawed in my debugging, I'd love to have someone
> point it out to me. TIA to anyone willing to have a look.
> 
> Matthias
> 

I could not reproduce this here... what kind of NIC are you using on
affected systems ? Some ethernet drivers report stats from card itself,
and I remember seeing some strange stats on some hardware, but I cannot
remember which one it was (we were reading NULL values instead of
real ones, once in a while, maybe it was a firmware issue...)



