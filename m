Return-Path: <linux-kernel-owner+w=401wt.eu-S1756492AbXI1Hoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbXI1Hoj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 03:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753996AbXI1Hob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 03:44:31 -0400
Received: from smtpoutm.mac.com ([17.148.16.80]:61166 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753828AbXI1Hob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 03:44:31 -0400
In-Reply-To: <Pine.LNX.4.64.0709280922230.32185@anakin>
References: <19f34abd0709271418l471cf7b9gf24161190772fac@mail.gmail.com> <Pine.LNX.4.64.0709280922230.32185@anakin>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <DC4D133C-42B3-4CE3-A7A9-C507AE8A0B92@mac.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Michael Holzheu <holzheu@linux.vnet.ibm.com>,
       Joe Perches <joe@perches.com>, Rob Landley <rob@landley.net>,
       Dick Streefland <dick.streefland@altium.nl>,
       Jesse Barnes <jesse.barnes@intel.com>, Arnd Bergmann <arnd@arndb.de>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Emil Medve <Emilian.Medve@freescale.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "linux@horizon.com" <linux@horizon.com>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [RFC] New kernel-message logging API (take 2)
Date: Fri, 28 Sep 2007 03:44:24 -0400
To: Geert Uytterhoeven <geert@linux-m68k.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 28, 2007, at 03:31:11, Geert Uytterhoeven wrote:
> Can't you store the loglevel in the kprint_block and check it in  
> all successive kprint_*() macros? If gcc knows it's constant, it  
> can optimize the non-wanted code away. As other fields in struct  
> kprint_block cannot be constant (they store internal state), you  
> have to split it like:
>
>     struct kprint_block {
> 	    int loglevel;
> 	    struct real_kprint_block real;  /* internal state */
>     }
>
> and pass &block.real() instead of &block to all successive internal  
> functions.  I haven't tried this, so let's hope gcc is actually  
> smart enough...

Well actually, I believe you could just do:

struct kprint_block {
	const int loglevel;
	[...];
};

Then cast away the constness to actually set it initially:
*((int *)&block.loglevel) = LOGLEVEL;

Cheers,
Kyle Moffett

