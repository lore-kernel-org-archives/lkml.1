Return-Path: <linux-kernel-owner+w=401wt.eu-S1756482AbZCABic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482AbZCABic (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 20:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755001AbZCABiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 20:38:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:57550 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbZCABiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 20:38:23 -0500
Date: Sat, 28 Feb 2009 17:38:13 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       mingo@elte.hu, nickpiggin@yahoo.com.au, sqazi@google.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [patch] x86, mm: pass in 'total' to __copy_from_user_*nocache()
Message-ID: <20090228173813.6d86c0ef@infradead.org>
In-Reply-To: <20090301014822.GG26292@one.firstfloor.org>
References: <alpine.LFD.2.00.0902280904271.3111@localhost.localdomain>
	<20090228092450.3ded2db5@infradead.org>
	<alpine.LFD.2.00.0902280935010.3111@localhost.localdomain>
	<20090228.160651.228301019.davem@davemloft.net>
	<20090301004003.GF26292@one.firstfloor.org>
	<49A9D6CA.30906@zytor.com>
	<20090228163811.48b1de72@infradead.org>
	<20090301014822.GG26292@one.firstfloor.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Mar 2009 02:48:22 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> > the entire point of using movntq and friends was to save half the
> 
> I thought the point was to not pollute caches? At least that is 
> what I remember being told when I merged the patch.
> 

the reason that movntq and co are faster is because you avoid the
write-allocate behavior of the caches....

the cache polluting part of it I find hard to buy for general use (as
this discussion shows)... that will be extremely hard to measure as
a real huge thing, while the WA part is like a 1.5x to 2x thing.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
