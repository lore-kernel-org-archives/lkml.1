Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbYKEAHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbYKEAHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 19:07:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753570AbYKEAG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 19:06:56 -0500
Received: from rv-out-0506.google.com ([209.85.198.225]:45931 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbYKEAGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 19:06:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mzyvH6pyoDOmbrxtkzcdzJngqQ2P+wIF0JRaW8FmrIWvU5xgXzKyiYd0cyZnQ8Nzz+
         xxVMfpZfmZNXgD5p4/JlNKJNhPofmlzjROkv6RXZKK8tk5Bg3pxJo7f7OOUGGjGw2u/E
         BKNMhFpMC9qSp7uadCEEwRtW5W2O4gxF2LMw0=
Message-ID: <8bd0f97a0811041606n7f712ddbt399e72576110a000@mail.gmail.com>
Date: Tue, 4 Nov 2008 19:06:53 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [PATCH] UIO: only call pgprot_noncached if defined
Cc: "Mike Frysinger" <vapier@gentoo.org>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081029205347.GC2951@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225301177-21406-1-git-send-email-vapier@gentoo.org>
	 <20081029205347.GC2951@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 15:53, Hans J. Koch wrote:
> On Wed, Oct 29, 2008 at 01:26:17PM -0400, Mike Frysinger wrote:
>> Not all arches support pgprot_noncached (like the Blackfin port).
>
> These archs have it (just a quick grep, might be incomplete):
> x86, sh, alpha, powerpc, ia64, sparc, sparc64, mips, avr32, arm, parisc.
>
> That's 11 archs _with_ pgprot_noncached(). Might be a good idea to add
> that macro to blackfin, too.

when i looked i got the feeling that the arches that could support
this added it, and those that couldnt did not.  the Blackfin arch
cannot support per-page caching behavior (well, we can with the MPU
turned on, but the overhead of the MPU makes it unrealistic for
production deployment in most cases), so we do not have it defined.

there doesnt seem to be any real documentation on this function though ...

>> Other
>> drivers seem to handle this by checking to see if it is defined,
>
> That statement made me curious. I greped around for a while, but the
> only driver that does this check is drivers/char/mem.c, while there are
> 22 drivers that use pgprot_noncached() without checking.

i was ignoring the drivers that are not generic as i dont think
they're relevant.  that cuts out quite a few of those "22 drivers".

>> so let's do that in the UIO driver as well.
>
> Well, your patch is surely OK and will work, but I've got some
> difficulties to understand why you prefer patching an ugly #ifdef into up
> to 22 drivers instead of just defining that simple macro in your arch,
> like many of the others already did. But maybe I missed the point
> here, could you please elaborate a bit?

it doesnt make sense to ifdef a driver that only works on a single
arch or two and has hardware support for this function (and thus has
it defined).
-mike
