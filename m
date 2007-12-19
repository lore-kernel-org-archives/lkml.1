Return-Path: <linux-kernel-owner+w=401wt.eu-S1753399AbXLSJLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbXLSJLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 04:11:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbXLSJL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 04:11:29 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:48860 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbXLSJLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 04:11:21 -0500
Message-ID: <4768E02F.20700@cosmosbay.com>
Date: Wed, 19 Dec 2007 10:11:11 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: dotanb@dev.mellanox.co.il
CC: linux-kernel@vger.kernel.org
Subject: Re: The code segment of the user level in PPC64 are in VMAs with
 write permissions
References: <4768C675.1030804@dev.mellanox.co.il>
In-Reply-To: <4768C675.1030804@dev.mellanox.co.il>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Wed, 19 Dec 2007 10:11:18 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dotan Barak a écrit :
> Hi all.
> 
> I noticed that the code segment of the user level in PPC64 machines
> is in a VMA with a write permission enabled.
> 
> I'm using the following machine attributes:
> *************************************************************
> Host Name         : mtlsqt185
> Host Architecture : ppc64
> Linux Distribution: SUSE Linux Enterprise Server 10 (ppc) VERSION = 10 
> PATCHLEVEL = 1
> Kernel Version    : 2.6.16.53-0.16-ppc64
> GCC Version       : gcc (GCC) 4.1.2 20070115 (prerelease) (SUSE Linux)
> Memory size       : 1740232 kB
> Number of CPUs    : 8
> cpu MHz           : 4005.000000MHz
> Driver Version    : OFED-1.2.5.4-20071210-0614
> HCA ID(s)         : mlx4_0
> HCA model(s)      : 25418
> FW version(s)     : 2.3.906
> Board(s)          : IBM08A0000001
> *************************************************************
> 
> I printed the address of a function in my program and i got the value 
> 0x1005ac80.
> 
> I printed the VMAs in my process and i got the following output:
> mtlsqt185:~ # cat /proc/17366/maps
> 00100000-00103000 r-xp 00100000 00:00 0
> 10000000-1004a000 r-xp 00000000 08:03 1063667                            
> /tmp/tsscr/svn.mlx_tp/branches/ofed1.2.5/gen2/userspace/useraccess/gen2_basic/gen2_basic 
> 
> 1005a000-1005e000 rw-p 0004a000 08:03 1063667                            
> /tmp/tsscr/svn.mlx_tp/branches/ofed1.2.5/gen2/userspace/useraccess/gen2_basic/gen2_basic 
> 
> 1005e000-1015f000 rw-p 1005e000 00:00 0                                  
> [heap]
> 
> Is this is a security hole (any virus can change the code in the code 
> segment ...)
> 
> can you please CC me the answers o this question?
> 

This is because on PPC architecture, address of a function points to a small
data area (a function descriptor) where the caller can find informations about :

- Address (in the text segment, so readonly) of the target function
- Address of the TOC for this function.


http://www.linux-foundation.org/spec/ELF/ppc64/PPC-elf64abi-1.9.html#FUNC-ADDRESS
