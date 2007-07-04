Return-Path: <linux-kernel-owner+w=401wt.eu-S1758873AbXGDBEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758873AbXGDBEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 21:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbXGDBEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 21:04:15 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:45614 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415AbXGDBEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 21:04:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LROYGMk+6ieAgsjBGpa1DZX0kt1GdAsGQbsg7Map9PDp8aL6K7bwPJsFj85DfkYF/bwfp9pgp4kjDxHE2BgMma19R2ukoXZ3rodVSLvuVnQSK/QCTY6Dv3q7RMotjOTxpdBuYQXtcAabSEeVe0vX6kR+ha7Yh8yHYKhBwKMqWPQ=
Message-ID: <9a8748490707031804v51ca1c79kdf55150c47b01b3d@mail.gmail.com>
Date: Wed, 4 Jul 2007 03:04:13 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH][isapnp] Fix a potential NULL pointer dereference in isapnp_read_tag()
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jaroslav Kysela" <perex@suse.cz>
In-Reply-To: <20070703130318.9dbec3ac.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707010138.32075.jesper.juhl@gmail.com>
	 <20070703130318.9dbec3ac.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sun, 1 Jul 2007 01:38:31 +0200
> Jesper Juhl <jesper.juhl@gmail.com> wrote:
>
> > The Coverity checker spotted (as bug #809) that we dereference 'type'
> > long before we actually test it against NULL in
> > drivers/pnp/isapnp/core.c::isapnp_read_tag() - both branches of the
> > 'if (tag & 0x80)' dereference type, and since this 'if' is before the test
> > against NULL and the return of -1, this will blow up is ever type is NULL.
> > This is easy to fix by simply moving the NULL test to the beginning of
> > the function.
> >
[snip]
>
> dood, look at the callers.  NULL is not possible here.
>
You are right, there's absolutely no way that we could get a NULL
pointer there - that was sloppy of me :-(

I guess we should just get rid of the check completely.  I'll cook up
a patch for that tomorrow.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
