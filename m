Return-Path: <linux-kernel-owner+w=401wt.eu-S1763885AbXGWQaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763885AbXGWQaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759431AbXGWQap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:30:45 -0400
Received: from ns.suse.de ([195.135.220.2]:42765 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759488AbXGWQap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:30:45 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Subject: Re: [PATCH 2/8] i386: bitops: Rectify bogus "Ir" constraints
Date: Mon, 23 Jul 2007 18:30:40 +0200
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, jh@suse.cz
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in> <200707231810.08445.ak@suse.de> <Pine.LNX.4.64.0707232145270.22155@cselinux1.cse.iitk.ac.in>
In-Reply-To: <Pine.LNX.4.64.0707232145270.22155@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707231830.40331.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Whoa, thanks for explaining that to me -- I didn't know, obviously. I had
> just written a test program that used "Ir" with an automatic variable
> defined in the inline function (as is the case with these bitops) and
> observed that even when I gave > 32 values, it would still work -- hence
> my conclusion.
> 
> However, the patch still stands, does it not? [ I will modify the
> changelog, obviously. ] The thing is that we don't want to limit
> @nr to <= 31 in the first place, or am I wrong again? :-)

These bit operations only allow 8 bit immediates, so 0..255 would
be correct. N might work from the 4.1 docs, but I don't know if it works 
in all old supported gccs (3.2+)

However I is definitely not wrong and most bit numbers are small anyways.

-Andi
