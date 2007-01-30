Return-Path: <linux-kernel-owner+w=401wt.eu-S965544AbXA3Oqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965544AbXA3Oqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 09:46:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965545AbXA3Oq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 09:46:26 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:58414 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965544AbXA3OqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 09:46:23 -0500
X-Originating-Ip: 74.109.98.130
Date: Tue, 30 Jan 2007 09:45:14 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Paul Mackerras <paulus@samba.org>,
       dhowells@redhat.com, galak@kernel.crashing.org
Subject: Re: [PATCH] Add "is_power_of_2" checking to log2.h.
In-Reply-To: <Pine.LNX.4.61.0701301512200.1147@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.64.0701300938580.24147@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0701300543420.17991@CPE00045a9c397f-CM001225dbafb6>
 <45BF3954.8050106@yahoo.com.au> <Pine.LNX.4.64.0701300753170.23302@CPE00045a9c397f-CM001225dbafb6>
 <Pine.LNX.4.61.0701301512200.1147@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jan 2007, Jan Engelhardt wrote:

>
> >> Why the qualifier? Zero *is* not a power of 2, is it?
>
> No, it is not:
>
> 	In[1]:= Solve[2^n == 0, n]
>
> 	Out[1]= {}
>
> So says Mathematica5.

oooookay, that's kind of like taking a sandblaster to a soup cracker.

seriously, though, there is the potential of breaking something with
this change since you can see how there is some inconsistency in how
it's done *now* just for powerpc which, in some places, defines its
own versions of this:

./arch/ppc/mm/pgtable.c:
	#define is_power_of_2(x) ((x) != 0 && (((x) & ((x) - 1)) == 0))
./arch/ppc/syslib/ppc85xx_rio.c:
	#define is_power_of_2(x) (((x) & ((x) - 1)) == 0)
./arch/powerpc/mm/pgtable_32.c:
	#define is_power_of_2(x) ((x) != 0 && (((x) & ((x) - 1)) == 0))

note how the first and third macros *won't* consider zero a power of
two, while the second one *will*.  hence the need for a single
standard for all of this, just to play it safe.

rday

p.s.  in case you missed it, that was a not-so-subtle plea to please
just apply this patch so we can move on.

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
