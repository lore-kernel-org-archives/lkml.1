Return-Path: <linux-kernel-owner+w=401wt.eu-S1758167AbXLRPRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167AbXLRPRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 10:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbXLRPRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 10:17:45 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:7494 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948AbXLRPRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 10:17:44 -0500
Message-ID: <4767E36A.1030700@fr.ibm.com>
Date: Tue, 18 Dec 2007 16:12:42 +0100
From: Daniel Lezcano <dlezcano@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: 2.6.24-rc5-mm1 - IPv6 throws section mismatches.
References: <20071213024050.7d6e5f3e.akpm@linux-foundation.org> <4509.1197958248@turing-police.cc.vt.edu>
In-Reply-To: <4509.1197958248@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Thu, 13 Dec 2007 02:40:50 PST, Andrew Morton said:
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc5/2.6.24-rc5-mm1/
> 
> git-net.patch (I'm guessing one of Daniel's commits, but not sure which one)
> causes some complaints:
> 
>   LD      vmlinux.o
>   MODPOST vmlinux.o
> WARNING: vmlinux.o(.init.text+0x2263f): Section mismatch: reference to .exit.text:tcpv6_exit (between 'inet6_init' and 'ac6_proc_init')
> WARNING: vmlinux.o(.init.text+0x22644): Section mismatch: reference to .exit.text:udplitev6_exit (between 'inet6_init' and 'ac6_proc_init')
> WARNING: vmlinux.o(.init.text+0x22649): Section mismatch: reference to .exit.text:udpv6_exit (between 'inet6_init' and 'ac6_proc_init')
> WARNING: vmlinux.o(.init.text+0x22658): Section mismatch: reference to .exit.text:addrconf_cleanup (between 'inet6_init' and 'ac6_proc_init')
> WARNING: vmlinux.o(.init.text+0x226bc): Section mismatch: reference to .exit.text:rawv6_exit (between 'inet6_init' and 'ac6_proc_init')
> 
> Looks like the problem is that tcpv6_exit and friends are called from
> net/ipv6/af_inet6.c:inet6_init() - which is declared as:
> 
> static int __init inet6_init(void)
> 
> I can see how calling an __exit from an __init would be Bad Juju...
> 

Yep, thanks Valdis for pointing that.

I sent a patch several days ago which fix that to DaveM and he applied 
it to the latest net-2.6.25

-- 






















































Sauf indication contraire ci-dessus:
Compagnie IBM France
Siège Social : Tour Descartes, 2, avenue Gambetta, La Défense 5, 92400
Courbevoie
RCS Nanterre 552 118 465
Forme Sociale : S.A.S.
Capital Social : 542.737.118 ?
SIREN/SIRET : 552 118 465 02430
