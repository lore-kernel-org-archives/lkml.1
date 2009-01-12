Return-Path: <linux-kernel-owner+w=401wt.eu-S1756223AbZALUAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbZALUAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 15:00:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756070AbZALUAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 15:00:08 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44712 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984AbZALUAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 15:00:06 -0500
Date: Mon, 12 Jan 2009 21:14:35 +0100
From: Andi Kleen <andi@firstfloor.org>
To: =?iso-8859-1?Q?R=E9mi?= Denis-Courmont <rdenis@simphalempin.com>
Cc: Andi Kleen <andi@firstfloor.org>, Valdis.Kletnieks@vt.edu,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Michael Stone <michael@laptop.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: RFC: Network privilege separation.
Message-ID: <20090112201435.GC23848@one.firstfloor.org>
References: <1231307334-9542-1-git-send-email-michael@laptop.org> <12821.1231785850@turing-police.cc.vt.edu> <20090112194333.GB23848@one.firstfloor.org> <200901122147.57731.rdenis@simphalempin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901122147.57731.rdenis@simphalempin.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Expanding the heap,

That's a problem agreed  Ok you can just always use very
bss arrays sized for the worst case.

> Getting timestamps. 

At least on 64bit that's done in ring 3 only with a vsyscall.

> Waiting on futexes, 
> catching signals, polling file descriptors. Seeking, doing vectorized I/O. 
> Cloning.

That all can be done by the frontend reading/feeding
data into the pipe. But it shouldn't directly access the user data
to be immune against attacks.

> Codecs don't like to read/write raw video through a pipe...

I don't think that's given. It would need some restructuring,
but I think the end result would be likely worth it.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
