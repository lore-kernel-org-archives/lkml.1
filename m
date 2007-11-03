Return-Path: <linux-kernel-owner+w=401wt.eu-S1756509AbXKCQH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbXKCQH7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 12:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754204AbXKCQHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 12:07:50 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:12462 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbXKCQHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 12:07:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IaU3j0w8l5zHIwHU2pd7MM2YYdjKnzv/MWBUVuSjc2S4d43IjQplWZZlUCEQBKmtlriuSGdgkmbPkWXKLlxlNRb6HdBsEVZaThtFvVO/6WSoIV6PEws4h5iM/8akVUT8a/qYZSoTZdYNOlJztOEOtC/1D5Ed9/aExWTTRWmOfhQ=
Message-ID: <b1c6420f0711030907g10149e1asda1afe4e2f3c8e02@mail.gmail.com>
Date: Sun, 4 Nov 2007 01:07:47 +0900
From: "Suzuki Takashi" <suzuki.takashi@gmail.com>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: [Linux-am33-list] [PATCH 2/2] MN10300: Add the MN10300/AM33 architecture to the kernel [try #2]
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <13581.1193831186@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071029122759.2846.83510.stgit@warthog.procyon.org.uk>
	 <20071029122809.2846.58795.stgit@warthog.procyon.org.uk>
	 <b1c6420f0710300740t5c708933x7ab1716c76504c57@mail.gmail.com>
	 <20112.1193774645@redhat.com>
	 <b1c6420f0710301703n5c330ae2idb75c9a5703d5e7c@mail.gmail.com>
	 <13581.1193831186@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your replies.

On 10/31/07, David Howells <dhowells@redhat.com> wrote:
> Anyway, I've discussed this with MEI, and they're willing for some flattening
> to take place.

I'm very annoyed and a bit surprised to hear they admitted such a big
change so easily.

You and I know there are consumer devices already out running the am33
port of the kernel.
I guess they have some policy for the port, including the directory
structure under arch/,
if they have already shipped several versions of the kernel on their
commercial products.
If so, they would take objection to the change, partly or entirely, I think.

I suspect that your port is not a version of the line of the proven,
running kernels
on the shipped products and that your client is not, or doesn't have
contact with,
the developers of the running kernels.

I have taken a look at the kernels for am33 on www.am-linux.jp (*).
What triggered me to comment on your patch was
that its directory and file structure is very different from the ones there.
There are no cpu-, proc- and unit- directories and no names with
mn103e10_* there.

The kernels there seem to be already running on several processors,
some of which are with AM34 cores that you concern about, according to
the #ifdefs there.

I thought at first your port was the revised one after refactoring,
but it has turned out not to be.
You should let your client to discuss with all the developers
concerned in the whole company.

(*) Only a version of an old model is linked from the top page.
Newer models appear to have their unique URIs, and there are v2.6
kernels there, too.

> The problem is how much?  I could just move all the
> cpu-am33v2/ files into the dir above, but what happens if an incompatible CPU
> core is introduced?

How does your client say?
Ok, I agree it's the preparation for incompatible CPU cores.
There might be no incompatible CPU core, currently, though.
But I have become worried about the incompatibility with the running kernels
that have no cpu/ directories.

> It's an awkward situation, yes, but not one most people will be concerned
> with.  There needs to be some way to multiplex alternate register sets.  The
> main ways of doing that are:
>
>  (1) #include hell
>
>  (2) #ifdef hell
>
>  (3) Both
>
> Which do you prefer?

Do the company accept my personal preference?
I prefer (2), as long as the difference is only an addition or the
difference is small enough.

> However, I'll concede that the various versions of AM33 processor should
> perhaps be represented by the same CPU subdirectory (cpu-am33), using #ifdef
> to add extra features.  However, should, say, an AM34 be produced that's
> effectively a variant of the AM33, then that scheme falls down too.

As I said in the other thread,
am33 is a reasonable name if  the AM33 is the first one that is
supported by the port
and the AM34 and newer ones are compatible with that.

> And if all asm/cpu-regs.h does is #include asm/cpu/cpu-regs.h, then what's the
> point in having it?

I meant if there is only an asm/cpu-regs.h and no cpu/ directory at first and
later cpu-regs.h comes up in the cpu/ directories for cpu variants,
you don't have to change the ``#include <asm/cpu-regs.h>'' in the
arch-dependent codes.
cpu-regs.h may not be good for an example.


Anyway, I have no doubt that your port is too immature to be merged
into the upstream kernel.
It doesn't mean there is any technical problem. I understand your position.


-- 
Suzuki Takashi
Japan
