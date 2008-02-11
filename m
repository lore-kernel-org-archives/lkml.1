Return-Path: <linux-kernel-owner+w=401wt.eu-S1755080AbYBKPNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080AbYBKPNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 10:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbYBKPNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 10:13:06 -0500
Received: from ns2.suse.de ([195.135.220.15]:38243 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413AbYBKPNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 10:13:05 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] [7/8] CPA: Don't flush caches on CPUs that support self-snoop
Date: Mon, 11 Feb 2008 16:12:56 +0100
User-Agent: KMail/1.9.6
Cc: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
References: <200802111050.372086035@suse.de> <20080211095022.7B8C31B41CE@basil.firstfloor.org> <20080211070430.099fbded@laptopd505.fenrus.org>
In-Reply-To: <20080211070430.099fbded@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802111612.56662.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 February 2008 16:04:30 Arjan van de Ven wrote:
> On Mon, 11 Feb 2008 10:50:22 +0100 (CET)
> Andi Kleen <ak@suse.de> wrote:
> 
> > 
> > [2.6.25 candidate I believe]
> > 
> > The specification of SS in the public manuals is a little unclear,
> > but I got confirmation from Intel that SS implies that there is no
> > cache flush needed on caching attribute changes.
> 
> I'm hearing slightly different information, but am still chasing this one.

10.12.8 in the ia32 manual volume 3a says:

"
When remapping a page that was previously mapped as a cacheable memory type to
a WC page, an operating system can avoid this type of aliasing by doing the
following:
...

3. Create a new mapping to the same physical address with a new memory type, for
   instance, WC.
4. Flush the caches on all processors that may have used the mapping previously.
   Note on processors that support self-snooping, CPUID feature flag bit 27, this
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   step is unnecessary.
   ^^^^^^^^^^^^^^^^^^^^
"

That is exactly the situation in pageattr.c. You're saying the manual is wrong
here?

> It might be better to delay this one to .26 ;-(
> (I would very much like to avoid the cache flush but... it really HAS to be safe)

Unless there are known errata (i'm not aware of any) it is safe according to the manual.

-Andi

 
