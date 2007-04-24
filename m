Return-Path: <linux-kernel-owner+w=401wt.eu-S1161473AbXDXOFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161473AbXDXOFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 10:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161474AbXDXOFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 10:05:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161473AbXDXOFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 10:05:17 -0400
Message-ID: <462E0E60.5080907@redhat.com>
Date: Tue, 24 Apr 2007 16:04:16 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
       Ralf Baechle <ralf@linux-mips.org>, Andi Kleen <ak@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch v2] Fixes and cleanups for earlyprintk aka boot console.
References: <20070315154638.944768000@suse.de> <20070423234240.29427438.akpm@linux-foundation.org>
In-Reply-To: <20070423234240.29427438.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I get this, across netconsole:
> 
> [17179569.184000] console handover: boot [earlyvga_f_0] -> real [tty0]
> 
> wanna take a look at why there's cruft in bootconsole->name please?

-EFULL ;)

"earlyvga" is 8 chars.  struct console->name is char[8].  No space left 
for the trailing ´\0´, the cruft comes from the next field (write 
function pointer).  Obviously nobody ever printed the early console 
names before.

Hmm.  We can make the names shorter.  We can make the name field longer 
(probably 16, it ends up taking that much anyway due to aligments at 
least on 64bit).  This looks best to me.  We could also use 
printk("%.8s",name) to make printk stop after 8 chars, but I somehow 
don't like hardcoding the length like this ...

cheers,
   Gerd


