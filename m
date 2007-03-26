Return-Path: <linux-kernel-owner+w=401wt.eu-S1753698AbXCZS7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbXCZS7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 14:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbXCZS7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 14:59:42 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:5722 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705AbXCZS7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 14:59:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=NzuqzQkIMu6TtUa623XPACwDm4uDkrSBvGiffGGyiWEwj4uAUUXI4IPwZPGN5HOXu0yEv1NH2IVf8UUP4wrTPJZiHozFCh+srMetvsV6iq0N1GUb2YmJC6Iz6w0FqX+e4i4M3RMGKfi4qEK2RkudJsA1yxisYhEwVolg+LSWUAw=
Message-ID: <ee9e417a0703261159g6aeed343t58a98c5f45141c53@mail.gmail.com>
Date: Mon, 26 Mar 2007 14:59:39 -0400
From: "Russ Cox" <rsc@swtch.com>
To: "Christopher Li" <sparse@chrisli.org>
Subject: Re: [PATCH] Add const to pointer qualifiers for __chk_user_ptr and __chk_io_ptr.
Cc: linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
In-Reply-To: <20070326180155.GA24764@chrisli.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ee9e417a0703260823k55c6de8ay715be1db11692355@mail.gmail.com>
	 <20070326180155.GA24764@chrisli.org>
X-Google-Sender-Auth: 9eb11b7f87819c14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/26/07, Christopher Li <sparse@chrisli.org> wrote:
> On Mon, Mar 26, 2007 at 11:23:56AM -0400, Russ Cox wrote:
> > Change prototypes for  __chk_user_ptr and __chk_io_ptr
> > to take const void* instead of void*, so that code can pass
> > const void* to them.  (Right now sparse does not warn
> > about passing const void* to void* functions, but that
> > is a separate bug that I believe Josh is working on,
> > and once sparse does check this, the changed prototypes
> > will be necessary.)
>
> I don't think it is needed. The __user has noderef attribute.
> Which means it is not allow to dereference the pointer. The
> const qualifier allow read dereference, only write is not allowed.
>
> Adding const here will likely force the caller to do a cast at
> the pointer arguments. Which defeats the checker.

No, you have it backward.
It is valid to pass void* to a const void* function.
It is *not* valid to pass const void* to a void* function.

Right now __chk_user_ptr is a void* function, meaning
that all the places where it gets passed a const void*
are technically illegal -- gcc would warn about these, and
it is a (separate, as you observed) bug that sparse does not.

The patch changes __chk_user_ptr to be a const void*
function, meaning that it will be legal to pass either void*
or const void* to it.  This is the correct semantics.

Russ
