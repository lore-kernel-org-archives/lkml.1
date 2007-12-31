Return-Path: <linux-kernel-owner+w=401wt.eu-S1757370AbXLaQqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbXLaQqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 11:46:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbXLaQqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 11:46:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:48207 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbXLaQqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 11:46:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=n1dO6ew2sXgFFf7P07csli1ZJXXaGIcDyftOuvsM4ytbCzAsFo4jQ5T/vx2ZczJKK/TOzujX9QTxXR7dtrUbGM5A/+ourrCbCbqE1oYXrbepIctChssLnrCGsJ+Hru9sc2LCleAhG78nYuAd5JYe0SMrqW2PFqJHpMU3/r1lqBw=
Date: Mon, 31 Dec 2007 19:46:24 +0300
To: Ingo Molnar <mingo@elte.hu>
Cc: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       glommer@gmail.com, tglx@linutronix.de, ehabkost@redhat.com,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com, roland@redhat.com
Subject: Re: [PATCH 1/2] remove __init modifier from header declaration
Message-ID: <20071231164624.GA1738@martell.zuzino.mipt.ru>
References: <11979967763153-git-send-email-gcosta@redhat.com> <20071219101236.GB3521@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071219101236.GB3521@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2007 at 11:12:36AM +0100, Ingo Molnar wrote:
> * Glauber de Oliveira Costa <gcosta@redhat.com> wrote:
> 
> > This patch removes the __init modifier from an extern function 
> > declaration in acpi.h.
> > 
> > Besides not being strictly needed, it requires the inclusion of 
> > linux/init.h, which is usually not even included directly, increasing 
> > header mess by a lot.
> 
> thanks, applied.
> 
> btw., people have been talking about reducing the include file mess for 
> nearly a decade now,

Some of us are actually doing it. ;-)

> but it didnt get that much better - at least not in 
> include/asm-x86/*.h.

That's because hunting in include/linux/ is much more fruitful -- it
decreases amount of code after preprocessing for everyone. Below are
allyesconfig on x86_64 results for some kernels:

	$ wc ../*.i
	   79018171   229433654  2049266884 ../2.6.18.i
	   86568111   250674099  2245115663 ../2.6.19.i
	   85187296   247470579  2221334183 ../2.6.20.i		<===
	   88645422   242396928  2234855428 ../2.6.21.i
	   93897302   257990496  2377174442 ../2.6.22.i
	   98381373   268683402  2486321956 ../2.6.23.i

E.g. we can have ~1.07% decrease in cpp output despite ~126000 lines
added between .19 and .20.

> So include file dependency flattening patches would 
> be more than welcome as well.

Yup! Provided they're compile-tested sufficiently well.

> (and unlike unification patches they have 
> no expectation of being 100% perfect, so a natural ping-pong of fixes, 
> until the changes are fully correct, would be natural.)

That way you'll never clean anything especially during merge window. ;-)
