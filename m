Return-Path: <linux-kernel-owner+w=401wt.eu-S1758885AbYJPXQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885AbYJPXQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 19:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757370AbYJPXQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 19:16:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:13631 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756781AbYJPXQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 19:16:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HGPJkXS+LnExPdixRUl5jxIc73d7of1qM6YhRQC4KZUohV2PzQpNr5mmKlLr5Sy5aV
         manEyf4zIFLFXmx1cgefDuWAdZNy8V/ShZ/x5NSY9rLZac1ir02f9rNOKzX45BB3OXWa
         PjlQY5/HFdlymY57JVDocliEsk2zn1u7ZGNxE=
Message-ID: <c62985530810161616ycd3daddu61c0bbc36908fff8@mail.gmail.com>
Date: Fri, 17 Oct 2008 01:16:09 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [git pull] core kernel updates for v2.6.28
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Kumar Gala" <galak@kernel.crashing.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Becky Bruce" <becky.bruce@freescale.com>
In-Reply-To: <alpine.LFD.2.00.0810161548520.3288@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081015125023.GA6702@elte.hu>
	 <alpine.LFD.2.00.0810161518320.3288@nehalem.linux-foundation.org>
	 <c62985530810161543q23f9ae75jb08ff986a214da0@mail.gmail.com>
	 <alpine.LFD.2.00.0810161548520.3288@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/17 Linus Torvalds <torvalds@linux-foundation.org>:
> Well, the thing is, on 32-bit x86, ptrdiff_t is "int". And on 64-bit, it's
> "long". And on some (most?) other architectures, it's "long" regardless of
> whether it's 32-bit or 64-bit.
>
> So you fixed a warnign on x86-32, but you introduced it just about
> everywhere else.
>
> And it so happens that the old use of "%ld" was better than "%d", because
> regardless of the exact type of ptrdiff_t, with gcc it is essentially
> always going to be at least the same _size_ as "long". IOW, even when it's
> "int", it will always print out correctly with "%ld", despite the format
> warning. IOW, the type may be "wrong" from a C standards standpoint, but
> it will work in practice.
>
> In contrast, using "%d" can actually print it out wrong, because it will
> be literally the wrong physical size, not just a type issue on a C level.
> So depending on calling conventions, you might end up with the upper bits
> cleared, or even the wrong bits printed out.
>
> Using "%td" is always right, assuming the underlying printing library is
> recent enough to know about it. And the kernel has known about %td for the
> last three years.
>
>                        Linus

Oops you're right my fix made things worst than before.
I will be aware of this %td for the future.

Thanks for the explanations Linus.
