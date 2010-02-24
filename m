Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758454Ab0BXWYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 17:24:48 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:61575 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758423Ab0BXWYp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 17:24:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Ku/LDXwLfkbO+vs7xCBx7s9hfSKzLzSXGNxnw0KRoyyFdLI4sCglHJN4TqtXcLSiRy
         hEUY592yeWStU9g2mb+/wYlcu73X7D406X+moUeWFazOiHOI8OyMFOImBDG9Ef2Qh2kd
         PpMHaBd4w4cPBDy6MuPUQJmqX9US856Ff/eMQ=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1002221357280.2701@utopia.booyaka.com>
References: <4B781E05.9040502@gmail.com> <alpine.DEB.2.00.1002221357280.2701@utopia.booyaka.com>
From: roel kluin <roel.kluin@gmail.com>
Date: Wed, 24 Feb 2010 23:24:23 +0100
Message-ID: <25e057c01002241424s71cc447di4cb93de895cb665b@mail.gmail.com>
Subject: Re: [PATCH] OMAP: Dereference of NULL autodep in _autodep_lookup()
To: Paul Walmsley <paul@pwsan.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-omap@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thanks for the patch, but I don't understand what problem you're
> pointing out.  If autodeps is NULL entering clkdm_init(), then the
> for-loop won't even be entered.

My first patch was wrong, but there's something I think could
be wrong. In clkdm_init() we have:

for (autodep = autodeps; autodep->pwrdm.ptr; autodep++)
        _autodep_lookup(autodep);

In _autodep_lookup() we ensure that we don't dereference
autodep by:

if (!autodep)
        return;

but if autodep can be NULL we already dereferenced it in
the aforementioned for loop, so shouldn't that be:

for (autodep = autodeps; autodep && autodep->pwrdm.ptr; autodep++)
        _autodep_lookup(autodep);

Then since this is the only call to _autodep_lookup() we can remove
that test there. Do you agree?

> It looks like there may be a problem, however, in _clkdm_add_autodeps()
> and _clkdm_del_autodeps() if no autodeps were passed in.  What do you
> think about something like the following instead?
>
>
> - Paul

Your suggested patch looks right to me as well.
