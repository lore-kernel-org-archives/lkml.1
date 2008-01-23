Return-Path: <linux-kernel-owner+w=401wt.eu-S1754482AbYAWP1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbYAWP1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 10:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbYAWP1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 10:27:18 -0500
Received: from ns1.suse.de ([195.135.220.2]:45971 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbYAWP1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 10:27:17 -0500
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch] x86: test case for the RODATA config option
Date: Wed, 23 Jan 2008 16:27:28 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
References: <20080122144420.4ebcf95f@laptopd505.fenrus.org> <p731w88nc0p.fsf@crumb.suse.de> <20080123064905.5d05509a@laptopd505.fenrus.org>
In-Reply-To: <20080123064905.5d05509a@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801231627.28715.andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> What it does is check if the rodata marking was succesful.

The only difference I see is that you check that the TLB flush works,
but for that it looks awfully incomplete. In particular if you really
wanted to test the TLB you would need to do the access test on
all online CPUs. Otherwise you have no guarantee the TLBs are
actually changed everywhere (assuming that was broken) 

Other than it is identical [modulo the kernel mapping bit on 64bit]-- you just 
toggle a different bit in the PTE,  but c_p_a() does not actually care which 
bits you toggle.

>> Testing the kernel mapping might be a good idea, but I would
>> suggest adding it to pageattr-test.c

>where we move the actual test function... 

What I meant using the more extensive test in pageattr-test.c
to test a few changes in the 64bit kernel mapping too, not moving your
code. I don't think moving your code makes sense. Sorry for being unclear.

-Andi
