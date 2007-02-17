Return-Path: <linux-kernel-owner+w=401wt.eu-S965407AbXBQXze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965407AbXBQXze (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 18:55:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965412AbXBQXze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 18:55:34 -0500
Received: from wr-out-0506.google.com ([64.233.184.226]:59494 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965407AbXBQXzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 18:55:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dmMUGJlhFC0MR0V3DfMAgQy2/kNvRdo9guRrYg6yuyq68uhqSM4GUEt4caNvFT6Q9gJWctLfP+l/AjlrdzJlAgQYgZmJbVtgpxH3h9v+bhOWeAuSxdJhn4Ezwfmbe8k68Ant1nbHN0JmOPYmilI31gBlfftr7ImjxQUWWDiYCAc=
Message-ID: <f2b55d220702171555k1fde2e0ah2f46d5c2c1016a1e@mail.gmail.com>
Date: Sat, 17 Feb 2007 15:55:27 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Giuseppe Bilotta" <giuseppe.bilotta@gmail.com>
Subject: Re: GPL vs non-GPL device drivers
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <er837a$8ks$1@sea.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <er6mdq$ti8$1@sea.gmane.org>
	 <MDEHLPKNGKAHNMBLJOLKKEKKBKAC.davids@webmaster.com>
	 <er837a$8ks$1@sea.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/17/07, Giuseppe Bilotta <giuseppe.bilotta@gmail.com> wrote:
> Which shows how that case is different from writing Linux drivers. For
> example, looking at the example the OP was himself proposing a few
> alternative approaches to work around the limitation they were hitting:
> could just switch to static major/minors instead of dynamics ones, they
> could skip sysfs, or they could even reimplement something like sysfs
> themselves, or whatever other interface they deem useful for the purpose of
> plopping in their own binary blob on top of it, sort of like what nVidia
> and ATi do for their stuff.

Or they could run:
    find . -type f -exec perl -i.bak -pe 's/EXPORT_SYMBOL_GPL/EXPORT_SYMBOL/g'
and be done with it.  Or even just MODULE_LICENSE("GPL") in their
module -- that's not "lying about the module license", it's "doing the
minimum necessary in order to interoperate efficiently with the
kernel".  Atari v. Nintendo is still good law, but _only_ to the
extent that it does not conflict with Lexmark, which now has the seal
of Supreme Court approval.  And (IMHO, IANAL) if writing
MODULE_LICENSE("GPL") is obviously the only remotely efficient way to
achieve the goal of interoperation with the kernels that people
already have on their systems, through the documented, tested,
currently recommended APIs (like sysfs), then you have a Sega / Altai
/ Lexmark fact pattern, not an Atari v. Nintendo fact pattern.

So what's the penalty for MODULE_LICENSE("GPL") on code that is not
actually offered under the GPL?  Being shunned by the kernel
community.  Maintaining a fork.  Getting to keep both halves when it
breaks.  Friends don't let friends write non-GPL drivers.  But friends
also don't let friends go off into delusional spasms of denial.
nVidia and ATI do what they do so that their code has more than a
snowball's chance in hell of running on people's desktops, not out of
fear that the Big Bad LKML Wolf will come blow down their houses.
Their hardware is doubtless so fiddly and buggy and crash-prone that
four out of five attempts to compile a driver for it reorder the
instructions enough to slag the GPU, under Windows or Linux.  _That's_
why they ship binary drivers.  Capisce?

Cheers,
- Michael
