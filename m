Return-Path: <linux-kernel-owner+w=401wt.eu-S1754810AbXKWGSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbXKWGSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 01:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbXKWGSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 01:18:30 -0500
Received: from twinlark.arctic.org ([207.29.250.54]:43519 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbXKWGS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 01:18:29 -0500
Date: Thu, 22 Nov 2007 22:18:28 -0800 (PST)
From: dean gaudet <dean@arctic.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Daniel Drake <dsd@gentoo.org>, linux-kernel@vger.kernel.org,
       davem@davemloft.net, kune@deine-taler.de, johannes@sipsolutions.net
Subject: Re: [RFC] Documentation about unaligned memory access
In-Reply-To: <20071123012911.3266dba6@the-village.bc.nu>
Message-ID: <alpine.DEB.0.99999.0711222206000.32648@twinlark.arctic.org>
References: <20071123001554.12F8B9D4A1F@zog.reactivated.net> <20071123012911.3266dba6@the-village.bc.nu>
User-Agent: Alpine 0.99999 (DEB 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Nov 2007, Alan Cox wrote:

> Its usually faster if you don't misalign on x86 as well.

i'm not sure if i agree with "usually"... but i know you (alan) are 
probably aware of the exact requirements of the hw.

for everyone else:

on intel x86 processors an access is unaligned only if it crosses a 
cacheline boundary (64 bytes).  otherwise it's aligned.  the penalty for 
crossing a cacheline boundary varies from ~12 cycles (core2) to many 
dozens of cycles (p4).

on AMD x86 pre-family 10h the boundary is 8 bytes, and on fam 10h it's 16 
bytes.  the penalty is a mere 3 cycles if an access crosses the specified 
boundary.

if you're making <= 4 byte accesses i recommend not worrying about 
alignment on x86.  it's pretty hard to beat the hardware support.

i curse all the RISC and embedded processor designers who pretend 
unaligned accesses are something evil and to be avoided.  in case you're 
worried, MIPS patent 4,814,976 expired in december 2006 :)

-dean
