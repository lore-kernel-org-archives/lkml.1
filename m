Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbZLVBKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbZLVBKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 20:10:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbZLVBKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 20:10:09 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:47628 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbZLVBKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 20:10:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=GvYlDz+0+mY7zWcSMpXqhVuYs7a8cmfo7jKMkumwGVksQN0ZGHUKllG3UjIXr51x66
         DFsdmbsJOkOWzdz+x/M3PNfx7Fv0kAi7R6RlEC4zzZ6kh/8jk1G33vqbxsgzjTDIkIP/
         0yBk/65VSz8CKlDM+xInfgwUDTRxkk6YY7Yuo=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0912211944050.19919@dr-wily.mit.edu>
References: <2b41c200912211621p72eceed5tb9f9711b2f96b72e@mail.gmail.com>
	 <alpine.DEB.1.10.0912211926100.19919@dr-wily.mit.edu>
	 <2b41c200912211639p30927d84k9253ac7c90ac0e68@mail.gmail.com>
	 <alpine.DEB.1.10.0912211944050.19919@dr-wily.mit.edu>
Date: Tue, 22 Dec 2009 02:10:06 +0100
Message-ID: <2b41c200912211710m11f1ebbbjc3d30c67e9e49944@mail.gmail.com>
Subject: Re: [REGRESSION] um: CONFIG_STATIC_LINK=y broken
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Tim Abbott <tabbott@ksplice.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding the ALIGN(PAGE_SIZE) causes the segfault.
But I cannot tell you why. :-(

Cheers,
//richard

2009/12/22, Tim Abbott <tabbott@ksplice.com>:
> On Tue, 22 Dec 2009, richard -rw- weinberger wrote:
>
>> This is the bad changeset:
>
> Thanks for tracking that down.  INIT_TEXT_SECTION is:
>
> #define INIT_TEXT_SECTION(inittext_align)                               \
>         . = ALIGN(inittext_align);                                      \
>         .init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {               \
>                 VMLINUX_SYMBOL(_sinittext) = .;                         \
>                 INIT_TEXT                                               \
>                 VMLINUX_SYMBOL(_einittext) = .;                         \
>         }
>
> So there are only 3 code changes here:
> (1) wrapping _sinittext and _einittext in VMLINUX_SYMBOL
> (2) Adding the AT(ADDR(.init.text) - LOAD_OFFSET)
> (3) The added ALIGN(PAGE_SIZE) before the start of .init.text.
>
> I don't yet see why any of these would be problematic; would you be
> willing to try them and figure out the precise cause?
>
> I suspect it'd be easiest for you to try those individual changes
> interactively, but if it's not trivial for you, I'd be happy to generate a
> patch series splitting out this change into pieces for you to bisect.
>
> 	-Tim Abbott
>
