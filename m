Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbZJJKd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbZJJKd6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 06:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbZJJKd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 06:33:57 -0400
Received: from mail-vw0-f203.google.com ([209.85.212.203]:36000 "EHLO
	mail-vw0-f203.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbZJJKd4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 06:33:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=kgJwkJl9wvuwMDLey1ckikTgWi5LEZHXyPMPCArYto9qvc9a+4BrZ/AFcwJ7rL5X2a
         pijYHsKzo7ORsKFL0Uq8+C2QjOhwnqnrVPoGY0Jl15piptFX+LLUfvHbEPk27Ws0fowc
         iowEFef02/5Dw3u5p2qbAW3/DBR8uBAp3qBeQ=
MIME-Version: 1.0
In-Reply-To: <20091010085732.GA10923@feather>
References: <20091010085732.GA10923@feather>
Date: Sat, 10 Oct 2009 03:33:20 -0700
X-Google-Sender-Auth: a8ada4273e8f32af
Message-ID: <70318cbf0910100333m128e3500vb1659a55a9f49768@mail.gmail.com>
Subject: Re: [PATCH] New attribute designated_init: mark a struct as requiring 
	designated init
From: Christopher Li <sparse@chrisli.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-sparse@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 10, 2009 at 1:58 AM, Josh Triplett <josh@joshtriplett.org> wrote:
> Some structure types provide a set of fields of which most users will
> only initialize the subset they care about.  Users of these types should
> always use designated initializers, to avoid relying on the specific
> structure layout.  Examples of this type of structure include the many

The patch is very well written with nice documentations and test case.
It applies and runs fine.

I am curious weather this is some thing the kernel developers want to
use. Please speak up if you want to annotate the kernel structure to
issue such warning. If some one use it, I have no problem adding it to
sparse.

I am not sure how useful this is yet.  If the structure is changed, most
likely the positional initialization will fail due to type mismatching.
Some real life example how this feature can expose some otherwise
hard to detect bug would be nice.

With this approach, we need to annotate the kernel to benefit from it.
Another idea is that we can find out how different part of the kernel
initialize the same structure. If most of them using designated init then
the few non-conforming can get a warning. This approach is more
complicate.  But it does not need to change the kernel.


> +                               warning(e->pos, "%s%s%spositional init of field in %s %s, declared with attribute designated_init",
> +                                       ctype->ident ? "in initializer for " : "",
> +                                       ctype->ident ? ctype->ident->name : "",

ident->name has no guarantee of terminating by NUL.
You want to use "%.*s" with ident->size, ident->name here.

Chris
