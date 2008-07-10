Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbYGJHZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbYGJHZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 03:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753701AbYGJHYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 03:24:48 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:60121 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283AbYGJHYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 03:24:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=XFXnMGV1MKjhOm0QWaq1qFl4p5CjgS4mNOo9gLjT3bd9iKtCsCi6Z3jqybj1RiPz5S
         Noj+sBotNwzvQA+BduL0crz4cprrz6lHyRZAgpF3nxjJT1wPpsqrnWD3/n42xv17Uo9N
         uHIPhAPCqEsur3+wevyoHqYalfsqj1fxPdABo=
Message-ID: <84144f020807100024x7f20847bs72347fd9be515eea@mail.gmail.com>
Date: Thu, 10 Jul 2008 10:24:45 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: linux-next: Tree for July 9 (kmemcheck: Caught 8-bit read from freed memory (ffff880127c120e8))
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-next@vger.kernel.org,
       "Stephen Rothwell" <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Christoph Lameter" <cl@linux-foundation.org>
In-Reply-To: <19f34abd0807100019t392621dci306420150343d13d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080709183047.0eb1eb72.sfr@canb.auug.org.au>
	 <200807100017.04397.rjw@sisk.pl> <200807100025.13973.rjw@sisk.pl>
	 <19f34abd0807100019t392621dci306420150343d13d@mail.gmail.com>
X-Google-Sender-Auth: 887f11b5812d9ffe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vegard,

On Thu, Jul 10, 2008 at 10:19 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> Also, the error report is bogus. We should make kmemcheck depend on
> !CONFIG_DEBUG_SLAB && !CONFIG_SLUB_DEBUG_ON for now, because these
> modes interfere with the checking that kmemcheck does.

Agreed.

On Thu, Jul 10, 2008 at 10:19 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> That said, we *might* be able to do a kmemcheck_off()/kmemcheck_on()
> thing around the special code. Maybe a kmemcheck_read()  which
> bypasses the checking for a single read.
>
> But I really do think kmemcheck and slab/slub debugging should be
> mutually exclusive. They do essentially the same thing, except that
> kmemcheck is much more eager and detects problems right where they
> happen (though sometimes too eagerly too; the false positives).

I'm not so sure about this. You ought to be able to compile-in SLUB
debugging and kmemcheck support but only enable one of them at
run-time.

                         Pekka
