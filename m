Return-Path: <linux-kernel-owner+w=401wt.eu-S1759821AbYDNIW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759821AbYDNIW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 04:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755636AbYDNIWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 04:22:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40124 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002AbYDNIWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 04:22:48 -0400
Date: Mon, 14 Apr 2008 09:22:20 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, mingo <mingo@redhat.com>,
       tglx <tglx@linutronix.de>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 10 (arch/x86)
Message-ID: <20080414082220.GZ9785@ZenIV.linux.org.uk>
References: <20080410181404.b76939a6.sfr@canb.auug.org.au> <20080410150950.5913b16a.randy.dunlap@oracle.com> <20080411074631.GB6410@elte.hu> <20080411081901.f56f5180.randy.dunlap@oracle.com> <20080411152648.GK9785@ZenIV.linux.org.uk> <20080414081220.GA19865@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414081220.GA19865@elte.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 10:12:20AM +0200, Ingo Molnar wrote:

> well, gcc does not "recover", we _gave_ it the format string as a 
> constant, and do so in 99.9% of the cases. It is a totally 
> well-specified thing.

It is an undefined behaviour according to any variant of C standard.
Sorry, printf() is not magic and it does _not_ have special calling
conventions.

> but the constant noise from gcc about printf formats, where the 
> conversion is very clear and could be done implicitly, only hinders us 
> and only teaches people to _ignore_ gcc warnings - which is actually 
> very dangerous.
> 
> the only warning from gcc in this area should be where the format 
> results in information _loss_ (i.e. the format has a narrower type than 
> we pass into it) - there a warning is very much needed - and the 
> programmer should then fix the bug or add a cast.

No, sorry.  That kind of mismatch is simply not a valid C.  Plain as that,
read the standard and you'll see.

Fundamentally, printf() is a function like any other vararg one.  So
explicitly typed arguments *are* the right thing to do.

What is not right is the lack of ability to define new conversions.  If
we could do that, we would kill the absolute majority of casts - and
remain within normal C limits...
