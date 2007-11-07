Return-Path: <linux-kernel-owner+w=401wt.eu-S1758987AbXKGTU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987AbXKGTU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 14:20:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbXKGTUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 14:20:50 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:48549 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703AbXKGTUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 14:20:50 -0500
Date: Wed, 7 Nov 2007 14:20:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: bbpetkov@yahoo.de, Andy Whitcroft <apw@shadowen.org>,
       linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [PATCH] mm/memory.c: remove warning from an uninitialized
	spinlock. was: Re: 2.6.21-rc7-mm2
Message-ID: <20071107192003.GA22286@goodmis.org>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org> <20070426182519.GA4532@gollum.tnic> <20070427172230.94b82829.akpm@linux-foundation.org> <4633DD55.1020006@shadowen.org> <20070429065049.GB4446@gollum.tnic> <20070429022440.cb8fc8c4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070429022440.cb8fc8c4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Introduce a macro for suppressing gcc from generating a warning about a
> probable uninitialized state of a variable.
> 
> Example:
> 
> -	spinlock_t *ptl;
> +	spinlock_t *uninitialized_var(ptl);
> 
> Not a happy solution, but those warnings are obnoxious.
> 
> - Using the usual pointlessly-set-it-to-zero approach wastes several
>   bytes of text.
> 
> - Using a macro means we can (hopefully) do something else if gcc changes
>   cause the `x = x' hack to stop working
> 
> - Using a macro means that people who are worried about hiding true bugs
>   can easily turn it off.
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

I just stumbled across this being in the kernel. Well, I'm finally glad
it made it in, even though it was suggested one year earlier ;-)

  http://lkml.org/lkml/2006/5/11/50

-- Steve

