Return-Path: <linux-kernel-owner+w=401wt.eu-S1755119AbZAEPrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbZAEPrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 10:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbZAEPrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 10:47:01 -0500
Received: from mout-xforward.kundenserver.de ([212.227.17.5]:64873 "EHLO
	mout-xforward.kundenserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750814AbZAEPrA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 10:47:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: Lock-up on PPC64
Date: Mon, 5 Jan 2009 16:46:02 +0100
User-Agent: KMail/1.9.9
Cc: malc <av1474@comtv.ru>, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0812212058550.2164@linmac.oyster.ru> <1230165163.7292.32.camel@pasglop> <Pine.LNX.4.64.0812280335070.2526@linmac.oyster.ru>
In-Reply-To: <Pine.LNX.4.64.0812280335070.2526@linmac.oyster.ru>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901051646.03654.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+j6u0NdWJv97hahDTvVzw/yeGQPhMHV27Yru6
 aq5G8YfGwVCg56ONnACyJfAQ//caa6w/JD80Y9MvPC/RLgBu68
 e/WGRkmHitrHcMgpl3n/w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 December 2008, malc wrote:
> Now to the Christmas cheer, i've tried v2.6.28 and couldn't help but
> notice that the problem is gone, bisecting v2.6.27 (which funnily i
> had to mark good) to v2.6.28 (which has to be marked bad) wasn't fun
> but eventually converged at ab598b6680f1e74c267d1547ee352f3e1e530f89
> 
> commit ab598b6680f1e74c267d1547ee352f3e1e530f89
> Author: Paul Mackerras <paulus@samba.org>
> Date:   Sun Nov 30 11:49:45 2008 +0000
> 
>      powerpc: Fix system calls on Cell entered with XER.SO=1
> 
> Now the lock-up is gone, however the code never exercises the path
> taken during the lock-up so i guess it, at least, deserves a better
> look by PPC64 care takers.


Yes, this change was suspected to help with Mono as well, not just
Java, because both of them use their own syscall path rather than
going through glibc. The reason why you see the lock-up in a different
place is because the bug manifested in getting incorrect syscall
return codes, which probably made mono go into a normally unused
error handling case.

	Arnd <><
